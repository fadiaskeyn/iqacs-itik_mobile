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
      // Parsing ke double menggunakan .toDouble()
      temperature: (json['temperature'] as num).toDouble(),
      ammonia: (json['ammonia'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
    );
  }
}
