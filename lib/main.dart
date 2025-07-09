import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/blocs/user/user_profile_bloc.dart';
import 'core/repos/home_repo.dart';
import 'core/repos/user_repository.dart';
import 'ui/screens/home_example/bloc/home_example_bloc.dart';
import 'ui/layout/cubit/bottom_nav_layout_bloc.dart';
import 'core/blocs/location/location_bloc.dart';
import 'core/services/geo_fence_service.dart';
import 'core/services/location_service.dart';
import 'ui/screens/home/bloc/home_bloc.dart';
import 'core/db/app_database.dart';
import 'core/routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set fullscreen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await AppDatabase.init();
  await _setupGeofencing();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (_) => HomeRepositoryImpl(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(
            lazy: true,
            create: (_) => LocationBloc(
              LocationService(),
            ),
          ),
          BlocProvider<UserProfileBloc>(
            lazy: true,
            create: (cxt) => UserProfileBloc(
              cxt.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (_) => BottomNavLayoutCubit(),
            lazy: false,
          ),
          BlocProvider<HomeExampleBloc>(
            create: (cxt) => HomeExampleBloc(
              cxt.read<LocationBloc>(),
              cxt.read<HomeRepository>(), // Inject HomeRepo
              cxt.read<UserProfileBloc>(),// Inject HomeRepo
              // Inject LocationBloc
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (cxt) => HomeBloc(
              cxt.read<LocationBloc>(), // Inject LocationBloc
              cxt.read<HomeRepository>(), // Inject HomeRepo
              cxt.read<UserProfileBloc>(),// Inject HomeRepo
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'GeoTaask',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerDelegate: router.routerDelegate,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          builder: (context, child) => child!,
        ),
      ),
    );
  }
}

Future<void> _setupGeofencing() async {
  try {
    await GeoFenceService().initializeFencing();
  } catch (e, s) {
    _onError(e, s);
  }
}

void _onError(Object error, StackTrace stackTrace) {
  dev.log('error: $error\n$stackTrace');
}
