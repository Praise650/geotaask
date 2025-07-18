// Events - describe actions that happen

part of 'location_bloc.dart';

sealed class LocationEvent {}

// User requests location
final class GetCurrentLocation extends LocationEvent {}

// User requests location
final class GetCoordinateAddress extends LocationEvent {
  final double longitude;
  final double latitude;

  GetCoordinateAddress(this.latitude, this.longitude);
}

final class GetAddressCoordinate extends LocationEvent {
  final String address;

  GetAddressCoordinate({required this.address});
}