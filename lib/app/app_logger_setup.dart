import 'dart:io';

import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

import 'package:path_provider/path_provider.dart';

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
