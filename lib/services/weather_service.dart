import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  /// API Call (https://openweathermap.org/current)
  /// |
  /// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
  ///
  /// Built-in API request by city name
  /// Units of measurement (metric)
  /// Format (JSON)
  /// |
  /// https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}&units=metric

  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey) {
    //!
  }

  //! Sau khi có thông tin vị trí "thành phố" sẽ truy cập API của "openweathermap"
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    // Lấy data từ "openweathermap" thành công
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    // Lấy data từ "openweathermap" thất bại
    else {
      throw Exception('Faild to load weather data');
    }
  }

  //! Dựa trên vị trị hiện tại của thiết bị để lấy thông tin "thành phố"
  Future<String> getCurrentCity() async {
    // Step 1: Get permission from User
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Step 2: Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Step 3: Convert the location into a list of placemark objects
    List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Step 4: Extract the city name from the first placemark
    String? city = placemark[0].locality;

    return city ?? "";
  }
}
