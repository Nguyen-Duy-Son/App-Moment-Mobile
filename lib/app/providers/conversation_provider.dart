import 'package:flutter/foundation.dart';
import 'package:hit_moments/app/core/config/enum.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notif;
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../datasource/network_services/conversation_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  ModuleStatus loadingMessageStatus = ModuleStatus.initial;
  bool isLoading = false;
  bool isLoadingChatMessage = false;
  List<ChatMessage> chatMessages = [];
  List<Message> messages = [];
  bool isSending = false;
  bool isTyping = false;
  // https://api.hitmoments.com
  IO.Socket socket = IO.io('https://nv4d05g8-3000.asse.devtunnels.ms/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'query': {
      'userId': getUserID(),
    }
  });

  void getConversations() async {
    // isLoading = true;
    loadingMessageStatus = ModuleStatus.loading;
    notifyListeners();
    final data = await ConversationService().getConversations();
    if(data is List<Conversation>) {
      conversations = data;
      loadingMessageStatus = ModuleStatus.success;
    } else {
      loadingMessageStatus = ModuleStatus.fail;
    }
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

  Future<void> sendMessage(String userId, String message) async {
    isSending = true;
    int status = await ConversationService().sendMessage(userId, message);
    if (status == 200) {
      socket.emit('newMessage', {
        'text': message,
      });
      Message newMessage = Message(
        id: '',
        text: message,
        createdAt: DateTime.now(),
        senderId: getUserId(),
      );
      messages.add(newMessage);
      // messages = await ConversationService().getConversationByReceiverId(userId);
      isSending = false;
    }
    notifyListeners();
  }

  void connectAndListen() async {
    socket.onConnect((_) {
      print('Connected to the server'); // Debug print
    });
    socket.on('newMessage', (data) {
      if (data != null && data is Map<String, dynamic>) {
        // Check if message already exists to prevent duplicates
        final newMessage = Message.fromJson(data);
        final exists = messages.any((msg) => msg.id == newMessage.id);

        if (!exists) {
          messages.add(newMessage);
          notifyListeners();
        }
      }
    });

    socket.connect();
  }

  void disconnectSocket() {
    if (socket.connected) {
      // print('Disconnected from the server');
      socket.close();
    }
  }


}
