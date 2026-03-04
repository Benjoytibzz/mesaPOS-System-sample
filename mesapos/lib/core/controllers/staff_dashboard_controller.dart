// staff_dashboard_controller.dart
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/dashboard_summary_model.dart';

class StaffDashboardController extends ChangeNotifier {
  bool isLoading = true;
  
  DashboardSummary? summary;
  List<OrderModel> recentOrders = [];
  // Add lists for today's bookings and upcoming appointments when ready

  StaffDashboardController() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual Repository API calls
      // e.g., summary = await repository.getDashboardSummary();
      
      // Mock Data based on your picture
      summary = DashboardSummary(
        upcomingAppointments: 0,
        completedToday: 0,
        todayBookings: 0,
        pendingBookings: 0,
      );

      recentOrders = [
        OrderModel(
          id: '1',
          orderId: 'ORD-2026-0012',
          tableNumber: 5,
          staffName: 'John Smith',
          time: DateTime.now(),
          status: OrderStatus.paid,
          items: [],
          subtotal: 40.0,
          tax: 5.5,
          total: 45.50,
        ),
        OrderModel(
          id: '2',
          orderId: 'ORD-2026-0011',
          tableNumber: 5,
          staffName: 'John Smith',
          time: DateTime.now(),
          status: OrderStatus.paid,
          items: [],
          subtotal: 40.0,
          tax: 5.5,
          total: 45.50,
        ),
        OrderModel(
          id: '3',
          orderId: 'ORD-2026-0010',
          tableNumber: 5,
          staffName: 'John Smith',
          time: DateTime.now(),
          status: OrderStatus.pending,
          items: [],
          subtotal: 40.0,
          tax: 5.5,
          total: 45.50,
        ),
      ];
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}