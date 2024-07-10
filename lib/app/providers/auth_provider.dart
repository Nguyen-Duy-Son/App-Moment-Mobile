import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/core/constants/app_constants.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/datasource/network_services/auth_service.dart';

import '../core/config/enum.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool isFullFieldLogin = true;
  bool isFullFieldRegister = true;
  ModuleStatus loginStatus = ModuleStatus.initial;
  ModuleStatus registerStatus = ModuleStatus.initial;
  String? loginSuccess;
  String? registerSuccess;
  String? emailExist;

  void fullFieldRegister(bool isFull) {
    isFullFieldRegister = isFull;
    notifyListeners();
  }


  void setData(bool isFull){
    loginSuccess = null;
    registerSuccess =null;
    emailExist = null;
    isFullFieldLogin = isFull;
    isFullFieldRegister = isFull;
  }
  void fullFieldLogin(bool isFull) {
    isFullFieldLogin = isFull;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    loginStatus = ModuleStatus.loading;
    notifyListeners();
    try {
      int result = await authService.login(email, password);
      if (result == 200) {
        loginSuccess = "Đăng nhập thành công!";
        loginStatus = ModuleStatus.success;
      } else if (result == 401) {
        loginSuccess =
        "Email hoặc mật khẩu không chính xác. Vui lòng kiểm tra lại!";
        loginStatus = ModuleStatus.fail;
      } else if(result == 400){
        loginSuccess =
        "Email chưa đúng định dạng!";
        loginStatus = ModuleStatus.fail;
      }else {
        loginSuccess = "Lỗi! Hãy kiểm tra kết nối mạng và thử lại";
        loginStatus = ModuleStatus.fail;
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }


  Future<void> register(String fullName, String phoneNumber,
      String dob, String email, String passWord) async {
    registerStatus = ModuleStatus.loading;
    notifyListeners();
    try {
      int result = await authService.register(
          fullName, phoneNumber, dob, email, passWord);
      print("kết quả là ${result}");
      switch(result) {
        case 201:
          registerSuccess = "Đăng ký thành công!";
          emailExist = null;
          registerStatus = ModuleStatus.success;
          setPassWord(passWord);
          setEmail(email);
          notifyListeners();
          break;
        case 409:
          registerSuccess = null;
          emailExist = "Email đã tồn tại";
          registerStatus = ModuleStatus.fail;
          notifyListeners();
          break;
        default:
          registerSuccess = "Lỗi, hãy thử lại";
          registerStatus = ModuleStatus.fail;
          notifyListeners();
          print("Unknown status");
    }
      }catch (e) {
        print("Lỗi ${e}");
      }
    }
}
