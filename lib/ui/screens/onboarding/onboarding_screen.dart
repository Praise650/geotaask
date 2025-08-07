import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/app_setup.locator.dart';
import '../../../core/exceptions/location_exception.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../../core/services/geo_fence_service.dart';
import '../../../core/services/location_service.dart';
import '../../widgets/app_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
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
                    onPressed: () {
                      // Handle start button press
                      // _onStartPressed(context);
                      // Show explanation dialog
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Background Location Permission'),
                              content: Text(
                                'This app needs background location access to trigger geofences when you enter or exit specific areas.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    setupGeofences();
                                  },
                                  child: Text('Grant Permission'),
                                ),
                              ],
                            ),
                      );
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
            ),
          ),
        ),
      ),
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

  Future<bool> requestBackgroundLocationPermission() async {
    // Request foreground location permission
    PermissionStatus foregroundStatus =
        await Permission.locationWhenInUse.request();

    if (foregroundStatus.isGranted) {
      // Request background location permission
      PermissionStatus backgroundStatus =
          await Permission.locationAlways.request();

      if (backgroundStatus.isGranted) {
        print('Background location permission granted');
        return true;
      } else if (backgroundStatus.isDenied ||
          backgroundStatus.isPermanentlyDenied) {
        print('Background location permission denied');
        if (backgroundStatus.isPermanentlyDenied) {
          // Guide user to app settings
          await openAppSettings();
        }
        return false;
      }
    } else {
      print('Foreground location permission denied');
      if (foregroundStatus.isPermanentlyDenied) {
        // Guide user to app settings
        await openAppSettings();
      }
      return false;
    }
    return false;
  }

  void setupGeofences() async {
    bool hasPermission = await requestBackgroundLocationPermission();

    if (hasPermission) {
      try {
        // Initialize geofencing
        await locator<GeoFenceService>().initializeFencing();
        router.go(Paths.HOME);
      } on LocationServiceDisabledException {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Location Services Disabled'),
                content: const Text('Please enable location services.'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await locator<LocationService>().openLocationSettings();
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
        );
      } on LocationPermissionDeniedException catch (e) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Permission Denied'),
                content: Text(e.message),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      if (e.message.contains('permanently denied')) {
                        await locator<LocationService>().openAppSettings();
                      }
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
        );
      } catch (e) {
        print('Error setting up geofence: $e');
        // Optionally show user feedback (e.g., a dialog)
      }
    } else {
      print('Cannot set up geofences without background location permission');
      // Show user a dialog explaining why permission is needed
      // Example: showDialog(...);
    }
  }
}
