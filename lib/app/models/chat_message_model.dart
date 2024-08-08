import 'package:hit_moments/app/models/user_model.dart';

class ChatMessage{
  final String text;
  final String id;
  final User sender;
  final DateTime createdAt;
  ChatMessage({required this.text, required this.id, required this.sender,required this.createdAt });

  factory ChatMessage.fromJson(dynamic json){
    return ChatMessage(
      text: json['text'],
      id: json['_id'],
      sender: User.fromJson(json['sender']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}