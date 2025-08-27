import 'dart:math';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Helpers {
  static String generateId() {
    final uuid = Uuid();
    return uuid.v4().substring(0, 8);
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static double calcDistanceBetweenInM(
    double currentLat,
    double currentLong,
    double targetLat,
    double targetLong,
  ) {
    double lat1 = currentLat;
    double lon1 = currentLong;
    double lat2 = targetLat;
    double lon2 = targetLong;

    var R = 6371e3; // metres
    // var R = 1000;
    var phi1 = (lat1 * pi) / 180; // φ, λ in radians
    var phi2 = (lat2 * pi) / 180;
    var deltaPhi = ((lat2 - lat1) * pi) / 180;
    var deltaLambda = ((lon2 - lon1) * pi) / 180;

    var a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    var d = R * c; // in metres

    return d;
  }

  // Generate session token for Places API billing optimization
  static String generateSessionToken() {
    final random = Random();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        36,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  static String formatDate(DateTime inputDate) {
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(inputDate);
    // 12/31/2000 11:59 PM <-- MM/dd 12H format
    return outputDate;
  }

  static String formatDateAndTime(DateTime inputDate) {
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    // 12/31/2000 11:59 PM <-- MM/dd 12H format
    return outputDate;
  }

  static DateTime formatDateToObj(String date){
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format
    return inputDate;
  }
}
