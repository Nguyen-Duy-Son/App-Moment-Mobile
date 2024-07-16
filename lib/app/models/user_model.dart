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
  String? role;

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
    this.role,
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
      dob: DateTime.parse(json['dob']),
      lastActive: DateTime.parse(json['lastActive']),
      isLocked: json['isLocked'],
      role: json['role'],
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
