class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String weatherIcon;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
  });

  // Factory constructor to create a WeatherModel from JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      weatherIcon: json['weather'][0]['icon'],
    );
  }

  // Get the full icon URL
  String get iconUrl => 'http://openweathermap.org/img/wn/$weatherIcon@2x.png';
}
