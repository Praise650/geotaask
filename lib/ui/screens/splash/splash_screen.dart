import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:geotaask/core/routes/routes.dart';

import '../../../core/services/onboarding_manager.dart';
import '../../../core/routes/router.dart';
import '../../../app/res/svgs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.extralong4, _checkOnboardingStep);
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
          color: Color(0xff1B263B),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Svgs.logo,
                height: 92,
                width: 111,
                color: Colors.white,
              ),
              SizedBox(height: 23),
              Text(
                "GeoTaask",
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 11),
              Text(
                "Remind, Track, Achieve",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
