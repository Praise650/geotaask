import 'package:uuid/uuid.dart';

class Helpers {
  static String generateId() {
    final uuid = Uuid();
    return uuid.v4().substring(0, 8);
  }
}
