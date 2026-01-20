import 'package:flutter/material.dart';
import '../../core/platform/routes.dart';
import 'widgets/admin_layout.dart';

class ReportsManagementScreen extends StatelessWidget {
  const ReportsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      activeRoute: AppRoutes.reportsManagement,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Reports',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('View and analyze sales and performance reports'),
          ],
        ),
      ),
    );
  }
}
