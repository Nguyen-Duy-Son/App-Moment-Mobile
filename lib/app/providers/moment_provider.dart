import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/datasource/network_services/moment_service.dart';
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

  List<Map<String, dynamic>> getListFriend(){
    options = [
      {'menu': 'Option 1'},
      {'menu': 'Option 2'},
      {'menu': 'Option 3'},
      {'menu': 'Option 1'},
      {'menu': 'Option 2'},
      {'menu': 'Option 3'},
    ];
    return options;
  }

  Future<void> getListFriendOfUser() async{
    var response = await UserService.getFriends();
    friendList = response.map<User>((item) => User.fromJson(item)).toList();
    print('Danh sách bạn bè là ${friendList.length} ${response}');
  }

  Future<List<MomentModel>> getListMoment() async{
    final response = await MomentService().getListMoment();

    if(response is List<MomentModel>){
      print("Phần tử đầu là ${response[0].userName}");
      return response;
    }else{
      return [];
    }

  }


}