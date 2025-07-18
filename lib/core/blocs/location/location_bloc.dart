import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/location_exception.dart';
import '../../model/location_entity.dart';
import '../../services/location_service.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService;

  LocationBloc(this._locationService) : super(LocationInitial()) {
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<GetCoordinateAddress>(_onGetLocationAddress);
    on<GetAddressCoordinate>(_onGetLocationCoordinate);
  }

  // Handle getting current location
  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    try {
      final position = await _locationService.getCurrentPosition();
      emit(LocationLoaded(position));
    } on LocationServiceDisabledException catch (e) {
      emit(
        LocationError(
          'Location services are disabled. Please enable them in settings.',
        ),
      );
    } on LocationPermissionDeniedException catch (e) {
      emit(
        LocationError(
          'Location permission denied. Please grant permission in settings.',
        ),
      );
    } catch (e) {
      emit(LocationError('Failed to get location: ${e.toString()}'));
    }
  }

  // Handle getting current location
  Future<void> _onGetLocationAddress(
    GetCoordinateAddress event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    try {
      final address = await _locationService.getAddressFromCoordinates(
        event.latitude, event.longitude);

      // Create a LocationEntity with the address if your service returns coordinates too
      // OR emit a new state type for address-only results
      emit(
        LocationAddressLoaded(
          LocationEntity(
            latitude: event.latitude,
            longitude: event.longitude,
            timestamp: DateTime.now(),
            address: address,
          ),
        ),
      );
    } on LocationServiceDisabledException catch (e) {
      emit(
        LocationError(
          'Location services are disabled. Please enable them in settings.',
        ),
      );
    } on LocationPermissionDeniedException catch (e) {
      emit(
        LocationError(
          'Location permission denied. Please grant permission in settings.',
        ),
      );
    } catch (e) {
      emit(LocationError('Failed to get address: ${e.toString()}'));
    }
  }

  Future<void> _onGetLocationCoordinate(
    GetAddressCoordinate event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    try {
      final location = await _locationService.getCoordinatesFromAddress(
        event.address);

      emit(AddressCoordinateLoaded(location));
    } on LocationServiceDisabledException catch (e) {
      emit(
        LocationError(
          'Location services are disabled. Please enable them in settings.',
        ),
      );
    } on LocationPermissionDeniedException catch (e) {
      emit(
        LocationError(
          'Location permission denied. Please grant permission in settings.',
        ),
      );
    } catch (e) {
      emit(LocationError('Failed to get location: ${e.toString()}'));
    }
  }
}
