import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stat_response.dart';

class ApiService {
  Future<StatResponse> fetchStats(int idAlat) async {
    final url = 'https://iqacs-duck.research-ai.my.id/api/stats/$idAlat';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return StatResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load stats');
    }
  }
}
