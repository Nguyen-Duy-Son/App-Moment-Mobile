import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/datasource/network_services/user_service.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late List<User> users;
  List<User> friendList = [];
  List<User> friendRequests = [];
  List<User> friendSuggests = [];
  ModuleStatus friendSuggestStatus = ModuleStatus.initial;
  String messageFSuggest = "";
  String messageSearchFriend = "";
  bool isLoandingFriendList = false,
      isLoandingFriendRequests = false,
      isLoandingFriendSuggests = false,
      isLoandingFriend = false,
      isLoandingUser = false;
  bool isSearchFriend = false;
  void getFriendOfUser() async {
    isLoandingFriendList = true;
    notifyListeners();
    var response = await UserService.getFriends();
    friendList = response.map<User>((item) => User.fromJson(item)).toList();
    isLoandingFriendList = false;
    notifyListeners();
  }

  void getFriendRequestOfUser() async {
    isLoandingFriendRequests = true;
    notifyListeners();
    var response = await UserService.getFriendsRequest();
    friendRequests = response.map<User>((item) => User.fromJson(item)).toList();
    isLoandingFriendRequests = false;
    notifyListeners();
  }

  void getFriendUserByEmail(String emailOfFriend) async {
    isSearchFriend = true;
    notifyListeners();
    var response = await UserService.searchFriendUserByEmail(emailOfFriend);
    friendList = [];
    if (response != 200) {
      isSearchFriend = false;
      notifyListeners();
      return;
    }
    friendList.add(User.fromJson(response));
    isSearchFriend = false;
    notifyListeners();
  }

  void getFriendProposals() async {
    isLoandingFriendSuggests = true;
    notifyListeners();
    var response = await UserService.getListSuggestFriend();
    friendSuggests = response.map<User>((item) => User.fromJson(item)).toList();
    isLoandingFriendSuggests = false;
    notifyListeners();
  }
  void getFriendSuggest() async {
    friendSuggestStatus = ModuleStatus.loading;
    notifyListeners();
    var response = await UserService.getListSuggestFriend();
    friendSuggests = response.map<User>((item) => User.fromJson(item)).toList();
    friendSuggestStatus = ModuleStatus.success;
    notifyListeners();
  }
  void sentFriendRequest(String uid) async {
    final response = await UserService.sentRequestById(uid, false);
    messageFSuggest =response;
    notifyListeners();
  }
  void searchFriendRequest(String nameOrEmail, String errorString) async {
    friendSuggestStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await UserService.searchFriendRequest(nameOrEmail);
    if(response==0){
      messageSearchFriend = errorString;
      friendSuggestStatus = ModuleStatus.fail;
    }else{
      friendSuggests = response.map<User>((item) => User.fromJson(item)).toList();
      friendSuggestStatus = ModuleStatus.success;
    }
    notifyListeners();
  }
}
