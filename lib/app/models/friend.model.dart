class Friend {
  final String userId;
  final List<String>? friendsList;
  final List<String>? friendRequests;
  final List<String>? friendSuggestions;

  Friend({
    required this.userId,
    this.friendsList,
    this.friendRequests,
    this.friendSuggestions
  });
}
