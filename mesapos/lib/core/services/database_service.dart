import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';
import '../models/customer_model.dart';
import '../models/order_model.dart';
import '../models/menu_item_model.dart';
import '../models/schedule_model.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _bookingsKey = 'bookings';
  static const String _customersKey = 'customers';
  static const String _ordersKey = 'orders';
  static const String _menuItemsKey = 'menu_items';
  static const String _scheduleKey = 'schedule';

  // Initialize with mock data
  Future<void> initializeMockData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (!prefs.containsKey(_bookingsKey)) {
      await _saveMockBookings(prefs);
    }
    if (!prefs.containsKey(_customersKey)) {
      await _saveMockCustomers(prefs);
    }
    if (!prefs.containsKey(_menuItemsKey)) {
      await _saveMockMenuItems(prefs);
    }
    if (!prefs.containsKey(_scheduleKey)) {
      await _saveMockSchedule(prefs);
    }
  }

  // Bookings
  Future<List<BookingModel>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_bookingsKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => BookingModel.fromJson(json)).toList();
  }

  Future<void> saveBookings(List<BookingModel> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = bookings.map((b) => b.toJson()).toList();
    await prefs.setString(_bookingsKey, json.encode(jsonList));
  }

  Future<BookingModel?> getBookingById(String id) async {
    final bookings = await getBookings();
    try {
      return bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateBooking(BookingModel booking) async {
    final bookings = await getBookings();
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      bookings[index] = booking;
      await saveBookings(bookings);
    }
  }

  // Customers
  Future<List<CustomerModel>> getCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_customersKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => CustomerModel.fromJson(json)).toList();
  }

  // Orders
  Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_ordersKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((o) => o.toJson()).toList();
    await prefs.setString(_ordersKey, json.encode(jsonList));
  }

  Future<void> addOrder(OrderModel order) async {
    final orders = await getOrders();
    orders.add(order);
    await saveOrders(orders);
  }

  Future<void> updateOrder(OrderModel order) async {
    final orders = await getOrders();
    final index = orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      orders[index] = order;
      await saveOrders(orders);
    }
  }

  // Menu Items
  Future<List<MenuItemModel>> getMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_menuItemsKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => MenuItemModel.fromJson(json)).toList();
  }

  // Schedule
  Future<List<ScheduleModel>> getSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_scheduleKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
  }

  // Mock Data Initialization
  Future<void> _saveMockBookings(SharedPreferences prefs) async {
    final now = DateTime.now();
    final bookings = [
      BookingModel(
        id: '1',
        bookingId: '#101',
        customerId: 'cust1',
        customerName: 'Marc Anthony Dela Pena',
        customerPhone: '09951028837',
        customerEmail: 'marcanthony@email.com',
        service: 'Table Service',
        dateTime: DateTime(2026, 2, 14, 18, 30),
        items: 2,
        total: 239.98,
        status: BookingStatus.pending,
        assignedStaffId: 'staff001',
        assignedStaffName: 'Marilyn Batolbatol',
        tableNumber: '4',
        specialRequests: 'Prefers window seat, vegetarian. Allergic to nuts.',
        notes: '',
        createdOn: DateTime(2026, 2, 19, 15, 38),
        lastUpdated: DateTime(2026, 2, 20, 15, 38),
        scheduledFor: DateTime(2026, 2, 20, 18, 0),
        customerSince: 'January 15, 2023',
      ),
      BookingModel(
        id: '2',
        bookingId: '#102',
        customerId: 'cust2',
        customerName: 'Marc Anthony',
        customerPhone: '09951028837',
        customerEmail: 'marcanthony@email.com',
        service: 'Table Service',
        dateTime: DateTime(2026, 2, 14, 18, 30),
        items: 2,
        total: 239.98,
        status: BookingStatus.confirmed,
        assignedStaffId: 'staff001',
        assignedStaffName: 'Marilyn Batolbatol',
        tableNumber: '4',
        specialRequests: 'Prefers window seat',
        notes: '',
        createdOn: DateTime(2026, 2, 19, 15, 38),
        lastUpdated: DateTime(2026, 2, 20, 15, 38),
        scheduledFor: DateTime(2026, 2, 20, 18, 0),
      ),
      BookingModel(
        id: '3',
        bookingId: '#103',
        customerId: 'cust3',
        customerName: 'Marc Anthony',
        customerPhone: '09951028837',
        customerEmail: 'marcanthony@email.com',
        service: 'Table Service',
        dateTime: DateTime(2026, 2, 14, 18, 30),
        items: 2,
        total: 239.98,
        status: BookingStatus.completed,
        assignedStaffId: 'staff001',
        assignedStaffName: 'Marilyn Batolbatol',
        tableNumber: '4',
        specialRequests: '',
        notes: '',
        createdOn: DateTime(2026, 2, 19, 15, 38),
        lastUpdated: DateTime(2026, 2, 20, 15, 38),
        scheduledFor: DateTime(2026, 2, 20, 18, 0),
      ),
    ];
    await prefs.setString(_bookingsKey, json.encode(bookings.map((b) => b.toJson()).toList()));
  }

  Future<void> _saveMockCustomers(SharedPreferences prefs) async {
    final customers = [
      CustomerModel(
        id: 'cust1',
        fullName: 'Marc Anthony Dela Pena',
        email: 'marcanthony@email.com',
        phone: '+1 (555) 123-4567',
        lastBooking: '2023-10-10',
        lastBookingTable: 'Table 4',
        notes: 'Prefers window seat, vegetarian',
        customerSince: DateTime(2023, 1, 15),
        totalBookings: 12,
        totalSpent: 2450.50,
      ),
      CustomerModel(
        id: 'cust2',
        fullName: 'Benjo Tibalan',
        email: 'marcanthony@email.com',
        phone: '+1 (555) 123-4567',
        lastBooking: '2023-10-10',
        lastBookingTable: 'Table 4',
        notes: 'Prefers window seat, vegetarian',
        customerSince: DateTime(2023, 2, 20),
        totalBookings: 8,
        totalSpent: 1800.75,
      ),
      CustomerModel(
        id: 'cust3',
        fullName: 'Marilyn Batolbatol',
        email: 'marcanthony@email.com',
        phone: '+1 (555) 123-4567',
        lastBooking: '2023-10-10',
        lastBookingTable: 'Table 4',
        notes: 'Prefers window seat, vegetarian',
        customerSince: DateTime(2023, 3, 10),
        totalBookings: 5,
        totalSpent: 950.25,
      ),
    ];
    await prefs.setString(_customersKey, json.encode(customers.map((c) => c.toJson()).toList()));
  }

  Future<void> _saveMockMenuItems(SharedPreferences prefs) async {
    final menuItems = [
      MenuItemModel(
        id: 'menu1',
        name: 'Caesar Salad',
        description: 'Fresh romaine lettuce with caesar dressing',
        price: 698.00,
        category: MenuCategory.appetizers,
        isAvailable: true,
        isSpecial: true,
      ),
      MenuItemModel(
        id: 'menu2',
        name: 'Garlic Bread',
        description: 'Toasted bread with garlic butter',
        price: 698.00,
        category: MenuCategory.appetizers,
        isAvailable: true,
      ),
      MenuItemModel(
        id: 'menu3',
        name: 'Chicken Alfredo',
        description: 'Creamy pasta with grilled chicken',
        price: 850.00,
        category: MenuCategory.mainCourses,
        isAvailable: true,
        isSpecial: true,
      ),
      MenuItemModel(
        id: 'menu4',
        name: 'Grilled Salad',
        description: 'Grilled vegetable salad',
        price: 698.00,
        category: MenuCategory.appetizers,
        isAvailable: true,
      ),
    ];
    await prefs.setString(_menuItemsKey, json.encode(menuItems.map((m) => m.toJson()).toList()));
  }

  Future<void> _saveMockSchedule(SharedPreferences prefs) async {
    final now = DateTime.now();
    final schedule = <ScheduleModel>[];
    
    // Generate mock schedule for December 2026
    for (int day = 1; day <= 31; day++) {
      final date = DateTime(2026, 12, day);
      if (date.weekday == DateTime.sunday) {
        // Holiday on Sundays
        schedule.add(ScheduleModel(
          id: 'schedule$day',
          date: date,
          shiftType: ShiftType.holiday,
          notes: 'Day Off',
          isAvailable: false,
        ));
      } else {
        // Duty day on weekdays
        schedule.add(ScheduleModel(
          id: 'schedule$day',
          date: date,
          shiftType: ShiftType.duty,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
          isAvailable: true,
        ));
      }
    }
    
    await prefs.setString(_scheduleKey, json.encode(schedule.map((s) => s.toJson()).toList()));
  }
}