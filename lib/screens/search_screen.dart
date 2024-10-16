import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter city',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  weatherProvider
                      .fetchWeatherByCity(value); // Fetch weather on submit
                }
              },
            ),
            const SizedBox(height: 20),

            // Display loading, error or weather data
            weatherProvider.isLoading
                ? const CircularProgressIndicator()
                : weatherProvider.errorMessage != null
                    ? Text(
                        weatherProvider.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      )
                    : weatherProvider.weather != null
                        ? Column(
                            children: [
                              Image.network(weatherProvider.weather!.iconUrl),
                              Text(
                                'Temperature: ${weatherProvider.weather!.temperature}°C',
                                style: TextStyle(fontSize: 24),
                              ),
                              Text(
                                  'Humidity: ${weatherProvider.weather!.humidity}%'),
                              Text(
                                  'Wind Speed: ${weatherProvider.weather!.windSpeed} m/s'),
                            ],
                          )
                        : const Center(
                            child:
                                Text("Search a city to get weather updates")),
          ],
        ),
      ),
    );
  }
}
