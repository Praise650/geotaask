import 'dart:io';

import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

import 'package:path_provider/path_provider.dart';

// https://stackoverflow.com/questions/75859813/retrieve-logs-from-customer-device-in-flutter

final logger = Logger('GeoTaask');

extension LogExtensions on Logger {
  void release(String message, {String name = 'GeoTaask'}) {
    logger.fine('[PROD] $name: $message', error);
  }

  void error(String message, {String name = 'GeoTaask', Object? error}) {
    logger.finer('[ERROR] $name: $message', error);
  }

  void debug(String message, {String name = 'GeoTaask'}) {
    logger.finest('[DEBUG] $name: $message');
  }
}

Future<void> initLogging() async {
  final file = Platform.isAndroid ? await _localFile : null;
  // file logging doesn't work as intended below on iOS

  // log to stdout (and to logfile on Android)
  Logger.root.level = kDebugMode ? Level.ALL : Level.FINER;
  // INFO is the default
  Logger.root.onRecord.listen((record) {
    final String logMessage = '${record.time}: ${record.message}';
    dev.log(logMessage); // use dev.log to integrate with Flutter DevTools
    file?.writeAsStringSync(
      '$logMessage\n',
      // overwrite in production
      mode: kDebugMode ? FileMode.append : FileMode.write,
      flush: true, // TODO: check if flushing is necessary
    );
  });
}

Future<String> get _localPath async {
  // /storage/emulated/0/Android/data/dev.lttl.wyatt/files
  final directory = await getExternalStorageDirectory();
  // /data/user/0/dev.lttl.wyatt/cache - nothing found here
  // getTemporaryDirectory()
  // /data/user/0/dev.lttl.wyatt/app_flutter - nothing found here
  // getApplicationDocumentsDirectory()

  return directory!.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  // don't call it .log, as it's recognized as a binary file on Android
  final logFile = '$path/wyatt-${kDebugMode ? 'debug' : 'release'}-log.txt';

  dev.log('logging to $logFile', name: 'initLogging');

  return File(logFile);
}
