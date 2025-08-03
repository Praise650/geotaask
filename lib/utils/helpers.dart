import 'package:haversine_distance/haversine_distance.dart' as hav;
import 'package:uuid/uuid.dart';

import '../core/model/location_entity.dart';

class Helpers {
  static String generateId() {
    final uuid = Uuid();
    return uuid.v4().substring(0, 8);
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatDate(String formattedString) {
    final date = DateTime.parse(formattedString);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static int calcDistanceBetweenInM(
      LocationEntity currentLocationData, LocationEntity targetLocationData) {
    final haversineDistance = hav.HaversineDistance();
    final targetLocation =
    hav.Location(targetLocationData.latitude, targetLocationData.longitude);
    final currentLocation = hav.Location(
        currentLocationData.latitude, currentLocationData.longitude);

    final distance = haversineDistance
        .haversine(targetLocation, currentLocation, hav.Unit.METER)
        .floor();

    return distance;
  }
}
