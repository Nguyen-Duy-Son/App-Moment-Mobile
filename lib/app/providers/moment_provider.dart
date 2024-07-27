import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/datasource/network_services/moment_service.dart';
import 'package:hit_moments/app/datasource/network_services/weather_service.dart';
import 'package:hit_moments/app/models/moment_model.dart';

import '../datasource/network_services/user_service.dart';
import '../models/user_model.dart';

class MomentProvider extends ChangeNotifier{
  late List<Map<String, dynamic>> options;
  User? friendSort;
  List<User> friendList=[];

  void setUserSort(User? friend){
    friendSort = friend;
    notifyListeners();
  }

  Future<void> getListFriendOfUser() async{
    var response = await UserService.getFriends();
    friendList = response.map<User>((item) => User.fromJson(item)).toList();
  }

  Future<List<MomentModel>> getListMoment() async{
    final response = await MomentService().getListMoment();

    if(response is List<MomentModel>){
      return response;
    }else{
      return [];
    }

  }

  Future<void> getWeather(String latitude, String longitude) async{
    await WeatherService().getCurrentWeather(latitude, longitude);
  }


}