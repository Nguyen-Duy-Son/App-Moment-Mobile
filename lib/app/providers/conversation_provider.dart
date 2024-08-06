import 'package:flutter/foundation.dart';

import '../datasource/network_services/conversation_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  bool isLoading = false;
  bool isLoadingChatMessage = false;
  List<ChatMessage> chatMessages = [];
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
    chatMessages = await ConversationService().getChatMessage(conversationId);
    isLoadingChatMessage = false;
    notifyListeners();
  }
  void sendMessage(String conversationId,String userId, String message) async {
    isSending = true;
    int status = await ConversationService().sendMessage(userId, message);
    if(status == 200){
      chatMessages = await ConversationService().getChatMessage(conversationId);
      isSending = false;
    }
    notifyListeners();
  }
}