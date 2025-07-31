import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/screens/home_example/bloc/home_example_bloc.dart';
import 'ui/layout/cubit/bottom_nav_layout_bloc.dart';
import 'core/services/notification_service.dart';
import 'core/blocs/location/location_bloc.dart';
import 'core/blocs/geofence/geofence_bloc.dart';
import 'core/blocs/user/user_profile_bloc.dart';
import 'core/services/location_service.dart';
import 'ui/screens/home/bloc/home_bloc.dart';
import 'core/model/location_entity.dart';
import 'core/repos/user_repository.dart';
import 'core/model/marker_entity.dart';
import 'core/callback_helpers.dart';
import 'app/app_setup.locator.dart';
import 'app/app_logger_setup.dart';
import 'core/repos/home_repo.dart';
import 'core/db/app_database.dart';
import 'core/routes/router.dart';
import 'app/app_setup.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  logger.debug('=== GEOFENCE TRIGGERED START ===', name: "GeoTaask");
  Workmanager().executeTask((taskName, inputData) async {
    // Set up dependencies for this isolate
    await AppDatabase.init();
    await setupLocator();
    await initLogging();
    logger.debug(
      '=== Executing workmanager task: $taskName ===',
      name: "GeoTaask",
    );
    try {
      /* doesn't work:
      Location location = Location();
      location.enableBackgroundMode(enable: true);
      LocationData currentLocation = await location.getLocation();
      // throws a java.lang.NullPointerException, hence we use Geolocator
      */
      // required for geolocation
      DartPluginRegistrant.ensureInitialized();
      final currentLocation = await getCurrentPositionWithFallback();

      final remindersInRange = await getBackgroundRemindersInRangeAndTime(
        LocationEntity(
          latitude: currentLocation!.latitude,
          longitude: currentLocation.longitude,
        ),
      );

      String message = '';
      for (MarkerEntity reminder in remindersInRange) {
        message += message.isEmpty ? '' : ', ${reminder.description}';
      }

      if (message.trim().isEmpty) {
        logger.debug(
          '=== Message is empty, skipping notification ===',
          name: "GeoTaask",
        );
      } else {
        await NotificationService().showLocalNotification(
          id: 0, // same ID updates/overwrites previous notification, intended
          title: "Howdy!",
          body: "GeoTaask reminds you: $message",
          payload: "GeoTaask reminder: $message",
        );
      }
    } catch (e, s) {
      _onError(e, s);
    }
    logger.debug('=== GEOFENCE TRIGGERED END ===', name: "GeoTaask");

    return Future.value(true);
  });
}

void _onError(Object error, StackTrace stackTrace) {
  logger.error(
    '=== Error executing workmanager task: $error\n$stackTrace ===',
    error: "$error\n$stackTrace",
    name: "GoeTaask",
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set fullscreen
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  await AppDatabase.init();
  AppSetup.initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (_) => HomeRepositoryImpl(),
          lazy: false,
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepositoryImpl(),
          lazy: false,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(
            lazy: true,
            create: (_) => LocationBloc(
              locator<LocationService>(),
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
          BlocProvider<HomeExampleBloc>(
            create:
                (cxt) => HomeExampleBloc(
                  cxt.read<LocationBloc>(),
                  cxt.read<HomeRepository>(), // Inject HomeRepo
                  cxt.read<UserProfileBloc>(), // Inject HomeRepo
                  // Inject LocationBloc
                ),
          ),
          BlocProvider<HomeBloc>(
            create:
                (cxt) => HomeBloc(
                  cxt.read<LocationBloc>(), // Inject LocationBloc
                  cxt.read<HomeRepository>(), // Inject HomeRepo
                  cxt.read<UserProfileBloc>(), // Inject HomeRepo
                ),
          ),
        ],
        child: MaterialApp.router(
          title: 'GeoTaask',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
