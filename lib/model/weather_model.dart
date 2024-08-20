class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final DateTime date;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] ?? 0.0).toDouble(),
      mainCondition: json['weather'][0]['main'] ?? 'Unknown',
      date: json.containsKey('dt_txt')
          ? DateTime.parse(json['dt_txt'])
          : DateTime.now(),
    );
  }
}
