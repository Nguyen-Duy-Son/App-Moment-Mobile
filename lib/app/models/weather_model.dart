class WeatherModel{
  final String? city;
  final String? country;
  final String? timeZone;
  final String? conditionText;
  final String? icon;
  final String? codeWeather;

  WeatherModel({
    required this.city,
    required this.country,
    required this.timeZone,
    required this.conditionText,
    required this.icon,
    required this.codeWeather,
  });
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'] as String?,
      country: json['location']['country'] as String?,
      timeZone: json['location']['tz_id'] as String?,
      conditionText: json['current']['condition']['text'] as String?,
      icon: json['current']['condition']['icon'] as String?,
      codeWeather: json['current']['condition']['code'].toString(),
    );
  }
}