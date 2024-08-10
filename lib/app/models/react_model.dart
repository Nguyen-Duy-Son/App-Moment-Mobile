class ReactModel {
  final String id;
  final String fullname;
  final String avatar;
  final List<String> reacts;

  ReactModel({
    required this.id,
    required this.fullname,
    required this.avatar,
    required this.reacts,
  });

  factory ReactModel.fromJson(Map<String, dynamic> json) {
    return ReactModel(
      id: json['_id'] ?? '',
      fullname: json['userId']['fullname'] ?? '',
      avatar: json['userId']['avatar'] ?? '',
      reacts: List<String>.from(json['reacts']?.take(5) ?? []),
    );
  }
}
