import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  var weatherData;
  WeatherWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    print(weatherData['main']['temp'].round());
    return Text(
        "${weatherData['main']['temp'].round()}° ${weatherData['weather'][0]['description']}",
        style: TextStyle(fontSize: 28, letterSpacing: 2, color: Colors.white));
  }
}
