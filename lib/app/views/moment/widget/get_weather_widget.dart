import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/models/weather_model.dart';
import 'package:hit_moments/app/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class GetWeatherWidget extends StatefulWidget {
  const GetWeatherWidget({super.key});

  @override
  State<GetWeatherWidget> createState() => _GetWeatherWidgetState();
}

class _GetWeatherWidgetState extends State<GetWeatherWidget> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherProvider>().getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (weatherProvider.weatherStatus != ModuleStatus.initial) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thời tiết của ${weatherProvider.weather?.city} là ${weatherProvider.weather?.conditionText}",
                    ),
                    CachedNetworkImage(imageUrl: "https:${weatherProvider.weather?.icon}")
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}