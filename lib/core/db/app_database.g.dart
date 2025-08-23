// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TaskDao? _taskDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user_entity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` TEXT, `address` TEXT, `avatar` TEXT, `userName` TEXT, `bio` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `geofences` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `radius` REAL, `latitude` REAL, `longitude` REAL, `markerId` TEXT, `title` TEXT, `description` TEXT, `notified` INTEGER NOT NULL, `status` TEXT NOT NULL, `createdAt` TEXT, `startsAt` TEXT, `endsAt` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TaskDao get taskDao {
    return _taskDaoInstance ??= _$TaskDao(database, changeListener);
  }
}

class _$TaskDao extends TaskDao {
  _$TaskDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userEntityInsertionAdapter = InsertionAdapter(
            database,
            'user_entity',
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'address': item.address,
                  'avatar': item.avatar,
                  'userName': item.userName,
                  'bio': item.bio
                }),
        _markerEntityInsertionAdapter = InsertionAdapter(
            database,
            'geofences',
            (MarkerEntity item) => <String, Object?>{
                  'id': item.id,
                  'radius': item.radius,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'markerId': item.markerId,
                  'title': item.title,
                  'description': item.description,
                  'notified': _boolConverter.encode(item.notified),
                  'status': _markerStatusConverter.encode(item.status),
                  'createdAt': _dateTimeStringConverter.encode(item.createdAt),
                  'startsAt': _dateTimeStringConverter.encode(item.startsAt),
                  'endsAt': _dateTimeStringConverter.encode(item.endsAt)
                },
            changeListener),
        _markerEntityUpdateAdapter = UpdateAdapter(
            database,
            'geofences',
            ['id'],
            (MarkerEntity item) => <String, Object?>{
                  'id': item.id,
                  'radius': item.radius,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'markerId': item.markerId,
                  'title': item.title,
                  'description': item.description,
                  'notified': _boolConverter.encode(item.notified),
                  'status': _markerStatusConverter.encode(item.status),
                  'createdAt': _dateTimeStringConverter.encode(item.createdAt),
                  'startsAt': _dateTimeStringConverter.encode(item.startsAt),
                  'endsAt': _dateTimeStringConverter.encode(item.endsAt)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserEntity> _userEntityInsertionAdapter;

  final InsertionAdapter<MarkerEntity> _markerEntityInsertionAdapter;

  final UpdateAdapter<MarkerEntity> _markerEntityUpdateAdapter;

  @override
  Future<UserEntity?> getUserProfile() async {
    return _queryAdapter.query('SELECT * FROM user_entity',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as int?,
            userId: row['userId'] as String?,
            address: row['address'] as String?,
            avatar: row['avatar'] as String?,
            userName: row['userName'] as String?,
            bio: row['bio'] as String?));
  }

  @override
  Stream<List<MarkerEntity>> getGeofenceMarkers() {
    return _queryAdapter.queryListStream('SELECT * FROM geofences',
        mapper: (Map<String, Object?> row) => MarkerEntity(
            id: row['id'] as int?,
            radius: row['radius'] as double?,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            markerId: row['markerId'] as String?,
            title: row['title'] as String?,
            description: row['description'] as String?,
            notified: _boolConverter.decode(row['notified'] as int),
            status: _markerStatusConverter.decode(row['status'] as String),
            createdAt:
                _dateTimeStringConverter.decode(row['createdAt'] as String?),
            startsAt:
                _dateTimeStringConverter.decode(row['startsAt'] as String?),
            endsAt: _dateTimeStringConverter.decode(row['endsAt'] as String?)),
        queryableName: 'geofences',
        isView: false);
  }

  @override
  Future<List<MarkerEntity>> fetchGeofenceMarkers() async {
    return _queryAdapter.queryList('SELECT * FROM geofences',
        mapper: (Map<String, Object?> row) => MarkerEntity(
            id: row['id'] as int?,
            radius: row['radius'] as double?,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            markerId: row['markerId'] as String?,
            title: row['title'] as String?,
            description: row['description'] as String?,
            notified: _boolConverter.decode(row['notified'] as int),
            status: _markerStatusConverter.decode(row['status'] as String),
            createdAt:
                _dateTimeStringConverter.decode(row['createdAt'] as String?),
            startsAt:
                _dateTimeStringConverter.decode(row['startsAt'] as String?),
            endsAt: _dateTimeStringConverter.decode(row['endsAt'] as String?)));
  }

  @override
  Future<MarkerEntity?> getGeofenceMarkerById(int id) async {
    return _queryAdapter.query('SELECT * FROM geofences WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MarkerEntity(
            id: row['id'] as int?,
            radius: row['radius'] as double?,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            markerId: row['markerId'] as String?,
            title: row['title'] as String?,
            description: row['description'] as String?,
            notified: _boolConverter.decode(row['notified'] as int),
            status: _markerStatusConverter.decode(row['status'] as String),
            createdAt:
                _dateTimeStringConverter.decode(row['createdAt'] as String?),
            startsAt:
                _dateTimeStringConverter.decode(row['startsAt'] as String?),
            endsAt: _dateTimeStringConverter.decode(row['endsAt'] as String?)),
        arguments: [id]);
  }

  @override
  Future<MarkerEntity?> getGeofenceMarkerByMarkerId(String markerId) async {
    return _queryAdapter.query('SELECT * FROM geofences WHERE markerId = ?1',
        mapper: (Map<String, Object?> row) => MarkerEntity(
            id: row['id'] as int?,
            radius: row['radius'] as double?,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            markerId: row['markerId'] as String?,
            title: row['title'] as String?,
            description: row['description'] as String?,
            notified: _boolConverter.decode(row['notified'] as int),
            status: _markerStatusConverter.decode(row['status'] as String),
            createdAt:
                _dateTimeStringConverter.decode(row['createdAt'] as String?),
            startsAt:
                _dateTimeStringConverter.decode(row['startsAt'] as String?),
            endsAt: _dateTimeStringConverter.decode(row['endsAt'] as String?)),
        arguments: [markerId]);
  }

  @override
  Future<List<MarkerEntity>?> fetchGeofenceMarkerByStatus(
      MarkerStatus status) async {
    return _queryAdapter.queryList('SELECT * FROM geofences WHERE status = ?1',
        mapper: (Map<String, Object?> row) => MarkerEntity(
            id: row['id'] as int?,
            radius: row['radius'] as double?,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            markerId: row['markerId'] as String?,
            title: row['title'] as String?,
            description: row['description'] as String?,
            notified: _boolConverter.decode(row['notified'] as int),
            status: _markerStatusConverter.decode(row['status'] as String),
            createdAt:
                _dateTimeStringConverter.decode(row['createdAt'] as String?),
            startsAt:
                _dateTimeStringConverter.decode(row['startsAt'] as String?),
            endsAt: _dateTimeStringConverter.decode(row['endsAt'] as String?)),
        arguments: [_markerStatusConverter.encode(status)]);
  }

  @override
  Future<void> deleteGeofenceMarkers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM geofences');
  }

  @override
  Future<void> deleteGeofenceMarkerId(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM geofences WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteGeofenceMarkerByMarkerId(String markerId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM geofences WHERE markerId = ?1',
        arguments: [markerId]);
  }

  @override
  Future<void> saveUser(UserEntity data) async {
    await _userEntityInsertionAdapter.insert(data, OnConflictStrategy.replace);
  }

  @override
  Future<void> createGeofenceMarker(MarkerEntity entity) async {
    await _markerEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateGeofenceMarker(MarkerEntity entity) async {
    await _markerEntityUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _markerStatusConverter = MarkerStatusConverter();
final _dateTimeStringConverter = DateTimeStringConverter();
final _boolConverter = BoolConverter();
