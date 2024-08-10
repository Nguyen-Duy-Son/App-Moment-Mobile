import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/user_model.dart';
import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';

class UserService {
  static Future<dynamic> getFriends() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getFriends,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      print(response['data']["friendList"]);
      if (statusCode == 200) {
        return response['data']["friendList"];
      } else {
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> getFriendsRequest() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getFriendsRequest,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        return response['data']["friendRequests"];
      } else {
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<int> deleteFriendOfUserById(String id) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.deleteFriend, RequestMethod.DELETE,
          body: {"friendId": id});
      print("Status delete friend: ${response['statusCode']}");
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<int> confirmFriendRequestOfUserBy(
      String friendId, int option) async {
    try {
      var response;
      if (option == 1) {
        response = await BaseConnect.onRequest(
            ApiUrl.confirmFriendRequest, RequestMethod.POST,
            body: {"requesterId": friendId});
      } else {
        response = await BaseConnect.onRequest(
            ApiUrl.declineFriendRequest, RequestMethod.POST,
            body: {"requesterId": friendId});
      }
      print("Status decline friend: ${response['statusCode']}");
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> searchFriendUserByEmail(String emailOfFriend) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.searchFriendOfUser, RequestMethod.GET,
          queryParam: {"search": emailOfFriend});
      print("Status search friend: ${response['data']['users']}");
      if(response["statusCode"] == 200){
        return response["data"]["users"];
      }
      else{
        return response["statusCode"];
      }
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> sentRequestById(String id, bool isResult) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.sentFriendRequestOfUser, RequestMethod.POST,
          body: {"receiverId": id});
      if(isResult){
        int statusCode = response['statusCode'];
        return statusCode;
      }else{
        return response['statusCode']['message'];
      }
    } catch (e) {
      if(isResult){
        print("Lỗi: ${e}");
        return 0;
      }else{
        return e.toString();
      }

    }
  }

  static Future<int> cancelRequestByUserId(String id) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.cancelRequestByUserId, RequestMethod.POST,
          body: {"receiverId": id});
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> getListSuggestFriend() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getListSuggestFriend,
        RequestMethod.GET,
      );
      return response['data']["suggestedUsers"].take(5);
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic> searchFriendRequest(String nameOrEmail) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.searchFriendOfUser,
        RequestMethod.GET,
        queryParam: {"search": nameOrEmail}
      );
      return response['data']["users"].take(5);
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic>getMe() async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.getMe,
          RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      print(response['data']["user"]);
      if(statusCode == 200){
        print(response['data']["user"]);
        return User.fromJson(response['data']["user"]);
      }else{
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic>updateUser() async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.getMe,
          RequestMethod.POST,
      );
      int statusCode = response['statusCode'];
      print(response['data']["user"]);
      if(statusCode == 200){
        print(response['data']["user"]);
        return User.fromJson(response['data']["user"]);
      }else{
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
}

