// home_state.dart
part of 'home_example_bloc.dart';

sealed class HomeExampleState {}

final class HomeInitial extends HomeExampleState {}

final class HomeLoading extends HomeExampleState {}

final class HomeLoaded extends HomeExampleState {
  final LocationEntity? userLocation;
  final bool isRefreshing;
  final UserEntity? currentUser;

  HomeLoaded({
    this.userLocation,
    this.isRefreshing = false,
    this.currentUser,
  });

  HomeLoaded copyWith({
    LocationEntity? userLocation,
    bool? isRefreshing,
    UserEntity? currentUser,
  }) {
    return HomeLoaded(
      userLocation: userLocation ?? this.userLocation,
      isRefreshing: isRefreshing ?? this.isRefreshing,
        currentUser: currentUser ?? this.currentUser,
    );
  }
}

final class HomeError extends HomeExampleState {
  final String message;
  final LocationEntity? lastKnownLocation;

  HomeError(this.message, {this.lastKnownLocation});
}