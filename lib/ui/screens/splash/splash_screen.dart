import 'package:flutter/material.dart';
import 'package:geotaask/core/routes/routes.dart';

import '../../../core/routes/router.dart';
import '../../../core/services/onboarding_manager.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Durations.extralong4,
      _checkOnboardingStep,
    );
  }

  void _checkOnboardingStep() async {
    final snapshot = await OnboardingManager.isOnboardingCompleted();

    if (snapshot == true) {
      router.go(
        Paths.HOME,
      );
    } else {
      router.go(
        Paths.ONBOARDING,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}
