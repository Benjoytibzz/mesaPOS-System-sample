import 'package:flutter/material.dart';

enum BookingStatus { pending, confirmed, completed, cancelled, rejected }

class BookingModel {
  final String id;
  final String bookingId;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String service;
  final DateTime dateTime;
  final int items;
  final double total;
  final BookingStatus status;
  final String? assignedStaffId;
  final String? assignedStaffName;
  final String? tableNumber;
  final String? specialRequests;
  final String? notes;
  final DateTime createdOn;
  final DateTime lastUpdated;
  final DateTime scheduledFor;
  final String? customerSince;

  BookingModel({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerEmail,
    required this.service,
    required this.dateTime,
    required this.items,
    required this.total,
    required this.status,
    this.assignedStaffId,
    this.assignedStaffName,
    this.tableNumber,
    this.specialRequests,
    this.notes,
    required this.createdOn,
    required this.lastUpdated,
    required this.scheduledFor,
    this.customerSince,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      service: json['service'] ?? 'Table Service',
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      items: json['items'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      status: _parseStatus(json['status']),
      assignedStaffId: json['assignedStaffId'],
      assignedStaffName: json['assignedStaffName'],
      tableNumber: json['tableNumber'],
      specialRequests: json['specialRequests'],
      notes: json['notes'],
      createdOn: DateTime.parse(json['createdOn'] ?? DateTime.now().toIso8601String()),
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      scheduledFor: DateTime.parse(json['scheduledFor'] ?? DateTime.now().toIso8601String()),
      customerSince: json['customerSince'],
    );
  }

  static BookingStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'rejected':
        return BookingStatus.rejected;
      default:
        return BookingStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'service': service,
      'dateTime': dateTime.toIso8601String(),
      'items': items,
      'total': total,
      'status': status.toString().split('.').last,
      'assignedStaffId': assignedStaffId,
      'assignedStaffName': assignedStaffName,
      'tableNumber': tableNumber,
      'specialRequests': specialRequests,
      'notes': notes,
      'createdOn': createdOn.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'scheduledFor': scheduledFor.toIso8601String(),
      'customerSince': customerSince,
    };
  }

  BookingModel copyWith({
    String? id,
    String? bookingId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? service,
    DateTime? dateTime,
    int? items,
    double? total,
    BookingStatus? status,
    String? assignedStaffId,
    String? assignedStaffName,
    String? tableNumber,
    String? specialRequests,
    String? notes,
    DateTime? createdOn,
    DateTime? lastUpdated,
    DateTime? scheduledFor,
    String? customerSince,
  }) {
    return BookingModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      service: service ?? this.service,
      dateTime: dateTime ?? this.dateTime,
      items: items ?? this.items,
      total: total ?? this.total,
      status: status ?? this.status,
      assignedStaffId: assignedStaffId ?? this.assignedStaffId,
      assignedStaffName: assignedStaffName ?? this.assignedStaffName,
      tableNumber: tableNumber ?? this.tableNumber,
      specialRequests: specialRequests ?? this.specialRequests,
      notes: notes ?? this.notes,
      createdOn: createdOn ?? this.createdOn,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      customerSince: customerSince ?? this.customerSince,
    );
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }

  Color get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return const Color(0xFFFFA726); // Orange
      case BookingStatus.confirmed:
        return const Color(0xFF4CAF50); // Green
      case BookingStatus.completed:
        return const Color(0xFF2196F3); // Blue
      case BookingStatus.cancelled:
        return const Color(0xFFF44336); // Red
      case BookingStatus.rejected:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}