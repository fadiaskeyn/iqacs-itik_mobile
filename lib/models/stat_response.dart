class StatResponse {
  final double temperature;
  final double humidity;
  final double ammonia;

  StatResponse({
    required this.temperature,
    required this.humidity,
    required this.ammonia,
  });

  factory StatResponse.fromJson(Map<String, dynamic> json) {
    return StatResponse(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      ammonia: (json['ammonia'] as num).toDouble(),
    );
  }
}
