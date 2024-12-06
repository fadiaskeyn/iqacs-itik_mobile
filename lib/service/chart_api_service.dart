import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chart_stats.dart';

class ChartService {
  final String baseUrl = 'https://iqacs-duck.research-ai.my.id/api';

  Future<Map<String, ChartStats>> fetchChartStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stats/charts'));

      // Cetak response status code
      print("Response status code: ${response.statusCode}");

      // Cetak raw response body untuk debugging
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Cetak hasil decoded JSON
        print("Decoded JSON: $data");

        // Map data menjadi objek ChartStats
        final mappedData = data.map((time, statsJson) {
          return MapEntry(time, ChartStats.fromJson(statsJson));
        });

        // Cetak data terproses (parsed)
        print("Parsed data: $mappedData");

        return mappedData;
      } else {
        throw Exception('Failed to load chart stats: ${response.statusCode}');
      }
    } catch (e) {
      // Cetak error saat debugging
      print("Error while fetching chart stats: $e");
      throw Exception('An error occurred while fetching chart stats: $e');
    }
  }
}
