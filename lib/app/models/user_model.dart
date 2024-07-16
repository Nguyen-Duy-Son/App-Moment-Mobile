// class User {
//   String id;
//   String? password;
//   String? email;
//   String fullName;
//   String? phoneNumber;
//   String? avatar;
//   DateTime? dob;
//   DateTime? lastActive;
//   bool? isLocked;
//   bool? isVerified;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   User({
//     required this.id,
//     this.password,
//     this.email,
//     required this.fullName,
//     this.phoneNumber,
//     this.avatar,
//     this.dob,
//     this.lastActive,
//     this.isLocked,
//     this.isVerified,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   // JSON serialization
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       password: json['password']?json['password']:null,
//       email: json['email'],
//       fullName: json['fullname'],
//       phoneNumber: json['phoneNumber'],
//       avatar: json['avatar'],
//       dob: DateTime.parse(json['dob']),
//       lastActive: DateTime.parse(json['lastActive']),
//       isLocked: json['isLocked'],
//       isVerified: json['isVerified'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
// }
class User {
  String id;
  String? password;
  String? email;
  String fullName;
  String? phoneNumber;
  String? avatar;
  DateTime? dob;
  DateTime? lastActive;
  bool? isLocked;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    required this.id,
    this.password,
    this.email,
    required this.fullName,
    this.phoneNumber,
    this.avatar,
    this.dob,
    this.lastActive,
    this.isLocked,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      password: json['password'],
      email: json['email'],
      fullName: json['fullname'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      lastActive: json['lastActive'] != null ? DateTime.parse(json['lastActive']) : null,
      isLocked: json['isLocked'],
      isVerified: json['isVerified'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}