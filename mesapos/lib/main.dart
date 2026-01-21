import 'package:flutter/material.dart';
import 'core/platform/routes.dart';
import 'core/features/auth/login_screen.dart';
import 'core/features/admin/admin_dashboard.dart';
import 'core/features/menu_management/menu_management.dart';
import 'core/features/staff_management/staff_management.dart';
import 'core/features/reports_management/reports_management.dart';
import 'core/features/staff/staff_dashboard.dart';
import 'core/features/settings_management/settings_management.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const POSApp());
}


class POSApp extends StatelessWidget {
  const POSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) =>  LoginScreen(),
        AppRoutes.adminDashboard: (_) => const AdminDashboard(),
        AppRoutes.menuManagement: (_) => const MenuManagementScreen(),
        AppRoutes.staffManagement: (_) => const StaffManagementScreen(),
        AppRoutes.reportsManagement: (_) => const ReportsManagementScreen(),
        AppRoutes.settingsManagement: (_) => const SettingsManagementScreen(),
        AppRoutes.staffDashboard: (_) => const StaffDashboard(),
      },
    );
  }
}
