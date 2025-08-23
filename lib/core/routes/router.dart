import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/screens/theme_example/theme_example_screen.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/theme_example/theme_example.dart';
import '../../ui/screens/settings/settings_screen.dart';
import '../../ui/screens/history/history_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/layout/bottom_nav_layout.dart';
import '../../ui/screens/home/home_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final scaffoldKey = GlobalKey<ScaffoldState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final router = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  restorationScopeId: "app",
  // redirect: (context, state) async {
  //   // Check if we're already on splash or trying to go somewhere specific
  //   if (state.uri.toString() == '/splash') {
  //     return null; // Allow splash screen
  //   }
  //
  //   // For all other routes, check onboarding status
  //   final isOnboardingCompleted = await OnboardingManager.isOnboardingCompleted();
  //
  //   if (!isOnboardingCompleted) {
  //     final currentStep = await OnboardingManager.getCurrentStep();
  //     return '/onboarding?step=$currentStep';
  //   }
  //
  //   return null; // Allow the route
  // },
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.SPLASH,
      name: Routes.SPLASH,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.ONBOARDING,
      name: Routes.ONBOARDING,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.THEMEEXAMPLE,
      name: Routes.THEMEEXAMPLE,
      builder: (context, state) => const ThemeExample(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.THEMEEXAMPLESCREEN,
      name: Routes.THEMEEXAMPLESCREEN,
      builder: (context, state) => const ThemeExampleScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, child) => BottomNavLayout(child: child),
      routes: [
        GoRoute(
          path: Paths.HOME,
          name: Routes.HOME,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Paths.HISTORY,
          name: Routes.HISTORY,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HistoryScreen(),
        ),
        // GoRoute(
        //   path: Paths.WALLET,
        //   name: Routes.WALLET,
        //   parentNavigatorKey: _shellNavigatorKey,
        //   builder: (context, state) => const WalletScreen(),
        // ),
        GoRoute(
          path: Paths.PROFILE,
          name: Routes.PROFILE,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
