import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/staff_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  StaffModel? _currentUser;
  String? _token;

  StaffModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock login - in real app, this would call the API
      if (email == 'staff@example.com' && password == 'password') {
        _currentUser = StaffModel(
          id: 'staff001',
          fullName: 'Staff Name',
          email: email,
          phone: '09951028835',
          role: StaffRole.host,
          joinDate: DateTime(2022, 3, 15),
          assignedBookings: 4,
          pendingBookings: 4,
          confirmedBookings: 4,
          completedBookings: 4,
        );
        _token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';

        // Save to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(_currentUser!.toJson()));
        await prefs.setString('token', _token!);

        return true;
      }
      return false;
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }

  Future<bool> checkSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('user') && prefs.containsKey('token')) {
        final userJson = json.decode(prefs.getString('user')!);
        _currentUser = StaffModel.fromJson(userJson);
        _token = prefs.getString('token');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation - in real app, verify current password with API
      if (currentPassword == 'password') {
        return true;
      }
      return false;
    } catch (e) {
      throw AuthException('Password update failed: $e');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'Auth Error: $message';
}