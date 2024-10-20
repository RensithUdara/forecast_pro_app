import 'package:flutter/material.dart';

import '../models/weather.dart';

const String openWeatherApiKey = '07880e59fb4ed5c50f8587e8ddb26f7e';
const defaultCity = 'Galle';

TextStyle appTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 16.0);
}

(double, double, double) kelvinToCelsius(MainClass main) {
  const double kelvinDifference = 273.15;
  return (
    (main.temp - kelvinDifference).floorToDouble(),
    main.tempMax - kelvinDifference,
    main.tempMin - kelvinDifference
  );
}
