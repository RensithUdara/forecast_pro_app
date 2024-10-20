import 'dart:convert';

import 'package:forecast_pro_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$openWeatherApiKey'));
      final data = jsonDecode(response.body);

      switch (data['cod']) {
        case '404':
          throw 'Not found';
        case '200':
          return data;
        default:
          throw 'An error occurd';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
