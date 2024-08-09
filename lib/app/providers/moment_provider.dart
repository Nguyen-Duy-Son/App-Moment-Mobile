import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../core/config/enum.dart';
import '../datasource/network_services/moment_service.dart';

class MomentProvider extends ChangeNotifier{
  String sendReactResult = "";
  ModuleStatus sendReactStatus = ModuleStatus.initial;
  ModuleStatus deleteMomentStatus = ModuleStatus.initial;

  Future<void> sendReact(String momentID) async{
    sendReactStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await MomentService().sendReact(momentID);
    sendReactResult = response;
    print('Kêt quả sau khi send react là ${response}');
    sendReactStatus = ModuleStatus.success;
    notifyListeners();
  }

  Future<void> deleteMoment(String momentID, String description) async{
    deleteMomentStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await MomentService().deleteMoment(momentID, description);
    print('Kêt quả sau khi xoá là ${response}');
    if(response==200){
      deleteMomentStatus = ModuleStatus.success;
    }else{
      deleteMomentStatus = ModuleStatus.fail;
    }
    notifyListeners();
  }

  Future<void> createMoment(String content, String weather, File image) async{
    await MomentService().createMoment(content, weather, image);
  }
}