class Weather {
  String cityName;
  double temperature;
  String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      // cityName: json['name'].toString(),
      // temperature: (json['main']['temp'] as double).toDouble(),
      // mainCondition: json['weather'][0]['main'].toString(),

      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
