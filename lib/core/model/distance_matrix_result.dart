// Distance Matrix related classes
class DistanceMatrixResult {
  final List<DistanceMatrixElement> elements;

  const DistanceMatrixResult({required this.elements});
}

class DistanceMatrixElement {
  final String status;
  final String? distance;
  final String? duration;
  final int? distanceValue;
  final int? durationValue;

  const DistanceMatrixElement({
    required this.status,
    this.distance,
    this.duration,
    this.distanceValue,
    this.durationValue,
  });

  factory DistanceMatrixElement.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixElement(
      status: json['status'],
      distance: json['distance']?['text'],
      duration: json['duration']?['text'],
      distanceValue: json['distance']?['value'],
      durationValue: json['duration']?['value'],
    );
  }
}