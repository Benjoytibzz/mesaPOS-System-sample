enum StaffRole { host, waiter, kitchen, manager }

class StaffModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final StaffRole role;
  final DateTime joinDate;
  final String? profileImage;
  final int assignedBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int completedBookings;

  StaffModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.joinDate,
    this.profileImage,
    this.assignedBookings = 0,
    this.pendingBookings = 0,
    this.confirmedBookings = 0,
    this.completedBookings = 0,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: _parseRole(json['role']),
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      profileImage: json['profileImage'],
      assignedBookings: json['assignedBookings'] ?? 0,
      pendingBookings: json['pendingBookings'] ?? 0,
      confirmedBookings: json['confirmedBookings'] ?? 0,
      completedBookings: json['completedBookings'] ?? 0,
    );
  }

  static StaffRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'host':
      case 'host/reservation staff':
        return StaffRole.host;
      case 'waiter':
        return StaffRole.waiter;
      case 'kitchen':
        return StaffRole.kitchen;
      case 'manager':
        return StaffRole.manager;
      default:
        return StaffRole.host;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'joinDate': joinDate.toIso8601String(),
      'profileImage': profileImage,
      'assignedBookings': assignedBookings,
      'pendingBookings': pendingBookings,
      'confirmedBookings': confirmedBookings,
      'completedBookings': completedBookings,
    };
  }

  String get roleDisplay {
    switch (role) {
      case StaffRole.host:
        return 'Host/Reservation Staff';
      case StaffRole.waiter:
        return 'Waiter';
      case StaffRole.kitchen:
        return 'Kitchen Staff';
      case StaffRole.manager:
        return 'Manager';
    }
  }
}