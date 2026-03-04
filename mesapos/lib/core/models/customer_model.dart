class CustomerModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? lastBooking;
  final String? lastBookingTable;
  final String? notes;
  final DateTime? customerSince;
  final int totalBookings;
  final double totalSpent;

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.lastBooking,
    this.lastBookingTable,
    this.notes,
    this.customerSince,
    this.totalBookings = 0,
    this.totalSpent = 0,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      lastBooking: json['lastBooking'],
      lastBookingTable: json['lastBookingTable'],
      notes: json['notes'],
      customerSince: json['customerSince'] != null 
          ? DateTime.parse(json['customerSince']) 
          : null,
      totalBookings: json['totalBookings'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'lastBooking': lastBooking,
      'lastBookingTable': lastBookingTable,
      'notes': notes,
      'customerSince': customerSince?.toIso8601String(),
      'totalBookings': totalBookings,
      'totalSpent': totalSpent,
    };
  }

  String get lastBookingDisplay {
    if (lastBooking == null) return 'No bookings yet';
    return '$lastBooking (${lastBookingTable ?? 'No table'})';
  }
}