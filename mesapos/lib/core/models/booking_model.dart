class Booking {
  final String bookingId;
  final String customerName;
  final String service;
  final DateTime dateTime;
  final String status;
  final String notes;

  /// NEW FIELDS (POS / ORDER INFO)
  final int itemsCount;
  final double totalAmount;

  Booking({
    required this.bookingId,
    required this.customerName,
    required this.service,
    required this.dateTime,
    required this.status,
    required this.notes,
    required this.itemsCount,
    required this.totalAmount,
  });

  // ================================
  // COPY WITH (REQUIRED FOR EDIT)
  // ================================
  Booking copyWith({
    String? bookingId,
    String? customerName,
    String? service,
    DateTime? dateTime,
    String? status,
    String? notes,
    int? itemsCount,
    double? totalAmount,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      customerName: customerName ?? this.customerName,
      service: service ?? this.service,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      itemsCount: itemsCount ?? this.itemsCount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  // ================================
  // ✅ TO MAP (DB / API)
  // ================================
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'customerName': customerName,
      'service': service,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'notes': notes,
      'itemsCount': itemsCount,
      'totalAmount': totalAmount,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  // ================================
  // ✅ FROM MAP (SAFE PARSING)
  // ================================
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId']?.toString() ?? '',
      customerName: map['customerName'] ?? '',
      service: map['service'] ?? '',
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'Pending',
      notes: map['notes'] ?? '',

      /// ⭐ SAFE DEFAULTS (IMPORTANT)
      itemsCount: (map['itemsCount'] ?? 0) is int
          ? map['itemsCount']
          : int.tryParse(map['itemsCount'].toString()) ?? 0,

      totalAmount: (map['totalAmount'] ?? 0.0) is double
          ? map['totalAmount']
          : double.tryParse(map['totalAmount'].toString()) ?? 0.0,
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) =>
      Booking.fromMap(json);

  // ================================
  // ✅ DEBUG PRINTING
  // ================================
  @override
  String toString() {
    return 'Booking(id: $bookingId, customer: $customerName, '
        'service: $service, items: $itemsCount, total: $totalAmount, '
        'status: $status)';
  }

  // ================================
  // ✅ OBJECT COMPARISON
  // ================================
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking &&
          runtimeType == other.runtimeType &&
          bookingId == other.bookingId;

  @override
  int get hashCode => bookingId.hashCode;
}
