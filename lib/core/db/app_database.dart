import 'dart:async';
import 'dart:developer' as developer;
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../db/task_dao.dart';
import '../enums/marker_status.dart';
import '../model/user_entity.dart';
import '../model/marker_entity.dart';

part 'app_database.g.dart';

@TypeConverters([MarkerStatusConverter, DateTimeStringConverter, BoolConverter])
@Database(version: 1, entities: [UserEntity, MarkerEntity])
abstract class AppDatabase extends FloorDatabase {
  static late AppDatabase _instance;

  static AppDatabase get instance => _instance;

  TaskDao get taskDao;

  static Future<void> init() async {
    _instance = await $FloorAppDatabase.databaseBuilder("geotaask.db").build();
    developer.log("Init Database: ${_instance.database.database.isOpen}");
    final markerRes = _instance.taskDao.getGeofenceMarkers();
    markerRes.listen((onData) {
      developer.log("Available markers: ${onData.length}");
    });
  }
}
