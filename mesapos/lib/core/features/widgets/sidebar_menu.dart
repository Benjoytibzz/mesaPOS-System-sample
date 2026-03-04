import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarMenu({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final staff = authService.currentUser;

    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          // Staff info header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    staff?.fullName.substring(0, 1).toUpperCase() ?? 'S',
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  staff?.fullName ?? 'Staff Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  staff?.roleDisplay ?? 'Staff Member',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuItem(
                  context,
                  index: 0,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                ),
                _buildMenuItem(
                  context,
                  index: 1,
                  icon: Icons.book_online,
                  label: 'Bookings',
                ),
                _buildMenuItem(
                  context,
                  index: 2,
                  icon: Icons.calendar_today,
                  label: 'Schedule',
                ),
                _buildMenuItem(
                  context,
                  index: 3,
                  icon: Icons.shopping_cart,
                  label: 'Ordering',
                ),
                _buildMenuItem(
                  context,
                  index: 4,
                  icon: Icons.people,
                  label: 'Customer',
                ),
                const Divider(color: Colors.white24),
                _buildMenuItem(
                  context,
                  index: 5,
                  icon: Icons.person,
                  label: 'Profile',
                ),
                _buildMenuItem(
                  context,
                  index: 6,
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final isSelected = selectedIndex == index && onTap == null;

    return InkWell(
      onTap: onTap ?? () => onItemSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authService = context.read<AuthService>();
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}