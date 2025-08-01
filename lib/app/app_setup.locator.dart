// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:get_it/get_it.dart';

import '../core/services/location_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/permission_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator({String? environment}) async {
// Register dependencies
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => PermissionService());
  locator.registerLazySingleton(() => NotificationService());
}
