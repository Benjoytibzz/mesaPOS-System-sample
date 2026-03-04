import 'package:flutter/material.dart';

enum OrderStatus { pending, preparing, ready, paid, cancelled }
enum PaymentMethod { cash, card, gcash, maya }

class OrderModel {
  final String id;
  final String orderId;
  final int tableNumber;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final PaymentMethod? paymentMethod;
  final OrderStatus status;
  final String? staffId;
  final String? staffName;
  final DateTime time;
  final double? amountReceived;
  final double? change;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.tableNumber,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.paymentMethod,
    required this.status,
    this.staffId,
    this.staffName,
    required this.time,
    this.amountReceived,
    this.change,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List? ?? [])
        .map((item) => OrderItem.fromJson(item))
        .toList();

    return OrderModel(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      tableNumber: json['tableNumber'] ?? 0,
      items: itemsList,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      paymentMethod: _parsePaymentMethod(json['paymentMethod']),
      status: _parseStatus(json['status']),
      staffId: json['staffId'],
      staffName: json['staffName'],
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
      amountReceived: json['amountReceived']?.toDouble(),
      change: json['change']?.toDouble(),
    );
  }

  static PaymentMethod? _parsePaymentMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'card':
        return PaymentMethod.card;
      case 'gcash':
        return PaymentMethod.gcash;
      case 'maya':
        return PaymentMethod.maya;
      default:
        return null;
    }
  }

  static OrderStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'paid':
        return OrderStatus.paid;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'tableNumber': tableNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'paymentMethod': paymentMethod?.toString().split('.').last,
      'status': status.toString().split('.').last,
      'staffId': staffId,
      'staffName': staffName,
      'time': time.toIso8601String(),
      'amountReceived': amountReceived,
      'change': change,
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFA726);
      case OrderStatus.preparing:
        return const Color(0xFF2196F3);
      case OrderStatus.ready:
        return const Color(0xFF4CAF50);
      case OrderStatus.paid:
        return const Color(0xFF9C27B0);
      case OrderStatus.cancelled:
        return const Color(0xFFF44336);
    }
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? notes;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'notes': notes,
    };
  }

  double get total => price * quantity;
}