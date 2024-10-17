import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/themes/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Resetting weather data when the screen is opened
    final searchWeatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    searchWeatherProvider.clearWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final searchWeatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(color: AppColors.whiteColor, fontSize: 30),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            )),
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
                  searchWeatherProvider
                      .fetchWeatherByCity(value); // Fetch weather on submit
                }
              },
            ),
            const SizedBox(height: 20),

            // Display loading, error or weather data
            searchWeatherProvider.isLoading
                ? const CircularProgressIndicator()
                : searchWeatherProvider.errorMessage != null
                    ? Text(
                        searchWeatherProvider.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      )
                    : searchWeatherProvider.weather != null
                        ? Column(
                            children: [
                              Image.network(
                                  searchWeatherProvider.weather!.iconUrl),
                              Text(
                                'Temperature: ${searchWeatherProvider.weather!.temperature}°C',
                                style: TextStyle(fontSize: 24),
                              ),
                              Text(
                                  'Humidity: ${searchWeatherProvider.weather!.humidity}%'),
                              Text(
                                  'Wind Speed: ${searchWeatherProvider.weather!.windSpeed} m/s'),
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
