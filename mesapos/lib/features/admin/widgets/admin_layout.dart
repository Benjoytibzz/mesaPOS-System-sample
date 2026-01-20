import 'package:flutter/material.dart';
import 'admin_sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String activeRoute;

  const AdminLayout({
    super.key,
    required this.child,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(activeRoute: activeRoute),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
