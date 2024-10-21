import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:forecast_pro_app/view_models/weather_view_model.dart';
import 'package:forecast_pro_app/widgets/home_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../constants/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWeather();

    initializeDateFormatting('en_US', null);
  }

  void _getWeather() {
    Provider.of<WeatherViewModel>(context, listen: false)
        .getInitWeather(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _textFieldWidget() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: (provider) {
            context
                .read<WeatherViewModel>()
                .getSearchWeather(context, _searchController.text.trim());
            _searchController.clear();
          },
          style: appTextStyle().copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for a city...',
            hintStyle: appTextStyle().copyWith(color: Colors.white70),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, value, child) => Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0Xff0a3d62),
                value.weatherData == null
                    ? const Color.fromARGB(255, 45, 52, 71)
                    : const Color(0Xff1e3799)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: EasyRefresh(
              triggerAxis: Axis.vertical,
              onRefresh: () {
                value.onRefresh(context);
              },
              header: _buildEasyRefreshClassicHeader(),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: value.weatherData == null
                        ? Center(
                            child: Lottie.asset(
                              'assets/loading.json',
                              height: 200.0,
                            ),
                          )
                        : HomeWidget(
                            textFieldWiget: _textFieldWidget(),
                            weatherData: value.weatherData!,
                            currentSky: value.weatherData!.list[0].weather[0].main,
                            temp: kelvinToCelsius(value.weatherData!.list[0].main).$1,
                            maxTemp: kelvinToCelsius(value.weatherData!.list[0].main).$2,
                            minTmp: kelvinToCelsius(value.weatherData!.list[0].main).$3,
                            currentWeather: value.weatherData!.list[0],
                            onLocationTap: () {
                              value.getUserLocationAndWeather(context);
                            },
                          ),
                  ),
                  if (value.isGettingLocation) ...[
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Center(
                      child: Lottie.asset('assets/loading.json', height: 200),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ClassicHeader _buildEasyRefreshClassicHeader() {
    return ClassicHeader(
      iconTheme: const IconThemeData(color: Colors.white),
      dragText: 'Pull To Refresh',
      readyText: 'Refreshing...',
      armedText: 'Release to Refresh',
      messageStyle: appTextStyle().copyWith(color: Colors.white),
      textStyle: appTextStyle().copyWith(color: Colors.white),
      succeededIcon: const Icon(Icons.check, color: Colors.white),
    );
  }
}
