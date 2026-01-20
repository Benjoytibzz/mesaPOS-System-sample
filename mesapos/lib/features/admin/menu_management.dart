import 'package:flutter/material.dart';
import '../../core/platform/routes.dart';
import 'widgets/admin_layout.dart';

class MenuManagementScreen extends StatelessWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      activeRoute: AppRoutes.menuManagement,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Menu Management',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Create, update, and manage menu items'),
          ],
        ),
      ),
    );
  }
}
