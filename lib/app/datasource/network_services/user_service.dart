import 'package:hit_moments/app/datasource/local/storage.dart';

import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
class UserService{
  static Future<dynamic>getFriends() async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.getFriends,
          RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if(statusCode == 200){
        print("Dữ liệu: ${response['data']["friendList"]}");
        return response['data']["friendList"];
      }else{
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
}