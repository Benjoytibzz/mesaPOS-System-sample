import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/order_controller.dart';
import '../../widgets/sidebar_menu.dart';
import '../bookings/bookings_view.dart';
import '../schedule/schedule_view.dart';
import '../ordering/ordering_view.dart';
import '../customers/customers_view.dart';
import '../profile/profile_view.dart';
import '../../utils/constants.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages = [
    const _DashboardHomeView(),
    const BookingsView(),
    const ScheduleView(),
    const OrderingView(),
    const CustomersView(),
    const ProfileView(),
  ];

  late final List<String> _pageTitles = [
    'Dashboard',
    'Bookings Management',
    'Schedule',
    'Ordering Management',
    'Customer Management',
    'Profile and Account Management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarMenu(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
      body: Row(
        children: [
          // Desktop sidebar (always visible)
          if (MediaQuery.of(context).size.width > AppConstants.mobileBreakpoint)
            SizedBox(
              width: 250,
              child: SidebarMenu(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // Mobile app bar with hamburger
                if (MediaQuery.of(context).size.width <= AppConstants.mobileBreakpoint)
                  AppBar(
                    title: Text(_pageTitles[_selectedIndex]),
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                
                // Page content
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHomeView extends StatelessWidget {
  const _DashboardHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingController = context.watch<BookingController>();
    final orderController = context.watch<OrderController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Text(
                'Welcome back, User!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Here's what's happening today.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Today's Bookings section
              Text(
                "Today's Bookings",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Stats cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    context,
                    'Upcoming Appointments',
                    bookingController.counts['pending']?.toString() ?? '0',
                    Icons.event_available,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    'Next 2 Hours',
                    '3',
                    Icons.access_time,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    'Completed Today',
                    '5',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _buildStatCard(
                    context,
                    'Pending Bookings',
                    bookingController.counts['pending']?.toString() ?? '0',
                    Icons.pending_actions,
                    Colors.purple,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      'Update Booking',
                      Icons.edit_calendar,
                      Colors.blue,
                      () {
                        // Navigate to bookings
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      'View Schedule',
                      Icons.calendar_today,
                      Colors.green,
                      () {
                        // Navigate to schedule
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Recent Orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Orders',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all orders
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Recent orders list
              FutureBuilder(
                future: orderController.loadInitialData(),
                builder: (context, snapshot) {
                  if (orderController.orders.isEmpty) {
                    return const Center(
                      child: Text('No recent orders'),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderController.orders.length > 3 
                        ? 3 : orderController.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderController.orders[index];
                      return _buildRecentOrderCard(context, order);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrderCard(BuildContext context, OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: order.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      color: order.statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.table_restaurant, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('Table: ${order.tableNumber}'),
                const SizedBox(width: 16),
                Icon(Icons.restaurant_menu, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('Items: ${order.itemCount}'),
                const SizedBox(width: 16),
                Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('Total: ₱${order.total.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('Staff: ${order.staffName ?? 'Unassigned'}'),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('Time: ${_formatTime(order.time)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour >= 12 ? 'PM' : 'AM'}';
  }
}