import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/core/constants/app_constants.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/datasource/network_services/auth_service.dart';
import 'package:hit_moments/app/models/user_model.dart';

import '../core/config/enum.dart';
import '../l10n/l10n.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool isFullFieldLogin = true;
  bool isFullFieldRegister = true;
  ModuleStatus loginStatus = ModuleStatus.initial;
  ModuleStatus registerStatus = ModuleStatus.initial;
  String? loginSuccess;
  String? registerSuccess;
  String? emailExist;
  bool isRemember = false;

  void fullFieldRegister(bool isFull) {
    isFullFieldRegister = isFull;
    notifyListeners();
  }

  void changeRemember(){
    isRemember = !isRemember;
    notifyListeners();
  }


  void setData(bool isFull){
    loginSuccess = null;
    registerSuccess =null;
    emailExist = null;
    isFullFieldLogin = isFull;
    isFullFieldRegister = isFull;
    isRemember = false;
  }
  void fullFieldLogin(bool isFull) {
    isFullFieldLogin = isFull;
    notifyListeners();
  }

  Future<void> checkToken() async{
    loginStatus = ModuleStatus.loading;
    try{
      dynamic result = await authService.getMe();
      if(result is User){
        loginStatus = ModuleStatus.success;
      }else{
        loginStatus = ModuleStatus.fail;
      }
      notifyListeners();
    }catch(e){
      loginStatus = ModuleStatus.fail;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password, BuildContext context) async {
    loginStatus = ModuleStatus.loading;
    notifyListeners();
    try {
      int result = await authService.login(email, password);
      if (result == 200) {
        loginSuccess = S.of(context).loginSuccess;
        loginStatus = ModuleStatus.success;

        if(isRemember){
          setPassWord(password);
          setEmail(email);
        }
      } else if (result == 401) {
        loginSuccess = S.of(context).loginError;
        loginStatus = ModuleStatus.fail;
      } else if(result == 400){
        loginSuccess =
        S.of(context).emailInvalid;
        loginStatus = ModuleStatus.fail;
      }else {
        loginSuccess = S.of(context).networkError;
        loginStatus = ModuleStatus.fail;
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }


  Future<void> register(String fullName, String phoneNumber,
      String dob, String email, String passWord, BuildContext context) async {
    registerStatus = ModuleStatus.loading;
    notifyListeners();
    try {
      int result = await authService.register(
          fullName, phoneNumber, dob, email, passWord);
      switch(result) {
        case 201:
          registerSuccess = S.of(context).registerSuccess;
          emailExist = null;
          registerStatus = ModuleStatus.success;
          notifyListeners();
          break;
        case 409:
          registerSuccess = null;
          emailExist = S.of(context).emailExists;
          registerStatus = ModuleStatus.fail;
          notifyListeners();
          break;
        default:
          registerSuccess = S.of(context).genericError;
          registerStatus = ModuleStatus.fail;
          notifyListeners();
    }
      }catch (e) {
        print("Lỗi ${e}");
      }
    }
}
