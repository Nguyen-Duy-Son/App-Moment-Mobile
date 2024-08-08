import 'package:flutter/foundation.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../datasource/network_services/conversation_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  bool isLoading = false;
  bool isLoadingChatMessage = false;
  List<ChatMessage> chatMessages = [];
  List<Message> messages = [];
  bool isSending = false;

  IO.Socket socket = IO.io('https://api.hitmoments.com', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'query': {
      'userId': getUserId(),
    }
  });

  void getConversations() async {
    isLoading = true;
    notifyListeners();
    conversations = await ConversationService().getConversations();
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

  void sendMessage(String conversationId, String userId, String message) async {
    isSending = true;
    int status = await ConversationService().sendMessage(userId, message);
    if (status == 200) {
      socket.emit('newMessage', {
        'text': message,
      });
      messages = await ConversationService().getConversationById(conversationId);
      isSending = false;
    }
    notifyListeners();
  }

  void connectAndListen() async {
    socket.on(
        'connection',
        (data) => {
              print('Connected to the server'),
            });
    socket.onConnect((_) {
      print('Connected to the server'); // Debug print
    });
    socket.on('newMessage', (data) {
      print('newMessage event triggered $data'); // Debug print

      messages.add(Message.fromJson(data as Map<String, dynamic>));

      notifyListeners();
      //_streamController.add(data);
    });

    socket.onDisconnect((_) {
      print('Disconnected from the server'); // Debug print
    });
    socket.on('fromServer', (_) {
      print('fromServer event triggered'); // Debug print
    });
    socket.connect();
  }

  void disconnectSocket() {
    if (socket.connected) {
      socket.close();
    }
  }
}
