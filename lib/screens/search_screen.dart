import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/components/staggered_loading_widget.dart';
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

  Map<String, dynamic> getWeatherDetails(
      WeatherProvider searchWeatherProvider) {
    if (searchWeatherProvider.weather != null) {
      var weather = searchWeatherProvider.weather!;
      return {
        'iconUrl': weather.iconUrl,
        'temperature': weather.temperature,
        'humidity': weather.humidity,
        'windSpeed': weather.windSpeed,
        'minTemperature': weather.minTemperature,
        'maxTemperature': weather.maxTemperature,
        'description': weather.description
      };
    } else {
      return {}; // Return an empty map if weather is null
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchWeatherProvider = Provider.of<WeatherProvider>(context);
    final weatherDetails = getWeatherDetails(searchWeatherProvider);

    return Scaffold(
      backgroundColor: AppColors.steelBlueColor,
      appBar: AppBar(
        backgroundColor: AppColors.steelBlueColor,
        title: Text(
          "Weather App",
          style: TextStyle(color: AppColors.whiteColor, fontSize: 25),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Enter city',
                  labelStyle: TextStyle(color: AppColors.whiteColor),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.whiteColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            AppColors.whiteColor), // White border when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.whiteColor,
                        width: 2.0), // White border when focused
                  ),
                ),
                style: TextStyle(
                    color: AppColors.whiteColor), // Text color in TextField
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    searchWeatherProvider
                        .fetchWeatherByCity(value); // Fetch weather on submit
                  }
                },
              ),
              SizedBox(height: 20.h),

              // Display loading, error, or weather data
              searchWeatherProvider.isLoading
                  ? Center(
                      child: StaggeredDotsLoadingWidget(
                        message: "Loading ",
                      ),
                    )
                  : searchWeatherProvider.errorMessage != null
                      ? Column(
                          children: [
                            SizedBox(height: 60.h),
                            Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 50.sp,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              searchWeatherProvider.errorMessage!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : weatherDetails.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 35.h),
                                // Weather Icon
                                Image.network(
                                  weatherDetails['iconUrl'],
                                  height: 100.h,
                                  width: 100.w,
                                ),

                                // Temperature
                                Text(
                                  'Temperature: ${weatherDetails['temperature']}°C',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                //Description
                                Text(
                                  '${weatherDetails['description']}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                // Humidity
                                Text(
                                  'Humidity: ${weatherDetails['humidity']}%',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                // Wind Speed
                                Text(
                                  'Wind Speed: ${weatherDetails['windSpeed']} m/s',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                //Today's Minimum and Maximum Temperature
                                Text(
                                  'Today: ${weatherDetails['minTemperature']}°C/${weatherDetails['maxTemperature']}°C',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Text(
                                "Search a city to get weather updates",
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
