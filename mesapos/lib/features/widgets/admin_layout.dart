import 'package:flutter/material.dart';
import '../../core/ui/responsive.dart';
import './admin_sidebar.dart';
import './admin_drawer.dart';

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
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      drawer: isMobile
          ? AdminDrawer(activeRoute: activeRoute)
          : null,

      body: SafeArea(
        child: Row(
          children: [
            // Sidebar only when it fits
            if (!isMobile)
              AdminSidebar(activeRoute: activeRoute),

            // Main content
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
