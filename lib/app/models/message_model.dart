class Message{
  final String? id;
  final String? text;
  final DateTime? createdAt;
  final String? senderId;
  // final String? conversationId;
  Message(
      {required this.id, required this.text, required this.createdAt, required this.senderId
        // ,required this.conversationId}
      });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      senderId: (json['sender']?['_id'] ?? json['senderId']) ?? '',
      // conversationId: conversationId,
    );
  }
}