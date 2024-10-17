import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String defaultCity = "Yakutsk";
  String? temperature;
  String? description;
  String? iconUrl;
  String? humidity;
  String? windSpeed;
  String? minimumTemperature;
  String? maximumTemperature;

  @override
  void initState() {
    super.initState();
    _loadDefaultCity();
  }

  Future<void> _loadDefaultCity() async {
    // Fetch the weather for the default city in the initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);

      // Fetch weather asynchronously
      await weatherProvider.fetchWeatherByCity(defaultCity);
      if (!weatherProvider.isLoading && weatherProvider.weather != null) {
        setState(() {
          temperature = weatherProvider.weather?.temperature.toString();
          description = weatherProvider.weather?.description;
          iconUrl = weatherProvider.weather!.iconUrl;
          humidity = weatherProvider.weather!.humidity.toString();
          windSpeed = weatherProvider.weather!.windSpeed.toString();
          minimumTemperature =
              weatherProvider.weather!.minTemperature.toString();
          maximumTemperature =
              weatherProvider.weather!.maxTemperature.toString();
        });
      } else {
        print(weatherProvider.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.steelBlueColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: AppColors.whiteColor,
                size: 35.sp,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.steelBlueColor,
          ),
          child: weatherProvider.isLoading
              ? Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Getting weather updates",
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.whiteColor,
                        size: 32.sp,
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60.h), // Space at the top
                    Text(
                      defaultCity,
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "$temperature°",
                      style: TextStyle(
                        fontSize: 70.sp,
                        color: Colors.white,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$description",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.semiTransparentWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.network(
                          "$iconUrl",
                          color: AppColors.semiTransparentWhiteColor,
                          height: 70.h,
                        ),
                      ],
                    ),

                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.frostedWhiteColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "More Details:",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          detailsTile("Today",
                              "$minimumTemperature/$maximumTemperature"),
                          detailsTile("Humidity", "$humidity%"),
                          detailsTile("Wind Speed", "$windSpeed m/s"),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget detailsTile(String heading, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            heading,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
