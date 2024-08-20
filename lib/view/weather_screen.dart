import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sagaratest/api/weather_api.dart';
import 'package:sagaratest/model/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherAPI = WeatherAPI('553c489ed5c1c42f4613d0f0466526f6');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherAPI.getCurrentCity();
    try {
      final weather = await _weatherAPI.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
        return 'assets/mist.json';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 60, 61, 55),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? 'loading city..',
              style: const TextStyle(color: Colors.white),
            ),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
