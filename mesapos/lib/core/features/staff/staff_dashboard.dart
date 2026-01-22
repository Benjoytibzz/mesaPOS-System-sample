import 'package:flutter/material.dart';
import '../widgets/staff_sidebar.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          PosSidebar(
            selectedIndex: _index,
            onSelect: (i) {
              if (i == -1) {
                // logout logic
                return;
              }
              setState(() => _index = i);
            },
          ),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_index) {
      case 0:
        return const Center(child: Text('Home'));
      case 1:
        return const Center(child: Text('Customers'));
      case 2:
        return const Center(child: Text('Tables'));
      case 3:
        return const Center(child: Text('Cashier'));
      case 4:
        return const Center(child: Text('Orders'));
      case 5:
        return const Center(child: Text('Reports'));
      case 6:
        return const Center(child: Text('Settings'));
      default:
        return const SizedBox();
    }
  }
}
