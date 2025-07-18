part of 'user_profile_bloc.dart';

sealed class UserProfileEvent {}

final class FetchUserProfile extends UserProfileEvent {}

final class UpdateUserProfile extends UserProfileEvent {
  final String userId;
  UpdateUserProfile(this.userId);
}