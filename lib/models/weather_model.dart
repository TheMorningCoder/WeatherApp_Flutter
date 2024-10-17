class WeatherModel {
  final temperature;
  final humidity;
  final windSpeed;
  final weatherIcon;
  final description;
  final minTemperature;
  final maxTemperature;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
    required this.description,
    required this.minTemperature,
    required this.maxTemperature,
  });

  // Factory constructor to create a WeatherModel from JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      weatherIcon: json['weather'][0]['icon'],
      description: json['weather'][0]['main'],
      minTemperature: json['main']['temp_min'],
      maxTemperature: json['main']['temp_max'],
    );
  }

  // Get the full icon URL
  String get iconUrl => 'http://openweathermap.org/img/wn/$weatherIcon@2x.png';
}
