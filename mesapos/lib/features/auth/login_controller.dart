import '../../core/platform/routes.dart';
import 'package:flutter/material.dart';

class LoginController {
  static void login(BuildContext context, String role, String text) {
    if (role == 'admin') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.adminDashboard,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.staffDashboard,
      );
    }
  }
}
