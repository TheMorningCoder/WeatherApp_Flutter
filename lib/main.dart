import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/homescreen.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:weather_app/themes/colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return const MyWeatherApp();
        },
      ),
    ),
  );
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.skyBlueColor,
        ),
        useMaterial3: true,
      ),
      home: SearchScreen(),
    );
  }
}
