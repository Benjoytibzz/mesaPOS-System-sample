import 'package:flutter/material.dart';

class PosSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const PosSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  @override
Widget build(BuildContext context) {
  return Container(
    width: 88,
    color: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  _item(Icons.home_outlined, 'Home', 0),
                  _item(Icons.people_outline, 'Customers', 1),
                  _item(Icons.table_bar_outlined, 'Tables', 2),
                  _item(Icons.point_of_sale_outlined, 'Cashier', 3),
                  _item(Icons.receipt_long_outlined, 'Orders', 4),
                  _item(Icons.bar_chart_outlined, 'Reports', 5),
                  _item(Icons.settings_outlined, 'Settings', 6),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom-fixed logout
          _item(Icons.logout, 'Logout', -1),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

  Widget _item(IconData icon, String label, int index) {
    final active = selectedIndex == index;

    return InkWell(
      onTap: () => onSelect(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFE5D0) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: active ? Colors.deepOrange : Colors.grey),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? Colors.deepOrange : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
