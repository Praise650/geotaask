import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/app_logo.dart';
import '../cubit/onboarding_cubit.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),

        AppLogo(),

        const SizedBox(height: 16),

        // Subtitle
        Text(
          'Stay connected with location-based notifications and reminders',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 60),

        // Features
        _buildFeatureItem(
          icon: Icons.notifications_active,
          title: 'Smart Notifications',
          description:
          'Get notified when you enter or leave specific areas',
        ),

        const SizedBox(height: 20),

        _buildFeatureItem(
          icon: Icons.map,
          title: 'Custom Zones',
          description:
          'Create personalized geofences for work, home, and more',
        ),

        const SizedBox(height: 20),

        _buildFeatureItem(
          icon: Icons.battery_saver,
          title: 'Battery Optimized',
          description:
          'Efficient location tracking that saves your battery',
        ),

        const Spacer(),

        // Start Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              final cubit = context.read<OnboardingCubit>();
              cubit.nextStep();
            },
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Privacy note
        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}