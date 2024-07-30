import 'package:hit_moments/app/models/user_model.dart';

class ChatMessage{
  final String text;
  final String id;
  final User sender;

  ChatMessage({required this.text, required this.id, required this.sender});

  factory ChatMessage.fromJson(dynamic json){
    return ChatMessage(
      text: json['text'],
      id: json['_id'],
      sender: User.fromJson(json['senderId'])
    );
  }
}