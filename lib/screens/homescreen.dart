import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String? _previousCity;

  @override
  void initState() {
    super.initState();
    _loadPreviousCity(); // Load previously searched city on startup
  }

  Future<void> _loadPreviousCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _previousCity = prefs.getString('previousCity'); // Retrieve saved city
      _searchController.text =
          _previousCity ?? ''; // Set text field if available
    });
  }

  Future<void> _saveCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('previousCity', city); // Save the city name
  }

  void _onSearch() {
    String searchedCity = _searchController.text;
    if (searchedCity.isNotEmpty) {
      _saveCity(searchedCity); // Save the searched city
      // Add logic here to handle the searched city (e.g., fetch weather data)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text("Home Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
