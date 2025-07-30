part of 'home_bloc.dart';

sealed class HomeEvent {}

final class HomeStarted extends HomeEvent {}

final class HomeRefresh extends HomeEvent {}

final class RequestPermissions extends HomeEvent {}

final class FetchUserLocation extends HomeEvent {}

final class RefreshUserLocation extends HomeEvent {}

// final class GetLocationAddress extends HomeEvent {
//   final double longitude;
//   final double latitude;
//
//   GetLocationAddress(this.longitude, this.latitude);
// }
//
// final class GetAddressLocation extends HomeEvent {
//   final String address;
//
//   GetAddressLocation(this.address);
// }

final class UpdateMapCamera extends HomeEvent {
  final double latitude;
  final double longitude;
  final double? zoom;

  UpdateMapCamera({
    required this.latitude,
    required this.longitude,
    this.zoom,
  });
}

final class UpdateMarkers extends HomeEvent {
  final List<MarkerEntity> markers;

  UpdateMarkers(this.markers);
}