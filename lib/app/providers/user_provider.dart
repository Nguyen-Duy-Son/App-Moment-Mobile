import 'package:flutter/cupertino.dart';
import '../models/friend.model.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late List<User> users;
  late Friend friend;
  late List<User> friendsUsers, friendRequests, friendProposals;
  bool isLoandingFriendsUsers = true, isLoandingFriendRequests = true, isLoandingFriendProposals = true, isLoandingFriend = true, isLoandingUser = true;
  void getUser() {
    // Simulate a network request
  isLoandingUser = true;
    users = userTest;
    isLoandingFriend = false;
    // notifyListeners();
  }
  void getFriendOfUser() {
    // Simulate a network request
    isLoandingFriend = true;
    friend = friendTest;
    isLoandingFriend = false;
    // notifyListeners();
  }
  void getMyFriendsUsers() {
    // Simulate a network request
    isLoandingFriendsUsers = true;
    friendsUsers = users.where((user) => friend.friendsList!.contains(user.id)).toList();
    isLoandingFriendsUsers = false;
    // notifyListeners();
  }
  void getFriendRequests() {
    // Simulate a network request
    isLoandingFriendRequests = true;
    friendRequests = users.where((user) => friend.friendRequests!.contains(user.id)).toList();
    isLoandingFriendRequests = false;
    // notifyListeners();
  }
  void getFriendProposals(){
    // Simulate a network request
    isLoandingFriendProposals = true;
    friendProposals = users.where((user) => friend.friendSuggestions!.contains(user.id)).toList();
    isLoandingFriendProposals = false;
    // notifyListeners();

  }
}
final List<User> userTest = [
  User(
    id: '2',
    fullName: 'Nguyễn Văn Nam',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cdn.thoitiet247.edu.vn/wp-content/uploads/2024/04/nhung-hinh-anh-girl-xinh-de-thuong.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '3',
    fullName: 'Trần Thị Ngọc',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-27.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '4',
    fullName: 'Phạm Văn Tú',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-7.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '5',
    fullName: 'Lê Thị Hồng',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-6.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '6',
    fullName: 'Nguyễn Văn E',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-30.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '7',
    fullName: 'Trần Thị F',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '8',
    fullName: 'Nguyễn Thị F',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '9',
    fullName: 'Trần Nguyễn',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '10',
    fullName: 'Nguyễn Thị H',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '11',
    fullName: 'Trần Thị H',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '12',
    fullName: 'Nguyễn Văn H',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
  User(
    id: '13',
    fullName: 'Trần Văn H',
    email: 'nguyenvannam@example.com',
    avatar:
    'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
    phoneNumber: '0123456789',
    dob: DateTime(1990, 1, 1),
  ),
];
final Friend friendTest = Friend(
  userId: '1',
  friendsList: ['2', '3', '6', '7'],
  friendRequests: ['4', '5', '8', '9'],
  friendSuggestions: ['10', '11', '12', '13'],
);