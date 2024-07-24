import 'package:hit_moments/app/datasource/local/storage.dart';

import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
class UserService{
  static Future<dynamic>getFriends() async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.getFriends,
          RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if(statusCode == 200){
        return response['data']["friendList"];
      }else{
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic>getFriendsRequest() async{
    try{
      var response = await BaseConnect.onRequest(
        ApiUrl.getFriendsRequest,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if(statusCode == 200){
        return response['data']["friendRequests"];
      }else{
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<int>deleteFriendOfUserById(String id) async{
    try{
      var response = await BaseConnect.onRequest(
        ApiUrl.deleteFriend,
        RequestMethod.DELETE,
        body: {
          "friendId": id
        }
      );
      print("Status delete friend: ${response['statusCode']}");
      return response['statusCode'];
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<int>confirmFriendRequestOfUserBy(String friendId,int option) async{
    try{
      var response;
      if(option == 1){
         response = await BaseConnect.onRequest(
            ApiUrl.confirmFriendRequest,
            RequestMethod.POST,
            body: {
              "requesterId": friendId
            }
        );
      }
      else{
        response = await BaseConnect.onRequest(
            ApiUrl.declineFriendRequest,
            RequestMethod.POST,
            body: {
              "requesterId": friendId
            }
        );
      }
      print("Status decline friend: ${response['statusCode']}");
      return response['statusCode'];
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic>searchFriendUserByEmail(String emailOfFriend) async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.searchFriendOfUser,
          RequestMethod.GET,
          queryParam: {
            "email": emailOfFriend
          }
      );
      return response["data"]["user"];
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<int>sentRequestById(String id) async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.sentFriendRequestOfUser,
          RequestMethod.POST,
          body: {
            "receiverId": id
          }
      );
      print("message: ${response['message']}");
      return response['statusCode'];
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<int>cancelRequestByUserId(String id) async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.cancelRequestByUserId,
          RequestMethod.POST,
          body: {
            "receiverId": id
          }
      );
      print("message: ${response['message']}");
      return response['statusCode'];
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
}