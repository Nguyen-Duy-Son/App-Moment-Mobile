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
        return response['data'];
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