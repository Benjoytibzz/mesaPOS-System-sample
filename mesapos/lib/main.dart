import 'package:flutter/material.dart';
import 'core/database/database_provider.dart';
import 'core/platform/routes.dart';
import 'features/auth/login_screen.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/admin/menu_management.dart';
import 'features/admin/staff_management.dart';
import 'features/admin/reports_management.dart';
import 'features/staff/staff_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initDatabase();
  } catch (e) {
    debugPrint('DB init failed: $e');
  }

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
        AppRoutes.staffDashboard: (_) => const StaffDashboard(),
      },
    );
  }
}
