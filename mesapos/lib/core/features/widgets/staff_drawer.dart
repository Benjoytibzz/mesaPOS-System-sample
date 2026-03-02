import 'package:flutter/material.dart';
import '../../platform/routes.dart';

class StaffDrawer extends StatelessWidget {
  final String activeRoute;

  const StaffDrawer({
    super.key,
    required this.activeRoute,
  });

  // ✅ UPDATED BACKGROUND COLOR
  static const Color _bgColor = Color(0xFF09637E);

  static const Color _activeColor = Color(0xFF0C4E58);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: _bgColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // =========================
            // LOGO / HEADER
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "POS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "mesaPOS",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // MENU ITEMS
            // =========================
            _item(
              context,
              Icons.dashboard_outlined,
              "Dashboard",
              AppRoutes.staffDashboard,
            ),

            _item(
              context,
              Icons.book_online_outlined,
              "Bookings",
              AppRoutes.bookingManagement,
            ),

            _item(
              context,
              Icons.calendar_today_outlined,
              "Schedule",
              null,
            ),

            _item(
              context,
              Icons.receipt_long_outlined,
              "Ordering",
              null,
            ),

            _item(
              context,
              Icons.people_outline,
              "Customer",
              null,
            ),

            _item(
              context,
              Icons.logout,
              "Logout",
              AppRoutes.login,
              isLogout: true,
            ),

            // ✅ INCREASED SPACING BEFORE PROFILE SECTION
            const SizedBox(height: 60),

            // =========================
            // PROFILE SECTION
            // =========================
            const Divider(color: Colors.white24),

            ListTile(
              leading: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: _bgColor),
              ),
              title: const Text(
                "Profile and Account",
                style: TextStyle(color: Colors.white),
              ),
              onTap: null,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // =====================================
  // DRAWER ITEM
  // =====================================
  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String? route, {
    bool isLogout = false,
  }) {
    final bool isActive = route != null && route == activeRoute;

    return Container(
      color: isActive ? _activeColor : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: route == null ? Colors.white38 : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: route == null ? Colors.white38 : Colors.white,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: route == null
            ? null
            : () => Navigator.pushReplacementNamed(context, route),
      ),
    );
  }
}