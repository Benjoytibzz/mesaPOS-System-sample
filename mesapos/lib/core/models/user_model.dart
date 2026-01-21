class UserModel {
  final int? id;
  final String username;
  final String passwordHash;
  final String role;
  final String firstName;
  final String lastName;
  final String? imagePath;
  final int isActive;
  final int synced;

  UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.imagePath,
    this.isActive = 1,
    this.synced = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'image_path': imagePath,
      'is_active': isActive,
      'synced': synced,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      role: map['role'],
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      imagePath: map['image_path'],
      isActive: map['is_active'] ?? 1,
      synced: map['synced'] ?? 0,
    );
  }
}
