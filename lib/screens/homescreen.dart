import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/components/details_tile.dart';
import 'package:weather_app/components/staggered_loading_widget.dart';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastSearchedCity = prefs.getString('lastSearchedCity') ?? "Yakutsk";

    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.fetchWeatherByCity(lastSearchedCity);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        defaultCity = lastSearchedCity;
        if (!weatherProvider.isLoading && weatherProvider.weather != null) {
          temperature = weatherProvider.weather?.temperature.toString();
          description = weatherProvider.weather?.description;
          iconUrl = weatherProvider.weather!.iconUrl;
          humidity = weatherProvider.weather!.humidity.toString();
          windSpeed = weatherProvider.weather!.windSpeed.toString();
          minimumTemperature =
              weatherProvider.weather!.minTemperature.toString();
          maximumTemperature =
              weatherProvider.weather!.maxTemperature.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return SafeArea(
      child: Scaffold(
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
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.steelBlueColor,
          ),
          child: weatherProvider.isLoading
              ? StaggeredDotsLoadingWidget(
                  message: "Get Weather Updates",
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          iconUrl ??
                              'https://picsum.photos/250?image=9', // Fallback image
                          color: AppColors.semiTransparentWhiteColor,
                          height: 70.h,
                        ),
                      ],
                    ),

                    Flexible(
                      child: Container(
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
                          mainAxisSize: MainAxisSize.min,
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
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
