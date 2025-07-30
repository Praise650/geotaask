import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/location/location_bloc.dart';
import '../../../../core/blocs/user/user_profile_bloc.dart';
import '../../../../core/model/user_entity.dart';
import '../../../../core/model/location_entity.dart';
import '../../../../core/model/marker_entity.dart';
import '../../../../core/repos/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationBloc _locationBloc;
  final UserProfileBloc _profileBloc;
  final HomeRepository _repository;
  StreamSubscription<LocationState>? _locationSubscription;
  StreamSubscription<List<MarkerEntity>>? _markersSubscription;

  HomeBloc(this._locationBloc, this._repository, this._profileBloc)
      : super(HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeRefresh>(_onHomeRefresh);
    // on<RequestPermissions>(_onRequestPermissions);
    on<UpdateMarkers>(_onUpdateMarkers);
  }

  Future<void> _onHomeStarted(
      HomeStarted event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());

    try {
      // Dispatch events to fetch profile and location
      _profileBloc.add(FetchUserProfile());
      _locationBloc.add(GetCurrentLocation());

      // Listen to profile and location states using streams
      UserEntity? user;
      LocationEntity? userLocation;
      bool hasPermissions = false;

      // Wait for profile state
      await for (final profileState in _profileBloc.stream) {
        if (profileState is UserProfileLoaded) {
          user = profileState.userEntity;
          break; // Exit loop once we have the user
        } else if (profileState is UserProfileError) {
          emit(HomeError('Failed to load user profile: ${profileState.error}'));
          return;
        }
      }

      // Wait for location state
      await for (final locationState in _locationBloc.stream) {
        if (locationState is LocationLoaded) {
          userLocation = locationState.location;
          hasPermissions = true; // Assuming LocationLoaded has this field
          break; // Exit loop once we have the location
        } else if (locationState is LocationError) {
          emit(HomeError('Failed to load location: ${locationState.message}'));
          return;
        }
      }

      // Set up markers stream subscription
      _markersSubscription?.cancel(); // Cancel any existing subscription
      _markersSubscription = _repository.fetchGeoFenceMarkers().listen(
            (markers) {
          add(UpdateMarkers(markers)); // Trigger event to update markers
        },
        onError: (e) {
          emit(HomeError('Failed to load markers: ${e.toString()}'));
        },
      );

      // Emit success state with collected data
      emit(
        HomeLoaded(
          userProfile: user,
          userLocation: userLocation,
          hasPermissions: hasPermissions,
          locationTags: [], // Initial empty list; updated by stream
        ),
      );
    } catch (e, stackTrace) {
      dev.log('Error in _onHomeStarted: $e\n$stackTrace', name: 'HomeBloc');
      emit(HomeError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onHomeRefresh(
      HomeRefresh event,
      Emitter<HomeState> emit,
      ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeRefreshing(currentState));

      try {
        // Dispatch events to refresh profile and location
        _profileBloc.add(FetchUserProfile());
        _locationBloc.add(GetCurrentLocation());

        // Listen to profile and location states
        UserEntity? user = currentState.userProfile; // Preserve existing data
        LocationEntity? userLocation = currentState.userLocation;
        bool hasPermissions = currentState.hasPermissions;

        // Wait for profile state
        await for (final profileState in _profileBloc.stream) {
          if (profileState is UserProfileLoaded) {
            user = profileState.userEntity;
            break; // Exit loop once we have the user
          } else if (profileState is UserProfileError) {
            emit(
              HomeError(
                'Failed to refresh user profile: ${profileState.error}',
              ),
            );
            return;
          }
        }

        // Wait for location state
        await for (final locationState in _locationBloc.stream) {
          if (locationState is LocationLoaded) {
            userLocation = locationState.location;
            hasPermissions = true;
            break; // Exit loop once we have the location
          } else if (locationState is LocationError) {
            emit(
              HomeError('Failed to refresh location: ${locationState.message}'),
            );
            return;
          }
        }

        // Emit updated state (locationTags updated via stream)
        emit(
          HomeLoaded(
            userProfile: user,
            userLocation: userLocation,
            hasPermissions: hasPermissions,
            locationTags: currentState.locationTags, // Preserve current tags
          ),
        );
      } catch (e, stackTrace) {
        dev.log('Error in _onHomeRefresh: $e\n$stackTrace', name: 'HomeBloc');
        emit(
          HomeError(
            'An unexpected error occurred during refresh: ${e.toString()}',
          ),
        );
      }
    } else {
      // Trigger initialization if not in HomeLoaded state
      add(HomeStarted());
    }
  }

  // FutureOr<void> _onRequestPermissions(
  //     RequestPermissions event,
  //     Emitter<HomeState> emit,
  //     ) {
  //   // Implement permission request logic if needed
  //   _locationBloc.add(RequestLocationPermission());
  // }

  //on update markers event
  Future<void> _onUpdateMarkers(
      UpdateMarkers event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        currentState.copyWith(locationTags: event.markers),
      );
    } else {
      emit(
        HomeLoaded(
          userProfile: null,
          userLocation: null,
          hasPermissions: false,
          locationTags: event.markers,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _markersSubscription?.cancel();
    return super.close();
  }
}