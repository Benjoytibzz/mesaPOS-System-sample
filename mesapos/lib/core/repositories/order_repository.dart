import '../models/order_model.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';

class OrderRepository {
  final DatabaseService _databaseService;
  final ApiService _apiService;

  OrderRepository({
    required DatabaseService databaseService,
    required ApiService apiService,
  })  : _databaseService = databaseService,
        _apiService = apiService;

  // Get all orders
  Future<List<OrderModel>> getOrders() async {
    return await _databaseService.getOrders();
  }

  // Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(OrderStatus status) async {
    final allOrders = await _databaseService.getOrders();
    return allOrders.where((o) => o.status == status).toList();
  }

  // Get orders by table
  Future<List<OrderModel>> getOrdersByTable(int tableNumber) async {
    final allOrders = await _databaseService.getOrders();
    return allOrders.where((o) => o.tableNumber == tableNumber).toList();
  }

  // Get active orders (not paid or cancelled)
  Future<List<OrderModel>> getActiveOrders() async {
    final allOrders = await _databaseService.getOrders();
    return allOrders.where((o) => 
        o.status != OrderStatus.paid && 
        o.status != OrderStatus.cancelled
    ).toList();
  }

  // Create new order
  Future<void> createOrder(OrderModel order) async {
    await _databaseService.addOrder(order);
    
    // Sync with API
    try {
      await _apiService.post('orders', data: order.toJson());
    } catch (e) {
      // Handle sync error
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final orders = await _databaseService.getOrders();
    final index = orders.indexWhere((o) => o.id == orderId);
    
    if (index != -1) {
      final updatedOrder = orders[index].copyWith(
        status: newStatus,
      );
      orders[index] = updatedOrder;
      await _databaseService.saveOrders(orders);
      
      try {
        await _apiService.patch('orders/$orderId', data: {
          'status': newStatus.toString().split('.').last,
        });
      } catch (e) {
        // Handle sync error
      }
    }
  }

  // Process payment
  Future<void> processPayment(
    String orderId, 
    PaymentMethod method, 
    double amountReceived
  ) async {
    final orders = await _databaseService.getOrders();
    final index = orders.indexWhere((o) => o.id == orderId);
    
    if (index != -1) {
      final order = orders[index];
      final change = amountReceived - order.total;
      
      final updatedOrder = order.copyWith(
        paymentMethod: method,
        status: OrderStatus.paid,
        amountReceived: amountReceived,
        change: change,
      );
      
      orders[index] = updatedOrder;
      await _databaseService.saveOrders(orders);
      
      try {
        await _apiService.post('orders/$orderId/payment', data: {
          'paymentMethod': method.toString().split('.').last,
          'amountReceived': amountReceived,
          'change': change,
        });
      } catch (e) {
        // Handle sync error
      }
    }
  }

  // Get order statistics
  Future<Map<String, dynamic>> getOrderStats() async {
    final activeOrders = await getActiveOrders();
    final allOrders = await _databaseService.getOrders();
    
    final today = DateTime.now();
    final todayOrders = allOrders.where((o) =>
        o.time.year == today.year &&
        o.time.month == today.month &&
        o.time.day == today.day
    ).toList();
    
    final todayRevenue = todayOrders
        .where((o) => o.status == OrderStatus.paid)
        .fold(0.0, (sum, o) => sum + o.total);
    
    final pendingPayment = allOrders
        .where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.preparing)
        .length;
    
    final tablesOccupied = activeOrders
        .map((o) => o.tableNumber)
        .toSet()
        .length;
    
    return {
      'activeOrders': activeOrders.length,
      'todayRevenue': todayRevenue,
      'pendingPayment': pendingPayment,
      'tablesOccupied': tablesOccupied,
    };
  }

  // Get recent orders
  Future<List<OrderModel>> getRecentOrders({int limit = 3}) async {
    final allOrders = await _databaseService.getOrders();
    allOrders.sort((a, b) => b.time.compareTo(a.time));
    return allOrders.take(limit).toList();
  }
}