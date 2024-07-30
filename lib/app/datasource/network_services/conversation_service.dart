import 'package:hit_moments/app/models/chat_message_model.dart';

import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
import '../../models/conversation_model.dart';
// class ConversationService{
//   Future<List<Conversation>> getConversations() async {
//     try {
//       print("getConversations");
//       var response = await BaseConnect.onRequest(
//         ApiUrl.getConversation,
//         RequestMethod.GET,
//       );
//       int statusCode = response['statusCode'];
//       if (statusCode == 200) {
//         List<Map<String, dynamic>> conversationList = response['data']["myConversations"];
//         return conversationList.map((item) => Conversation.fromJson(item)).toList().cast<Conversation>();
//       } else {
//         print("Lỗi: ${response['message']} ");
//       }
//     } catch (e) {
//       print("Lỗi: ${e}");
//     }
//     return [];
//   }
// }
class ConversationService{
  Future<List<Conversation>> getConversations() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getConversation,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        List< dynamic> conversationList = response['data']["myConversations"] ;
        return conversationList.map((item) => Conversation.fromJson(item as dynamic)).toList();
      } else {
        print("Lỗi: ${response['message']} ");
      }
    } catch (e) {
      print("Lỗi: ${e}");
    }
    return [];
  }
  Future<List<ChatMessage>> getChatMessage(String conversationId) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getChatMessage,
        RequestMethod.GET,
        idParam: conversationId,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        List<dynamic> messageList = response['data']["message"] ;
        // print("messageList: ${response['data']["message"]}");
        return messageList.map((item) => ChatMessage.fromJson(item as dynamic)).toList();
      } else {
        print("Lỗi: ${response['message']} ");
      }
    } catch (e) {
      print("Lỗi: ${e}");
    }
    return [];
  }
}