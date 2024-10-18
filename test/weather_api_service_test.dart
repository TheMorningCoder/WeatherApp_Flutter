import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/services/weather_api_service.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  dotenv.testLoad(fileInput: File('.env').readAsStringSync());
  final Client httpClient = MockHttpClient();
  final Response response = MockResponse();
  final WeatherApiService weatherApiService =
      WeatherApiService(httpClient: httpClient);
  setUpAll(() => registerFallbackValue(FakeUri()));

  group('Weather API Service Tests', () {
    test('fetchCoordinates returns correct data for a valid city', () async {
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
        jsonEncode([
          {"lat": 1, "lon": 1},
        ]),
      );
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      final result = await weatherApiService.fetchCoordinates('Paris');
      expect(result, isA<Map<String, dynamic>>());
      expect(result['lat'], isNotNull);
      expect(result['lon'], isNotNull);
      expect(result['lat'], 1);
      expect(result['lon'], 1);
    });

    test('fetchCoordinates throws an exception for an invalid city', () async {
      when(() => httpClient.get(any())).thenThrow(Exception());
      expect(() => weatherApiService.fetchCoordinates('InvalidCity'),
          throwsA(isA<Exception>()));
    });

    test('fetchWeather returns correct data for valid coordinates', () async {
      final lat = 48.8589;
      final lon = 2.32; // Coordinates for Paris
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
        jsonEncode({
          'main': {'temp': 23},
          "weather": [
            {
              "id": 300,
              "main": "Drizzle",
              "description": "light intensity drizzle",
              "icon": "09d"
            }
          ],
        }),
      );
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      final result = await weatherApiService.fetchWeather(lat, lon);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['main']['temp'], isNotNull);
      expect(result['weather'][0]['description'], isNotNull);
    });

    test('fetchWeather throws an exception for invalid coordinates', () async {
      when(() => httpClient.get(any())).thenThrow(Exception());
      expect(
          () => weatherApiService.fetchWeather(95, 200), // Invalid coordinates
          throwsA(isA<Exception>()));
    });
  });
}
