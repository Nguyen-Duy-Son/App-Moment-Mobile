import 'package:flutter/foundation.dart';
import 'package:hit_moments/app/models/message_model.dart';

import '../datasource/network_services/conversation_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  bool isLoading = false;
  bool isLoadingChatMessage = false;
  List<ChatMessage> chatMessages = [];
  List<Message>messages = [];
  bool isSending = false;
  void getConversations() async {
    isLoading = true;
    notifyListeners();
    conversations = await ConversationService().getConversations() ;
    isLoading = false;
    notifyListeners();
  }
  void getChatMessage(String conversationId) async {
    isLoadingChatMessage = true;
    notifyListeners();
    messages = await ConversationService().getConversationById(conversationId);
    isLoadingChatMessage = false;
    notifyListeners();
  }
  void getChatMessageByReceiverId(String receiverId) async {
    isLoadingChatMessage = true;
    notifyListeners();
    messages = await ConversationService().getConversationByReceiverId(receiverId);
    isLoadingChatMessage = false;
    notifyListeners();
  }
  void sendMessage(String conversationId,String userId, String message) async {
    isSending = true;
    int status = await ConversationService().sendMessage(userId, message);
    if(status == 200){
      messages = await ConversationService().getConversationById(conversationId);
      isSending = false;
    }
    notifyListeners();
  }
}