import 'package:hit_moments/app/models/user_model.dart';

import 'message_model.dart';

class Conversation {
  final String id;
  final User user;
  final Message? lastMessage;

  Conversation({
    required this.id,
    required this.user,
    this.lastMessage,
  });

  factory Conversation.fromJson(dynamic json) {
    return Conversation(
      id: json['_id'] as String,
      user: User.fromJson(json['user']),
      lastMessage: json['lastMessage'] is Map ? Message.fromJson(json['lastMessage']) : null,
    );
  }
}