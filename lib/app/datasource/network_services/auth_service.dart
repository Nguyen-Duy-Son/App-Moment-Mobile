import 'package:hit_moments/app/core/base/base_connect.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import '../../core/config/api_url.dart';

class AuthService{

  Future<dynamic> login(String email, String password) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password
    };
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.login,
        RequestMethod.POST,
        body: body
      );
      int statusCode = response['statusCode'];
      print(response);
      if(statusCode == 200){
        String token = response['data']['accessToken'];
        setToken(token);
      }else{
        print("looxi ${response['message']} vaf ${statusCode}");
      }
      return statusCode;
    }catch(e){
      print("Lỗi là: ${e}");
      return 0;
    }
  }


  Future<dynamic> register(String fullName, String phoneNumber, String dateOfBirth,
      String email, String passWord) async{
    print("${fullName} + ${phoneNumber} + ${dateOfBirth} + ${email} + ${passWord}");
    Map<String, dynamic> body = {
      'fullname': fullName,
      'email': email,
      'password': passWord,
      'phoneNumber': phoneNumber,
      'dob': '1999-12-31T17:00:00.000Z',
    };
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.register, RequestMethod.POST, body: body);
      int statusCode = response['statusCode'];
      String mess = response['message'];
      print("status code ${statusCode} và ${mess}");
      return statusCode;
      }catch(e){
      print("Lỗi ${e}");
      return 0;
    }
  //   {
  //     "statusCode": 409,
  //   "message": "Email đã tồn tại"
  // }
  }

}