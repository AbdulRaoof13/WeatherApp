import "dart:ffi";

import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather_app/models/weather_models.dart";
import "package:weather_app/services/weather_service.dart";
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('f9986c35934242e897db3d124820ae68');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (err) {
      print(err);
    }
  }

  String getAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk').format(now);

    bool? Day = true;

    if (int.parse(formattedDate) > 18) {
      Day = false;
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        {
          if (Day == true) {
            return 'assets/partly sunny rain.json';
          } else {
            return 'assets/partly night rain.json';
          }
        }
      case 'snow':
        return 'assets/snow.json';
      default:
        {
          if (Day == true) {
            return 'assets/sunny.json';
          } else {
            return 'assets/clear night.json';
          }
        }
    }
  }

  @override
  void initState() {
    //implement initState
    super.initState();

    _fetchWeather();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _weather?.cityName ?? "Loading...",
            style: TextStyle(fontSize: 25),
          ),
          Lottie.asset(getAnimation(_weather?.mainCondition ?? "")),
          Text(
            _weather?.temperature != null
                ? '${_weather?.temperature.round()}°C'
                : "",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            _weather?.mainCondition ?? "",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    ));
  }
}
