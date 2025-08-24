import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteData extends Equatable {
  final List<LatLng> points;
  final String distance;
  final String duration;
  final String? distanceValue; // in meters
  final int? durationValue; // in seconds
  final String? summary;
  final List<RouteStep> steps;

  const RouteData({
    required this.points,
    required this.distance,
    required this.duration,
    this.distanceValue,
    this.durationValue,
    this.summary,
    this.steps = const [],
  });

  factory RouteData.fromGoogleDirections(Map<String, dynamic> route) {
    final leg = route['legs'][0];
    final polylinePoints = route['overview_polyline']['points'];

    // Parse steps if available
    final List<RouteStep> steps = [];
    if (leg['steps'] != null) {
      for (final step in leg['steps']) {
        steps.add(RouteStep.fromJson(step));
      }
    }

    return RouteData(
      points: _decodePolyline(polylinePoints),
      distance: leg['distance']['text'],
      duration: leg['duration']['text'],
      distanceValue: leg['distance']['value']?.toString(),
      durationValue: leg['duration']['value'],
      summary: route['summary'],
      steps: steps,
    );
  }

  static List<LatLng> _decodePolyline(String polyline) {
    // Note: You'll need to import google_polyline_algorithm package
    // return decodePolyline(polyline)
    //     .map((point) => LatLng(point[0].toDouble(), point[1].toDouble()))
    //     .toList();

    // Placeholder implementation - replace with actual polyline decoding
    return [];
  }

  RouteData copyWith({
    List<LatLng>? points,
    String? distance,
    String? duration,
    String? distanceValue,
    int? durationValue,
    String? summary,
    List<RouteStep>? steps,
  }) {
    return RouteData(
      points: points ?? this.points,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      distanceValue: distanceValue ?? this.distanceValue,
      durationValue: durationValue ?? this.durationValue,
      summary: summary ?? this.summary,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [
    points,
    distance,
    duration,
    distanceValue,
    durationValue,
    summary,
    steps,
  ];
}

class RouteStep extends Equatable {
  final String htmlInstructions;
  final String distance;
  final String duration;
  final LatLng startLocation;
  final LatLng endLocation;
  final String travelMode;

  const RouteStep({
    required this.htmlInstructions,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.travelMode,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      htmlInstructions: json['html_instructions'] ?? '',
      distance: json['distance']['text'] ?? '',
      duration: json['duration']['text'] ?? '',
      startLocation: LatLng(
        json['start_location']['lat']?.toDouble() ?? 0.0,
        json['start_location']['lng']?.toDouble() ?? 0.0,
      ),
      endLocation: LatLng(
        json['end_location']['lat']?.toDouble() ?? 0.0,
        json['end_location']['lng']?.toDouble() ?? 0.0,
      ),
      travelMode: json['travel_mode'] ?? 'DRIVING',
    );
  }

  @override
  List<Object> get props => [
    htmlInstructions,
    distance,
    duration,
    startLocation,
    endLocation,
    travelMode,
  ];
}