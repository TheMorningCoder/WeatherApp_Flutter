import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/services/weather_api_service.dart';

void main() {
  late WeatherApiService weatherApiService;

  setUp(() {
    weatherApiService = WeatherApiService();
  });

  group('Weather API Service Tests', () {
    test('fetchCoordinates returns correct data for a valid city', () async {
      final result = await weatherApiService.fetchCoordinates('Paris');

      expect(result, isA<Map<String, dynamic>>());
      expect(result['lat'], isNotNull);
      expect(result['lon'], isNotNull);
    });

    test('fetchCoordinates throws an exception for an invalid city', () async {
      expect(() async {
        await weatherApiService.fetchCoordinates('InvalidCity');
      }, throwsException);
    });

    test('fetchWeather returns correct data for valid coordinates', () async {
      final lat = 48.8589;
      final lon = 2.32; // Coordinates for Paris

      final result = await weatherApiService.fetchWeather(lat, lon);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['main']['temp'], isNotNull);
      expect(result['weather'][0]['description'], isNotNull);
    });

    test('fetchWeather throws an exception for invalid coordinates', () async {
      expect(() async {
        await weatherApiService.fetchWeather(0.0, 0.0); // Invalid coordinates
      }, throwsException);
    });
  });
}
