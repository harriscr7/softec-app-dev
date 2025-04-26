class UserModel {
  final String uid;
  final String email;
  final String username;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      createdAt: map['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'createdAt': createdAt,
    };
  }
} 