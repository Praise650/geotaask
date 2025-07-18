import 'package:geotaask/core/model/user_entity.dart';

import '../db/app_database.dart';

abstract class UserRepository {
  Future<UserEntity?> fetchUserProfile();
  Future<void> updateUserProfile(UserEntity user);
}

class UserRepositoryImpl implements UserRepository {
  final AppDatabase _dbService;

  UserRepositoryImpl({AppDatabase? dbService})
    : _dbService = dbService ?? AppDatabase.instance;

  @override
  Future<UserEntity?> fetchUserProfile() async =>
      await _dbService.taskDao.getUserProfile();

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    await _dbService.taskDao.saveUser(user);
  }
}
