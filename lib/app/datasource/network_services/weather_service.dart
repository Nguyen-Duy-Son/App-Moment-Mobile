import 'package:hit_moments/app/core/config/api_url.dart';
import 'package:http/http.dart' as http;
class WeatherService{
  Future<dynamic> getCurrentWeather(String latitude, String longitude) async{
    String key = 'e3fd850f2e884b6786544651242906';
    var url = Uri.http('${ApiUrl.getCurrentWeather}?key=$key&q=$latitude,$longitude');
    var response = await http.get(url);
    if(response.statusCode==200){
      print('Thành công ${response.body}');
    }else{
      print('Thats bại');
    }
  }
}