import 'dart:async';
import 'dart:developer' as developer;
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../db/task_dao.dart';
import '../enums/tag_location_status.dart';
import '../model/user_entity.dart';
import '../model/tag_location_entity.dart';

part 'app_database.g.dart';

@TypeConverters([TagLocationStatusConverter])
@Database(version: 1, entities: [UserEntity, TagLocationEntity])
abstract class AppDatabase extends FloorDatabase {
  static late AppDatabase _instance;

  static AppDatabase get instance => _instance;

  TaskDao get taskDao;

  static Future<void> init() async {
    _instance = await $FloorAppDatabase.databaseBuilder("geotaask.db").build();
    developer.log("Init Database: ${_instance.database.database.isOpen}");
    await _instance.taskDao.saveUser(
      UserEntity(userId: "userId", address: "plot A", id: 0, avatar: "dfddfd"),
    );
    final res = await _instance.taskDao.getUserProfile();
    final markerRes = _instance.taskDao.getGeofenceMarkers();
    developer.log("Current User; ${res?.toJson()}");
    markerRes.listen((onData){
      developer.log("Available markers; ${onData.length}");
    });
  }
}
