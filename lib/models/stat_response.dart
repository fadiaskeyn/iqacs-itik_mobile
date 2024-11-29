class StatResponse {
  final double temperature;
  final double humidity;
  final int ammonia;

  StatResponse({
    required this.temperature,
    required this.humidity,
    required this.ammonia,
  });

  factory StatResponse.fromJson(Map<String, dynamic> json) {
    return StatResponse(
      temperature: json['temperature'],
      humidity: json['humidity'],
      ammonia: json['ammonia'],
    );
  }
}
