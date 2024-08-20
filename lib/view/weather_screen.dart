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
  Weather? _currentWeather;
  List<Weather> _forecast = [];

  _fetchWeather() async {
    String cityName = await _weatherAPI.getCurrentCity();
    try {
      final weather = await _weatherAPI.getWeather(cityName);
      final forecast = await _weatherAPI.get5DayForecast(cityName);

      setState(() {
        _currentWeather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/json/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
        return 'assets/json/mist.json';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/json/storm.json';
      case 'clear':
        return 'assets/json/sunny.json';
      default:
        return 'assets/json/sunny.json';
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              _currentWeather?.cityName ?? 'loading city..',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Lottie.asset(
              getWeatherAnimation(_currentWeather?.mainCondition),
            ),
            Text(
              '${_currentWeather?.temperature.round()}°C',
              style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              _currentWeather?.mainCondition ?? "",
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _forecast.isNotEmpty ? 19 : _forecast.length,
                itemBuilder: (context, index) {
                  final weather = _forecast[index];
                  final formattedDate = weather.date != null
                      ? weather.date.toLocal().toString().substring(0, 10)
                      : "N/A";
                  final formattedTime = weather.date != null
                      ? weather.date.toLocal().toString().substring(11, 16)
                      : "N/A";
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Lottie.asset(
                        getWeatherAnimation(weather.mainCondition),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      '$formattedDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '$formattedTime - ${weather.temperature.round()}°C, ${weather.mainCondition}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
