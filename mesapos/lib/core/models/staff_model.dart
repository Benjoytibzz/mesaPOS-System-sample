enum StaffRole { host, cashier, admin, staff }

class StaffModel {
  final int? id;
  final String username;
  final String firstName;
  final String lastName;
  final String passwordHash;
  final String role;
  final String? email;
  final String? phone;
  final int synced;     // 0 = not synced, 1 = synced
  final int isActive;   // 0 = inactive, 1 = active

  StaffModel({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.passwordHash,
    required this.role,
    this.email,
    this.phone,
    this.synced = 0,
    this.isActive = 1,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'password_hash': passwordHash,
      'role': role,
      'email': email,
      'phone': phone,
      'synced': synced,
      'is_active': isActive,
    };
  }

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      id: map['id'],
      username: map['username'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      passwordHash: map['password_hash'],
      role: map['role'],
      email: map['email'],
      phone: map['phone'],
      synced: map['synced'],
      isActive: map['is_active'],
    );
  }
}
