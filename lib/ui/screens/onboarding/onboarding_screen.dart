// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/services/onboarding_manager.dart';
// import '../../dialogs/location_permission_dialog.dart';
// import 'parts/avatar_setup.dart';
// import 'parts/preferences_step.dart';
// import 'parts/user_form_screen.dart';
// import 'parts/welcome_step.dart';
//
// class ProfileSetupScreen extends StatefulWidget {
//   const ProfileSetupScreen({super.key});
//
//   @override
//   State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
// }
//
// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   PageController _pageController = PageController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentStep();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileSetupCubit, int>(
//         builder: (context, _currentStep) {
//         return Scaffold(
//           extendBody: true,
//           extendBodyBehindAppBar: true,
//           // appBar: AppBar(
//           //   automaticallyImplyLeading: true,
//           //   backgroundColor: Colors.white,
//           //   leading: IconButton(
//           //     icon: const Icon(Icons.keyboard_arrow_left),
//           //     onPressed: () => router.pop(),
//           //   ),
//           //   title: const Text("Set Profile Avatar"),
//           //   elevation: 5,
//           // ),
//           body: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if(_currentStep > 0)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.keyboard_arrow_left,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     _pageController.previousPage(
//                       duration: Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: PageView.builder(
//                       controller: _pageController,
//                       physics: NeverScrollableScrollPhysics(),
//                       onPageChanged: (index) async {
//                         setState(() => _currentStep = index);
//                         await OnboardingManager.saveCurrentStep(index);
//                       },
//                       itemCount: _steps.length,
//                       itemBuilder: (context, index) {
//                         return _steps[index].widget;
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: Container(
//             color: Colors.transparent,
//             padding: EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: _nextStep,
//                   child: Text(_currentStep == _steps.length - 1 ? 'Finish' : 'Next'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
// }
//
// class ProfileSetupCubit extends Cubit<int> {
//   ProfileSetupCubit():super(0);
//
//
//   final List<OnboardingStep> _steps = [
//     OnboardingStep(
//       title: "Welcome",
//       description: "Welcome to our app!",
//       widget: WelcomeStep(),
//     ),
//     OnboardingStep(
//       title: "Profile Setup",
//       description: "Let's set up your profile",
//       widget: UserFormScreen(),
//     ),
//     OnboardingStep(
//       title: "Avatar Setup",
//       description: "Let's set up your avatar",
//       widget: AvatarSetup(),
//     ),
//     OnboardingStep(
//       title: "Preferences",
//       description: "Choose your preferences",
//       widget: PreferencesStep(),
//     ),
//   ];
//
//   Future<void> _loadCurrentStep() async {
//     final step = await OnboardingManager.getCurrentStep();
//     setState(() {
//       _currentStep = step;
//     });
//     _pageController = PageController(initialPage: step);
//   }
//
//   Future<void> _nextStep() async {
//     if (_currentStep < _steps.length - 1) {
//       _currentStep++;
//       await OnboardingManager.saveCurrentStep(_currentStep);
//       _pageController.nextPage(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       await OnboardingManager.completeOnboarding();
//       _navigateToMain();
//     }
//   }
//
//   Future<void> _navigateToMain() async {
//     // Handle start button press
//     // _onStartPressed(context);
//     // Show explanation dialog
//     await showDialog(
//       context: context,
//       builder:
//           (context) => LocationPermissionDialog(),
//     );
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Load current step when widget initializes
    context.read<OnboardingCubit>().loadCurrentStep();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        // Update PageController when step changes
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            state.currentStep,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        // Initialize PageController with current step
        if (!_pageController.hasClients) {
          _pageController = PageController(initialPage: state.currentStep);
        }

        final cubit = context.read<OnboardingCubit>();

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.currentStep > 0)
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      cubit.previousStep();
                    },
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        // This will be handled by the BLoC
                      },
                      itemCount: cubit.steps.length,
                      itemBuilder: (context, index) {
                        return cubit.steps[index].widget;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}