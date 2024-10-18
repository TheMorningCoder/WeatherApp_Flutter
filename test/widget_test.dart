import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/providers/weather_provider.dart';

void main() {
  group('Weather App Widget Tests', () {
    // Test to check if the loading indicator is shown when fetching weather
    testWidgets('Displays loading indicator when fetching weather',
        (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MyWeatherApp(),
        ),
      );

      // Verify that loading indicator is displayed initially (when fetching weather)
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Start the weather fetch by tapping the '+' icon (simulating search)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(); // Rebuild the widget

      // After triggering the fetch, verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test to verify if weather data is displayed after fetching
    testWidgets('Displays weather data correctly', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MyWeatherApp(),
        ),
      );

      // Wait for the widget to finish loading the initial state
      await tester.pumpAndSettle();

      // After loading, the weather data should be displayed
      expect(
          find.textContaining('°'), findsWidgets); // Finds temperature display
      expect(
          find.textContaining('Humidity'), findsWidgets); // Finds humidity info
    });

    // Test to ensure error message is shown on failure
    testWidgets('Displays error message on failed weather fetch',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MyWeatherApp(),
        ),
      );

      // Simulate an error scenario by passing an invalid city name
      final weatherProvider = Provider.of<WeatherProvider>(
          tester.element(find.byType(MyWeatherApp)),
          listen: false);
      await weatherProvider.fetchWeatherByCity('InvalidCity');

      // Rebuild the widget
      await tester.pump();

      // Verify that the error message is displayed
      expect(find.textContaining('Failed'), findsOneWidget);
    });
  });
}
