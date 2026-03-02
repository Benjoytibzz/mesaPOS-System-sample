class OrderModel {
  final String orderId;
  final int tableNumber;
  final int itemsCount;
  final double totalAmount;
  final String staffName;
  final String time;
  final String status; // 'PAID' or 'PENDING'

  OrderModel({
    required this.orderId,
    required this.tableNumber,
    required this.itemsCount,
    required this.totalAmount,
    required this.staffName,
    required this.time,
    required this.status,
  });
}