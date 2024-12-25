import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';

class ForgotPasswordService {
  static Future<dynamic> forgotPassword(String email) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.forgotPassword,
        RequestMethod.POST,
      );
      return response;
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }


}

