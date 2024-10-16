import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_api_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _weatherApiService = WeatherApiService();
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch weather by city
  Future<void> fetchWeatherByCity(String city) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      print("Heeeelllllooooo");

      // Get coordinates
      final coords = await _weatherApiService.fetchCoordinates(city);
      print("Coords==========");
      print(await _weatherApiService.fetchCoordinates(city));

      // Get weather data using coordinates
      final weatherData =
          await _weatherApiService.fetchWeather(coords['lat'], coords['lon']);
      _weather = WeatherModel.fromJson(weatherData);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
