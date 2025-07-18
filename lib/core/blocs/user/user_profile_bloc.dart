import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/user_repository.dart';
import '../../model/user_entity.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;

  UserProfileBloc(this._userRepository) : super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try {
      final userResult = await _userRepository.fetchUserProfile();
      emit(UserProfileLoaded(userEntity: userResult));
    } catch (e) {
      emit(UserProfileError("Unable to fetch user profile ${e.toString()}"));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try {
      if (state is UserProfileLoaded) {
        final currentState = state as UserProfileLoaded;
        emit(currentState.copyWith(isRefreshing: true));
        await _userRepository.updateUserProfile(currentState.userEntity!);
        emit(
          currentState.copyWith(
            userEntity: currentState.userEntity,
            isRefreshing: true,
          ),
        );
      }
    } catch (e) {
      emit(UserProfileError("Unable to fetch user profile ${e.toString()}"));
    }
  }
}
