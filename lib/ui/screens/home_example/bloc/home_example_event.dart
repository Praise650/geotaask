// home_event.dart
part of 'home_example_bloc.dart';

sealed class HomeExampleEvent {}

final class HomeExampleStarted extends HomeExampleEvent {}
final class GetExampleCoordinateAddress extends HomeExampleEvent {
  final double longitude;
  final double latitude;

  GetExampleCoordinateAddress(this.latitude, this.longitude);
}
final class FetchUserLocation extends HomeExampleEvent {}
final class RefreshLocation extends HomeExampleEvent {}
final class LocationUpdated extends HomeExampleEvent {
  final LocationEntity location;
  LocationUpdated(this.location);
}
final class LocationFetchFailed extends HomeExampleEvent {
  final String error;
  LocationFetchFailed(this.error);
}