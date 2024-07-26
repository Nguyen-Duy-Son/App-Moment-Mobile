import 'dart:convert';

import 'package:hit_moments/app/core/config/api_url.dart';
import 'package:http/http.dart' as http;

import '../../core/base/base_connect.dart';
class WeatherService{
  Future<dynamic> getCurrentWeather(String latitude, String longitude) async {
    String apiKey = 'e3fd850f2e884b6786544651242906';
    try {
      var queryParam = {
        'key': apiKey,
        'q': '$latitude,$longitude',
      };
      var response = await BaseConnect.onRequest(
        ApiUrl.getCurrentWeather,
        RequestMethod.GET,
        queryParam: queryParam,
      );
      print('Thành công: ${jsonEncode(response)}');
      return response;
    } catch (e) {
      print('Thất bại: $e');
      return null;
    }
  }
}