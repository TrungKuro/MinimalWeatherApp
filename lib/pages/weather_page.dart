import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API Key
  //! Sử dụng dịch vụ thời tiết từ lớp "WeatherService"
  final _weatherService = WeatherService('731d70a607d26d5093cd8c9a418cafd8');
  //! Dữ liệu thời tiết từ "Module Weather"
  Weather? _weather;

  // Fetch Weather
  _fetchWeather() async {
    // Get the current city
    String cityName = await _weatherService.getCurrentCity();

    // Get the weather of city
    try {
      final weather = await _weatherService.getWeather(cityName);
      //! Tải lại các Widget nếu có trạng thái mới
      setState(() {
        _weather = weather;
      });
    }

    // Catch any errors if have
    catch (e) {
      print(e);
    }
  }

  // Weather Animations
  String getWeatherAnimation(String? mainCondition) {
    //! Nếu ko có thông tin về thời tiết, hiển thị mặc định animation này
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/windy.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'fog':
      case 'dust':
      case 'haze':
      case 'smoke':
      case 'mist':
        return 'assets/mist.json';
      case 'snow':
        return 'assets/snow.json';
      case 'rain':
        return 'assets/storm.json';
      case 'drizzle':
        return 'assets/partly-shower.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Init State
  @override
  void initState() {
    super.initState();

    // Fetch the weather on starup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tên thành phố
            Text(
              _weather?.cityName ?? 'Loading city...',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            // Ảnh động mô tả thời tiết khu vực đó
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            // Nhiệt độ khu vực đó
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            // Điều kiện thời tiết khu vực đó
            const SizedBox(
              height: 10,
            ),
            Text(
              _weather?.mainCondition ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
