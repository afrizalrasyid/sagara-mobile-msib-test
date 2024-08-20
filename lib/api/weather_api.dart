import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sagaratest/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherAPI {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherAPI(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load weather: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load weather');
    }
  }

  Future<List<Weather>> get5DayForecast(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/forecast?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Weather> forecast = [];
      for (var item in data['list']) {
        forecast.add(Weather.fromJson(item));
      }
      return forecast;
    } else {
      print('Failed to load forecast: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load forecast');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city =
        placemark[0].subAdministrativeArea ?? placemark[0].administrativeArea;

    if (city != null && city.contains("Jakarta")) {
      city = "Jakarta";
    }

    print('Detected city: $city');

    return city ?? '';
  }
}
