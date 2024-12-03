import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chart_stats.dart';

class ChartService {
  final String baseUrl = 'https://iqacs-duck.research-ai.my.id/api';

  Future<Map<String, ChartStats>> fetchChartStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stats/charts'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data.map((time, statsJson) {
          return MapEntry(time, ChartStats.fromJson(statsJson));
        });
      } else {
        throw Exception('Failed to load chart stats');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching chart stats: $e');
    }
  }
}
