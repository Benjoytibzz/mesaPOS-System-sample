import 'package:flutter/material.dart';
import '../../../core/platform/routes.dart';

class AdminSidebar extends StatelessWidget {
  final String activeRoute;

  const AdminSidebar({
    super.key,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'ADMIN PANEL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          _item(
            context, 
            Icons.dashboard, 
            'Dashboard',
            AppRoutes.adminDashboard),

          _item(
            context,
            Icons.restaurant_menu,
            'Menu Management',
            AppRoutes.menuManagement,
          ),

          _item(
            context, 
            Icons.people, 
            'Staff Management', 
            AppRoutes.staffManagement),

          _item(
            context, 
            Icons.bar_chart, 
            'Reports', 
            AppRoutes.reportsManagement),

          _item(
            context, 
            Icons.settings, 
            'Settings', 
            null),

          const Spacer(),
          const Divider(color: Colors.white24),

          _logout(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    String? route,
  ) {
    final isActive = route != null && route == activeRoute;

    return InkWell(
      onTap: route == null
          ? null
          : () => Navigator.pushReplacementNamed(context, route),
      child: Container(
        color: isActive ? Colors.blueGrey : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: const [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 14),
            Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

