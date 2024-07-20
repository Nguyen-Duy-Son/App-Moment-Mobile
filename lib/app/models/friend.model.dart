class Friend {
  final String userId;
  late final List<String>? friendsList;
  final List<String>? friendRequests;
  final List<String>? friendSuggestions;

  Friend({
    required this.userId,
    this.friendsList,
    this.friendRequests,
    this.friendSuggestions
  });
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['userId'],
      friendsList: List<String>.from(json['friendsList']),
      friendRequests: List<String>.from(json['friendRequests']),
      friendSuggestions: List<String>.from(json['friendSuggestions']),
      // Add other properties as needed
    );
  }
}
