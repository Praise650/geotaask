class PlacePrediction {
  final String placeId;
  final String description;
  final String? mainText;
  final String? secondaryText;
  final List<String> types;

  PlacePrediction({
    required this.placeId,
    required this.description,
    this.mainText,
    this.secondaryText,
    required this.types,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: json['structured_formatting']?['main_text'],
      secondaryText: json['structured_formatting']?['secondary_text'],
      types: List<String>.from(json['types'] ?? []),
    );
  }
}