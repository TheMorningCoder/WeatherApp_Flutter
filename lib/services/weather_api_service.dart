import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  final String _geoBaseUrl = 'http://api.openweathermap.org/geo/1.0/direct';
  final String _weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  final String _apiKey = '1d788e2a5b2d5022aa8356e9e6053517'; //

  // Fetch coordinates based on city name
  Future<Map<String, dynamic>> fetchCoordinates(String city) async {
    final Uri url = Uri.parse('$_geoBaseUrl?q=$city&limit=1&appid=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return {'lat': data[0]['lat'], 'lon': data[0]['lon']};
      } else {
        throw Exception('City not found');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  // Fetch weather data based on coordinates
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final Uri url = Uri.parse(
        '$_weatherBaseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
