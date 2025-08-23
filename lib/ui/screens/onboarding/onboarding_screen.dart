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
              color: Color(0xff1B263B),
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