import 'package:flutter/material.dart';
import '../../core/platform/routes.dart';

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
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // ───── Header ─────
            const Center(
              child: Text(
                'ADMIN PANEL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ───── Menu Items ─────
            _item(
              context,
              Icons.dashboard,
              'Dashboard',
              AppRoutes.adminDashboard,
            ),
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
              AppRoutes.staffManagement,
            ),
            _item(
              context,
              Icons.bar_chart,
              'Reports',
              AppRoutes.reportsManagement,
            ),
            _item(
              context,
              Icons.settings,
              'Settings',
              null,
            ),

            const Divider(color: Colors.white24),

            // ───── Logout ─────
            _logout(context),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    String? route,
  ) {
    final bool isActive = route != null && route == activeRoute;

    return InkWell(
      onTap: route == null
          ? null
          : () => Navigator.pushReplacementNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: isActive ? Colors.blueGrey.shade700 : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 15,
                ),
              ),
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
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
