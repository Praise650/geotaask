import 'package:flutter/material.dart';
import 'package:geotaask/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../ui/layout/bottom_nav_layout.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/home_example/home_example.dart';
import '../../ui/screens/native_geofence/native_home_screen.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/onboarding/splash_screen.dart';
import '../../ui/screens/profile/pofile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final scaffoldKey = GlobalKey<ScaffoldState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final router = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  restorationScopeId: "app",
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
      path: Paths.HOMEEXAMPLE,
      name: Routes.HOMEEXAMPLE,
      builder: (context, state) => const NativeMyApp(),
      /// revert to [HomeExample()] later
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
        // GoRoute(
        //   path: Paths.SERVICES,
        //   name: Routes.SERVICES,
        //   parentNavigatorKey: _shellNavigatorKey,
        //   builder: (context, state) => const ServicesScreen(),
        // ),
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
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
