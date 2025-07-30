part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeRefreshing extends HomeState {
  // Keep previous data while refreshing
  final HomeLoaded previousState;

  HomeRefreshing(this.previousState);
}

final class HomeLoaded extends HomeState {
  final UserEntity? userProfile;
  final LocationEntity? userLocation;
  final List<MarkerEntity> locationTags;
  final bool hasPermissions;

  HomeLoaded({
    this.userProfile,
    this.userLocation,
    this.locationTags = const [],
    required this.hasPermissions,
  });

  HomeLoaded copyWith({
    UserEntity? userProfile,
    LocationEntity? userLocation,
    List<MarkerEntity>? locationTags, // Add this // Add this
    bool? isRefreshing,
    bool? hasPermissions}) {
    return HomeLoaded(
      userProfile: userProfile ?? this.userProfile,
      userLocation: userLocation ?? this.userLocation,
      locationTags: locationTags ?? this.locationTags,
      hasPermissions: hasPermissions ?? this.hasPermissions,
    );
  }
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

// Consider adding more specific states if needed:
final class HomePermissionsDenied extends HomeState {}

final class HomeLocationError extends HomeState {
  final String error;

  HomeLocationError(this.error);
}

final class LocationAddressLoading extends HomeState {}

final class LocationAddressSuccess extends HomeState {
  final double lat, log;

  LocationAddressSuccess({required this.lat, required this.log});
}

