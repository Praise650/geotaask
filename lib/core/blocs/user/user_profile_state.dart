part of 'user_profile_bloc.dart';

sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

final class UserProfileLoaded extends UserProfileState {
  final UserEntity? userEntity;
  final bool isRefreshing;
  UserProfileLoaded({this.userEntity, this.isRefreshing = false});

  UserProfileLoaded copyWith({
    UserEntity? userEntity, bool? isRefreshing}) => UserProfileLoaded(
      userEntity: userEntity ?? this.userEntity,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
}

final class UserProfileError extends UserProfileState{
  final String error;

  UserProfileError(this.error);
}