import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/datasource/network_services/list_moment_service.dart';
import 'package:hit_moments/app/datasource/network_services/moment_service.dart';
import 'package:hit_moments/app/datasource/network_services/weather_service.dart';
import 'package:hit_moments/app/models/moment_model.dart';

import '../datasource/network_services/user_service.dart';
import '../models/user_model.dart';

class ListMomentProvider extends ChangeNotifier{
  late List<Map<String, dynamic>> options;

  User? friendSort;
  bool isVisibilityGridview = false;
  List<User> friendList=[];
  List<MomentModel> momentList=[];
  List<MomentModel> _listMomentMore=[];
  ModuleStatus getListMomentStatus = ModuleStatus.initial;
  ModuleStatus loadMoreStatus = ModuleStatus.initial;
  int _pageIndex = 1;
  int _pageIndexSort = 1;

  Future<void> getListFriendOfUser() async{
    var response = await UserService.getFriends();
    friendList = response.map<User>((item) => User.fromJson(item)).toList();
  }

  Future<void> getListMoment() async{
    _pageIndex=1;
    _pageIndexSort=1;
    friendSort = null;
    getListMomentStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await ListMomentService().getListMoment(_pageIndex);
    if(response is List<MomentModel>){
      getListMomentStatus = ModuleStatus.success;
      momentList =  response;
    }else{
      getListMomentStatus = ModuleStatus.fail;
      momentList =  [];
    }
    notifyListeners();

  }
  Future<void> getListMomentByUserID(User? friend) async{
    _pageIndex=1;
    _pageIndexSort=1;
    friendSort = friend;
    getListMomentStatus = ModuleStatus.loading;
    notifyListeners();
    if(friend==null){
      final response = await ListMomentService().getListMoment(_pageIndex);
      if(response is List<MomentModel>){
        momentList = response;
        getListMomentStatus = ModuleStatus.success;
      }else{
        momentList =  [];
        getListMomentStatus = ModuleStatus.fail;
      }
    }else{
      final response = await ListMomentService().getListMomentByUserID(friend.id, _pageIndex);
      if(response is List<MomentModel>){
        momentList = response;
        getListMomentStatus = ModuleStatus.success;
      }else{
        momentList = [];
        getListMomentStatus = ModuleStatus.fail;
      }
    }
    notifyListeners();
  }

  Future<void> loadMoreListMoment() async{


    if(friendSort==null){
      print("Load $_pageIndex");
      _pageIndex++;
      _pageIndexSort=1;
      loadMoreStatus = ModuleStatus.loading;
      notifyListeners();
      final response = await ListMomentService().getListMoment(_pageIndex);
      if(response is List<MomentModel>){
        _listMomentMore =  response;
        momentList.addAll(_listMomentMore);
        loadMoreStatus = ModuleStatus.success;
      }else{
        _listMomentMore =  [];
        loadMoreStatus = ModuleStatus.fail;
        print('Thất bại 1');

      }
      notifyListeners();
    }else{
      _pageIndexSort++;
      _pageIndex=1;
      loadMoreStatus = ModuleStatus.loading;
      notifyListeners();
      final response = await ListMomentService().getListMomentByUserID(friendSort!.id, _pageIndexSort);
      if(response is List<MomentModel>){
        _listMomentMore = response;
        momentList.addAll(_listMomentMore);
        loadMoreStatus = ModuleStatus.success;
      }else{
        _listMomentMore = [];
        loadMoreStatus = ModuleStatus.fail;
        print('Thất bại 2');
      }
      notifyListeners();
    }

  }

  Future<void> getWeather(String latitude, String longitude) async{
    await WeatherService().getCurrentWeather(latitude, longitude);
  }

  Future<void> saveImage(String url) async{
    try{
      String path = await MomentService().saveImage(url);
      print('Thaành công, lưu ở $path');
    }catch(e){
      print('Thất bại $e}');
    }
  }


}