import 'package:flutter/material.dart';
import '../../features/auth/login_screen.dart';

class LogoutService {
  static void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false, // 🔒 no back navigation
    );
  }
}
