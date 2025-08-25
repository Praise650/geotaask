import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/screens/onboarding/cubit/onboarding_cubit.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';
import 'ui/layout/cubit/bottom_nav_layout_bloc.dart';
import 'core/blocs/location/location_bloc.dart';
import 'core/blocs/geofence/geofence_bloc.dart';
import 'core/blocs/user/user_profile_bloc.dart';
import 'core/services/location_service.dart';
import 'ui/screens/home/bloc/home_bloc.dart';
import 'core/blocs/places/places_bloc.dart';
import 'core/blocs/theme/theme_bloc.dart';
import 'core/repos/user_repository.dart';
import 'core/repos/location_repo.dart';
import 'core/services/api_client.dart';
import 'app/app_setup.locator.dart';
import 'core/repos/home_repo.dart';
import 'core/db/app_database.dart';
import 'ui/style/app_themes.dart';
import 'core/routes/router.dart';
import 'app/app_setup.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set fullscreen
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  await AppDatabase.init();
  await AppSetup.initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (_) => HomeRepositoryImpl(
            dbService: AppDatabase.instance,
          ),
          lazy: false,
        ),
        RepositoryProvider<LocationRepository>(
          create: (_) => LocationRepositoryImpl(
            locationService: locator<LocationService>(),
            apiClient: ApiClient(),
          ),
          lazy: false,
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepositoryImpl(
            dbService: AppDatabase.instance,
          ),
          lazy: false,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(
            lazy: true,
            create: (cxt) => LocationBloc(
              cxt.read<LocationRepository>(),
            ),
          ),
          BlocProvider<PlacesBloc>(
            create: (_) => PlacesBloc(
              ApiClient(),
            ),
          ),
          BlocProvider<GeofenceBloc>(
            lazy: true,
            create: (cxt) => GeofenceBloc(
              cxt.read<HomeRepository>(),
            ),
          ),
          BlocProvider<UserProfileBloc>(
            lazy: true,
            create: (cxt) => UserProfileBloc(
              cxt.read<UserRepository>(),
            ),
          ),
          BlocProvider<BottomNavLayoutCubit>(
            create: (_) => BottomNavLayoutCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => OnboardingCubit(),
            lazy: false,
            child: OnboardingScreen(),
          ),
          BlocProvider(
           create: (context) => ThemeBloc(),
          ),
          BlocProvider<HomeBloc>(
            create: (cxt) => HomeBloc(
              cxt.read<LocationBloc>(), // Inject LocationBloc
              cxt.read<HomeRepository>(), // Inject HomeRepo
              cxt.read<UserProfileBloc>(), // Inject HomeRepo
            ),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, theme) {
            return MaterialApp.router(
              title: 'GeoTaask',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              routerDelegate: router.routerDelegate,
              scaffoldMessengerKey: scaffoldMessengerKey,
              routeInformationParser: router.routeInformationParser,
              routeInformationProvider: router.routeInformationProvider,
              builder: (context, child) => child!,
            );
          }
        ),
      ),
    );
  }
}
