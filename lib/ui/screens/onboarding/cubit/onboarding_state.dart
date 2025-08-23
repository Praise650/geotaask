// State class for ProfileSetupCubit

part of 'onboarding_cubit.dart';

class OnboardingState {
  final int currentStep;
  final bool isLoading;
  final bool isImgSelected;

  const OnboardingState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isImgSelected = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isImgSelected,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isImgSelected: isImgSelected ?? this.isImgSelected,
    );
  }
}