import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dialogs/location_permission_dialog.dart';
import '../../../widgets/customs/header_widget.dart';
import '../cubit/onboarding_cubit.dart';

class PreferencesStep extends StatefulWidget {
  const PreferencesStep({super.key});

  @override
  State<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep> {
  void enablePermission() async {
    final cubit = context.read<OnboardingCubit>();
    await cubit.saveUserDetail().then(onValue).catchError(onError);
    await cubit.nextStep();
  }

  Future<void> onValue(bool value) async {
    if (value == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile created successfully"),
        ),
      );
      await showDialog(
        context: context,
        builder: (context) => LocationPermissionDialog(),
      );
    }
  }

  Future<void> onError(error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        showCloseIcon: true,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeaderWidget(
          title: "Permission Preference",
          subtitle:
              "GeoTaask requires background location access to trigger geofences"
              " when you enter or exit specific areas.",
          subTextStyle: TextStyle(color: Colors.white, fontSize: 14),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),

        const SizedBox(height: 60),

        const SizedBox(height: 20),

        const Spacer(),

        // Start Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: enablePermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Privacy note
        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy',
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
