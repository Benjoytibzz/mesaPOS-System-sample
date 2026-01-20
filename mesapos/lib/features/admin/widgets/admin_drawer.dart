import 'package:flutter/material.dart';
import '../../../core/platform/routes.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text(
              'Admin Panel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          _item(context, Icons.dashboard, 'Dashboard',
              AppRoutes.adminDashboard),

          _item(context, Icons.restaurant_menu, 'Menu Management', null),
          _item(context, Icons.people, 'Staff Management', null),
          _item(context, Icons.bar_chart, 'Reports', null),
          _item(context, Icons.settings, 'Settings', null),

          const Spacer(),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String? route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: route == null
          ? null
          : () => Navigator.pushReplacementNamed(context, route),
    );
  }
}
