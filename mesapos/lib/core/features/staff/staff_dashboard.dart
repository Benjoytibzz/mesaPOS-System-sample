import 'package:flutter/material.dart';
import '../../services/logout_service.dart';
import '../../../core/platform/routes.dart';
import '../widgets/staff_drawer.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  // NOTE: If using GetX or Riverpod, inject your controller here instead.
  final Color _bgColor = const Color(0xFFEAF4F8); // Light blue background
  final Color _cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔒 disables back button
      child: Scaffold(
        backgroundColor: _bgColor,
        drawer: const StaffDrawer(
          activeRoute: AppRoutes.staffDashboard,
        ),
        // AppBar completely removed
        body: SafeArea( // Added SafeArea since we removed the AppBar
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0), // Updated padding to match Booking Screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSummarySection(),
                const SizedBox(height: 24),
                _buildSchedulesSection(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildRecentOrders(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hamburger Menu wrapped in Builder to get the correct Scaffold context
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF145D7A)), // Updated color
            padding: EdgeInsets.zero,
            alignment: Alignment.topLeft,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        const SizedBox(width: 8),
        // Title and Welcome Message
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Staff Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF145D7A), // Updated color
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Welcome back, User! Here's what's happening today.",
                style: TextStyle(color: Color(0xFF145D7A)), // Updated color
              ),
              const SizedBox(height: 8),
              Divider(color: const Color(0xFF145D7A).withOpacity(0.2), thickness: 0.5),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Profile Widget
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 22, // Increased to 22
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10), // Adjusted spacing
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Staff Name',
                  style: TextStyle(fontWeight: FontWeight.w600), // Updated style
                ),
                Text(
                  'Staff Member',
                  style: TextStyle(color: Colors.blueGrey), // Updated style
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Wraps the stat cards in a white container per the new picture
  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Bookings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            children: [
              // Top Row: 3 Items
              Row(
                children: [
                  Expanded(
                    child: _statCard('Upcoming Appointments', '0',
                        'Total Count', Icons.calendar_today, Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard('Completed Today', '0',
                        'Amount Collected', Icons.check_circle, Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard("Today's Booking", '0',
                        'Total checked-in', Icons.event_available, Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom Row: 1 Item taking up 1/3 space (aligned left)
              Row(
                children: [
                  Expanded(
                    child: _statCard('Pending Bookings', '0',
                        'Requests pending', Icons.access_time, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()), // Empty space for layout
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()), // Empty space for layout
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Restyled to match the picture (inner cards have light blue BG)
  Widget _statCard(String title, String count, String subtitle, IconData icon,
      Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: _bgColor, // Uses the light blue background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade50, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(count,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulesSection() {
    return Row(
      children: [
        Expanded(
            child: _emptyScheduleCard("Today's Bookings",
                "Monday, February 16, 2026", "No bookings for today")),
        const SizedBox(width: 16),
        Expanded(
            child: _emptyScheduleCard(
                "Upcoming Appointments", "", "No upcoming appointments")),
      ],
    );
  }

  Widget _emptyScheduleCard(String title, String subtitle, String emptyMessage) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontSize: 13)),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  // Changed to Bold and Blue
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Center(
              child: Text(emptyMessage,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // slightly darker blue for contrast
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Update Booking'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue.shade200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('View Schedule',
                      style: TextStyle(color: Colors.blue.shade700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Orders',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _orderItem('ORD-2026-0012', 'PAID'),
          _orderItem('ORD-2026-0011', 'PAID'),
          _orderItem('ORD-2026-0010', 'PENDING'),
        ],
      ),
    );
  }

  Widget _orderItem(String orderId, String status) {
    bool isPaid = status == 'PAID';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderId,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPaid
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Table: 5 | Items: 3 | Total: \$45.50',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text('Staff: John Smith | Time: 10:30 AM',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ],
      ),
    );
  }
}