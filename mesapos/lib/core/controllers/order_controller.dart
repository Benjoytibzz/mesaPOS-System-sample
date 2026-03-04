import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/menu_item_model.dart';
import '../repositories/order_repository.dart';
import '../repositories/menu_repository.dart';
import '../services/auth_service.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository _orderRepository;
  final MenuRepository _menuRepository;
  final AuthService _authService;

  List<OrderModel> _orders = [];
  List<OrderModel> _filteredOrders = [];
  List<MenuItemModel> _menuItems = [];
  List<OrderItem> _currentCart = [];
  Map<String, dynamic> _stats = {};
  OrderModel? _selectedOrder;
  int? _selectedTable;
  MenuCategory _selectedCategory = MenuCategory.all;
  String _searchQuery = '';
  OrderStatus? _selectedStatus;
  bool _isLoading = false;
  String? _error;

  OrderController({
    required OrderRepository orderRepository,
    required MenuRepository menuRepository,
    required AuthService authService,
  })  : _orderRepository = orderRepository,
        _menuRepository = menuRepository,
        _authService = authService;

  // Getters
  List<OrderModel> get orders => _filteredOrders;
  List<MenuItemModel> get menuItems => _menuItems;
  List<OrderItem> get currentCart => _currentCart;
  Map<String, dynamic> get stats => _stats;
  OrderModel? get selectedOrder => _selectedOrder;
  int? get selectedTable => _selectedTable;
  MenuCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Cart calculations
  double get cartSubtotal {
    return _currentCart.fold(0.0, (sum, item) => sum + item.total);
  }

  double get cartTax {
    return cartSubtotal * 0.10; // 10% tax
  }

  double get cartTotal {
    return cartSubtotal + cartTax;
  }

  int get cartItemCount {
    return _currentCart.fold(0, (sum, item) => sum + item.quantity);
  }

  // Load initial data
  Future<void> loadInitialData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        loadOrders(),
        loadMenuItems(),
        loadStats(),
      ]);
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load orders
  Future<void> loadOrders() async {
    try {
      _orders = await _orderRepository.getOrders();
      _applyFilters();
    } catch (e) {
      rethrow;
    }
  }

  // Load menu items
  Future<void> loadMenuItems() async {
    try {
      _menuItems = await _menuRepository.getMenuItems();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Load stats
  Future<void> loadStats() async {
    try {
      _stats = await _orderRepository.getOrderStats();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Filter by category
  void filterByCategory(MenuCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search menu items
  void searchMenuItems(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Get filtered menu items
  List<MenuItemModel> getFilteredMenuItems() {
    var items = _menuItems;

    // Filter by category
    if (_selectedCategory != MenuCategory.all) {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      items = items.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }).toList();
    }

    return items;
  }

  // Select table
  void selectTable(int? tableNumber) {
    _selectedTable = tableNumber;
    notifyListeners();
  }

  // Add to cart
  void addToCart(MenuItemModel item) {
    final existingIndex = _currentCart.indexWhere(
      (cartItem) => cartItem.menuItemId == item.id,
    );

    if (existingIndex >= 0) {
      // Check max quantity if specified
      if (item.maxQuantity != null && 
          _currentCart[existingIndex].quantity >= item.maxQuantity!) {
        _error = 'Maximum quantity reached for this item';
        notifyListeners();
        Future.delayed(const Duration(seconds: 2), () {
          _error = null;
          notifyListeners();
        });
        return;
      }

      final updatedItem = _currentCart[existingIndex].copyWith(
        quantity: _currentCart[existingIndex].quantity + 1,
      );
      _currentCart[existingIndex] = updatedItem;
    } else {
      _currentCart.add(
        OrderItem(
          menuItemId: item.id,
          name: item.name,
          price: item.price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  // Remove from cart
  void removeFromCart(String menuItemId) {
    _currentCart.removeWhere((item) => item.menuItemId == menuItemId);
    notifyListeners();
  }

  // Update quantity
  void updateQuantity(String menuItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(menuItemId);
      return;
    }

    final index = _currentCart.indexWhere((item) => item.menuItemId == menuItemId);
    if (index >= 0) {
      final updatedItem = _currentCart[index].copyWith(quantity: newQuantity);
      _currentCart[index] = updatedItem;
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _currentCart.clear();
    notifyListeners();
  }

  // Create order
  Future<bool> createOrder() async {
    if (_selectedTable == null) {
      _error = 'Please select a table';
      notifyListeners();
      Future.delayed(const Duration(seconds: 2), () {
        _error = null;
        notifyListeners();
      });
      return false;
    }

    if (_currentCart.isEmpty) {
      _error = 'Cart is empty';
      notifyListeners();
      Future.delayed(const Duration(seconds: 2), () {
        _error = null;
        notifyListeners();
      });
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final staff = _authService.currentUser;
      final order = OrderModel(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        orderId: 'ORD-${DateTime.now().year}-${DateTime.now().millisecond.toString().padLeft(4, '0')}',
        tableNumber: _selectedTable!,
        items: List.from(_currentCart),
        subtotal: cartSubtotal,
        tax: cartTax,
        total: cartTotal,
        status: OrderStatus.pending,
        staffId: staff?.id,
        staffName: staff?.fullName,
        time: DateTime.now(),
      );

      await _orderRepository.createOrder(order);
      
      // Clear cart and refresh data
      clearCart();
      _selectedTable = null;
      await loadOrders();
      await loadStats();
      
      return true;
    } catch (e) {
      _error = 'Failed to create order: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _orderRepository.updateOrderStatus(orderId, newStatus);
      await loadOrders();
      await loadStats();
      
      return true;
    } catch (e) {
      _error = 'Failed to update order status: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Process payment
  Future<bool> processPayment(
    String orderId,
    PaymentMethod method,
    double amountReceived,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _orderRepository.processPayment(orderId, method, amountReceived);
      await loadOrders();
      await loadStats();
      
      return true;
    } catch (e) {
      _error = 'Failed to process payment: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select order
  void selectOrder(OrderModel order) {
    _selectedOrder = order;
    notifyListeners();
  }

  // Clear selected order
  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }

  // Filter orders by status
  void filterOrdersByStatus(OrderStatus? status) {
    _selectedStatus = status;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredOrders = List.from(_orders);

    if (_selectedStatus != null) {
      _filteredOrders = _filteredOrders
          .where((order) => order.status == _selectedStatus)
          .toList();
    }

    notifyListeners();
  }

  // Get orders for a specific table
  List<OrderModel> getOrdersForTable(int tableNumber) {
    return _orders.where((order) => order.tableNumber == tableNumber).toList();
  }
}