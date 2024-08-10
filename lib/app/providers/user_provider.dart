import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/datasource/network_services/user_service.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late List<User> users;
  List<User> friendList = [];
  List<User> friendListTmp = [];
  List<User> friendRequests = [];
  List<User> friendSuggests = [];
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
    friendListTmp = friendList;
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
    //
    if (response != 200) {
      friendList = response.map<User>((item) => User.fromJson(item)).toList();
      isSearchFriend = false;
      notifyListeners();
      return;
    }
  }

  void getFriendProposals() async {
    isLoandingFriendSuggests = true;
    notifyListeners();
    var response = await UserService.getListSuggestFriend();
    friendSuggests = response.map<User>((item) => User.fromJson(item)).toList();
    isLoandingFriendSuggests = false;
    notifyListeners();
  }
  void refeshData() {
    friendList = friendListTmp;
    friendList.map((user) {
      print('User: ${user.fullName}, Email: ${user.email}');
    });
    // notifyListeners();
  }
}
