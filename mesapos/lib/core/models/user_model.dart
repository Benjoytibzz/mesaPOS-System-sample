class UserModel {
  final int? id;
  final String username;
  final String passwordHash;
  final String role;
  final int synced;

  UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    this.synced = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'role': role,
      'synced': synced,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      role: map['role'],
      synced: map['synced'],
    );
  }
}
