import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/model/user_entity.dart';
import '../../../../core/services/onboarding_manager.dart';
import '../../../../core/model/onboarding_step.dart';
import '../../../../core/db/app_database.dart';
import '../parts/preferences_step.dart';
import '../parts/user_form_screen.dart';
import '../parts/avatar_setup.dart';
import '../parts/welcome_step.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  final List<OnboardingStep> _steps = const [
    OnboardingStep(
      title: "Welcome",
      description: "Welcome to our app!",
      widget: WelcomeStep(),
    ),
    OnboardingStep(
      title: "Profile Setup",
      description: "Let's set up your profile",
      widget: UserFormScreen(),
    ),
    OnboardingStep(
      title: "Avatar Setup",
      description: "Let's set up your avatar",
      widget: AvatarSetup(),
    ),
    OnboardingStep(
      title: "Preferences",
      description: "Choose your preferences",
      widget: PreferencesStep(),
    ),
  ];

  List<OnboardingStep> get steps => _steps;

  Future<void> loadCurrentStep() async {
    emit(state.copyWith(isLoading: true));
    try {
      final step = await OnboardingManager.getCurrentStep();
      emit(state.copyWith(currentStep: step, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error if needed
    }
  }

  Future<void> nextStep() async {
    if (state.currentStep < _steps.length - 1) {
      final nextStep = state.currentStep + 1;
      emit(state.copyWith(isLoading: true));

      try {
        await OnboardingManager.saveCurrentStep(nextStep);
        emit(state.copyWith(currentStep: nextStep, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        // Handle error if needed
      }
    } else {
      // Complete onboarding
      emit(state.copyWith(isLoading: true));
      try {
        await OnboardingManager.completeOnboarding();
        emit(state.copyWith(isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        // Handle error if needed
      }
    }
  }

  Future<void> previousStep() async {
    if (state.currentStep > 0) {
      final prevStep = state.currentStep - 1;
      emit(state.copyWith(isLoading: true));

      try {
        await OnboardingManager.saveCurrentStep(prevStep);
        emit(state.copyWith(currentStep: prevStep, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        // Handle error if needed
      }
    }
  }

  String? _userName, _address, _avatar, _bio;

  void saveUserName({String? userName, String? address, String? bio}) {
    _userName = userName;
    _address = address;
    _bio = bio;
  }

  void saveUserAvatar(String avatar) {
    _avatar = avatar;
    emit(state.copyWith(isImgSelected: true));
  }

  Future<bool> saveUserDetail() async {
    try {
      final userEntity = UserEntity(
        id: 0,
        userId: Uuid().v4(),
        address: _address,
        userName: _userName,
        avatar: _avatar,
        bio: _bio,
      );
      await AppDatabase.instance.taskDao.saveUser(userEntity);
      return true;
    } catch (e) {
      throw Exception("Error Failed to create user profile: $e");
    }
    return false;
  }
}
