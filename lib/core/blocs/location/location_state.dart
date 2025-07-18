// States - describe what condition the app is in
// location_state.dart

part of 'location_bloc.dart';

sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}  // Added missing loading state

final class LocationLoaded extends LocationState {
  final LocationEntity location;
  LocationLoaded(this.location);
}

final class LocationAddressLoaded extends LocationState {
  final LocationEntity address;
  LocationAddressLoaded(this.address);
}

final class AddressCoordinateLoaded extends LocationState {
  final LocationEntity address;
  AddressCoordinateLoaded(this.address);
}

final class LocationError extends LocationState {  // Consider error handling
  final String message;
  LocationError(this.message);
}