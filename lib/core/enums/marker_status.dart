import 'package:floor/floor.dart';

enum MarkerStatus { active, inactive, completed }

class MarkerStatusConverter extends TypeConverter<MarkerStatus, String> {
  @override
  MarkerStatus decode(String databaseValue) {
    return MarkerStatus.values.firstWhere((e) => e.name == databaseValue);
  }

  @override
  String encode(MarkerStatus value) {
    return value.name;
  }
}
