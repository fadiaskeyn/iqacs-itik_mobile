class ChartStats {
  final double temperature;
  final double ammonia;
  final double humidity;

  ChartStats({
    required this.temperature,
    required this.ammonia,
    required this.humidity,
  });

  factory ChartStats.fromJson(Map<String, dynamic> json) {
    return ChartStats(
      temperature: json['temperature'],
      ammonia: json['ammonia'],
      humidity: json['humidity'],
    );
  }
}
