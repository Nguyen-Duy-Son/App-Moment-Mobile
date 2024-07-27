class Message{
  final String? id;
  final String? text;
  final DateTime? createdAt;

  Message({required this.id, required this.text, required this.createdAt});

  factory Message.fromJson(dynamic json){
    return Message(
      id: json['_id'] as String,
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt'])
    );
  }
}