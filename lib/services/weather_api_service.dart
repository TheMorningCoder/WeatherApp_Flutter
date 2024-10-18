import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApiService {
  WeatherApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();
  final http.Client _httpClient;
  final String? _geoBaseUrl = dotenv.env['GEO_API_URL'];
  final String? _weatherBaseUrl = dotenv.env['WEATHER_API_URL'];
  final String? _apiKey = dotenv.env['API_KEY'];

  /**
   * Method to fetch coordinates based on a city name
   * @param city String
   * @returns on success, returns latitude and longitude values of the city, on failure throws exception
   */
  Future<Map<String, dynamic>> fetchCoordinates(String city) async {
    final Uri url = Uri.parse('$_geoBaseUrl?q=$city&limit=1&appid=$_apiKey');
    final response = await _httpClient.get(url);

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

/**
   * Method to fetch weather data based on coordinates
   * @param lat double
  *  @param lon double
   * @returns on success, returns weather data of the given coordinates, on failure throws exception
   */

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final Uri url = Uri.parse(
        '$_weatherBaseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await _httpClient.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
