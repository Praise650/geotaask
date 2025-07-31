// home_example_bloc.dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/location/location_bloc.dart';
import '../../../../core/blocs/user/user_profile_bloc.dart';
import '../../../../core/model/location_entity.dart';
import '../../../../core/model/user_entity.dart';
import '../../../../core/repos/home_repo.dart';

part 'home_example_state.dart';
part 'home_example_event.dart';

class HomeExampleBloc extends Bloc<HomeExampleEvent, HomeExampleState> {
  final LocationBloc _locationBloc;
  final UserProfileBloc _profileBloc;
  final HomeRepository _repository;
  StreamSubscription<LocationState>? _locationSubscription;

  HomeExampleBloc(this._locationBloc, this._repository, this._profileBloc)
    : super(HomeInitial()) {
    on<HomeExampleStarted>(_onHomeStarted);
    on<GetExampleCoordinateAddress>(_onGetCoordinateAddress);
    on<FetchUserLocation>(_onFetchUserLocation);
    on<RefreshLocation>(_onRefreshLocation);
    on<LocationUpdated>(_onLocationUpdated);
    on<LocationFetchFailed>(_onLocationFetchFailed);

    // Listen to LocationBloc state changes
    _locationSubscription = _locationBloc.stream.listen((locationState) {
      _handleLocationStateChange(locationState);
    });
  }

  // handle initstate for page
  Future<void> _onHomeStarted(
    HomeExampleStarted event,
    Emitter<HomeExampleState> emit,
  ) async {
    emit(HomeLoading());

    try {
      // Start fetching user profile
      _profileBloc.add(FetchUserProfile());

      // Request location permissions and get location
      _locationBloc.add(GetCurrentLocation());

      final currentUserState = _profileBloc.state;
      final currentLocationState = _locationBloc.state;
      LocationEntity? userLocation;
      bool hasPermissions = false;
      UserEntity? user;

      if (currentUserState is UserProfileLoaded) {
        user = currentUserState.userEntity;
      }

      if (currentLocationState is LocationLoaded) {
        userLocation = currentLocationState.location;
        hasPermissions = true;
      } else if (currentLocationState is LocationError) {
        hasPermissions = false;
        // You might want to emit a different state or handle this case
      }

      developer.log("Location State: ${userLocation.toString()}");
      developer.log("User State: ${user?.toJson()}");

      emit(
        HomeLoaded(
          userLocation: userLocation,
          isRefreshing: false,
          currentUser: user,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  //is this also right
  // Handle fetching user location
  // Future<void> _onGetCoordinateAddress(
  //     GetCoordinateAddress event, Emitter<HomeExampleState> emit) async {
  //   if (state is HomeLoaded) {
  //     emit((state as HomeLoaded).copyWith(isRefreshing: true));
  //   } else {
  //     emit(HomeLoading());
  //   }
  //
  //   // Trigger location fetch in LocationBloc
  //   _locationBloc.add(GetCoordinateAddress(event.latitude, event.longitude));
  // }

  // CORRECTED BLOC EVENT HANDLER
  // In your HomeExampleBloc:
  Future<void> _onGetCoordinateAddress(
    GetExampleCoordinateAddress event,
    Emitter<HomeExampleState> emit,
  ) async {
    // Get current location first if not available
    LocationEntity? currentLocation;
    if (state is HomeLoaded) {
      final homeState = state as HomeLoaded;
      emit(homeState.copyWith(isRefreshing: true));
      currentLocation = homeState.userLocation;
    } else {
      emit(HomeLoading());
    }

    // If no location available, fetch it first
    if (currentLocation == null) {
      // You might need to fetch location first
      emit(HomeError('No location available to get address'));
      return;
    }

    // Trigger location address fetch in LocationBloc
    _locationBloc.add(
      GetCoordinateAddress(currentLocation.latitude, currentLocation.longitude),
    );

    // Listen to LocationBloc state changes to update HomeBloc accordingly
    // This should be set up in your bloc's constructor or init method
  }

  // Handle fetching user location
  Future<void> _onFetchUserLocation(
    FetchUserLocation event,
    Emitter<HomeExampleState> emit,
  ) async {
    emit(HomeLoading());

    // Trigger location fetch in LocationBloc
    _locationBloc.add(GetCurrentLocation());
  }

  // Handle refreshing location
  Future<void> _onRefreshLocation(
    RefreshLocation event,
    Emitter<HomeExampleState> emit,
  ) async {
    // Show refreshing state while maintaining current data
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(isRefreshing: true));

      // Trigger location refresh in LocationBloc
      _locationBloc.add(GetCurrentLocation());
      _profileBloc.add(FetchUserProfile());

      final currentUserState = _profileBloc.state;
      final currentLocationState = _locationBloc.state;
      LocationEntity? userLocation;
      bool hasPermissions = false;
      UserEntity? user;

      if (currentUserState is UserProfileLoaded) {
        user = currentUserState.userEntity;
      }

      if (currentLocationState is LocationLoaded) {
        userLocation = currentLocationState.location;
        hasPermissions = true;
      } else if (currentLocationState is LocationError) {
        hasPermissions = false;
        // You might want to emit a different state or handle this case
      }

      developer.log("Location State: ${userLocation.toString()}");
      developer.log("User State: ${user?.toJson()}");

      emit(
        (state as HomeLoaded).copyWith(
          isRefreshing: false,
          currentUser: user,
          userLocation: userLocation,
        ),
      );
    } else {
      emit(HomeLoading());
    }
  }

  // Handle location updates from LocationBloc
  void _onLocationUpdated(
    LocationUpdated event,
    Emitter<HomeExampleState> emit,
  ) {
    emit(HomeLoaded(userLocation: event.location, isRefreshing: false));
  }

  // Handle location fetch failures
  void _onLocationFetchFailed(
    LocationFetchFailed event,
    Emitter<HomeExampleState> emit,
  ) {
    final lastLocation =
        state is HomeLoaded ? (state as HomeLoaded).userLocation : null;

    emit(HomeError(event.error, lastKnownLocation: lastLocation));
  }

  // Handle LocationBloc state changes
  void _handleLocationStateChange(LocationState locationState) {
    switch (locationState) {
      case LocationLoaded():
        add(LocationUpdated(locationState.location));
        break;
      case LocationError():
        add(LocationFetchFailed(locationState.message));
        break;
      case LocationLoading():
        // LocationBloc is loading, HomeBloc can choose to show loading or not
        break;
      case LocationInitial():
        // Do nothing or reset state if needed
        break;
      case LocationAddressLoaded():
        add(LocationUpdated(locationState.address));
      case AddressCoordinateLoaded():
        add(LocationUpdated(locationState.address));
    }
  }

  // Helper methods
  Future<void> _fetchUserProfile([String? userId]) async {
    // Implement your user profile fetching logic here
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
