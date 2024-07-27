import 'package:flutter/foundation.dart';

import '../datasource/network_services/conversation_service.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  bool isLoading = false;

  void getConversations() async {
    isLoading = true;
    notifyListeners();
    conversations = await ConversationService().getConversations() ;
    isLoading = false;
    notifyListeners();
  }
}