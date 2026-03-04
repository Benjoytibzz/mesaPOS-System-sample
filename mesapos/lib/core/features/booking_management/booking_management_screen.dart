import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mesapos/core/controllers/booking_controller.dart';
import 'package:mesapos/core/models/booking_model.dart';

// ✅ ADD THESE IMPORTS (adjust path if needed)
import 'package:mesapos/core/features/widgets/staff_drawer.dart';
import 'package:mesapos/core/platform/routes.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  final BookingController controller = BookingController();

  List<Booking> bookings = [];
  bool isLoading = true;

  String selectedStatus = "All";
  String searchText = "";
  DateTime? selectedDate;

  int totalBookings = 0;
  int pendingCount = 0;
  int confirmedCount = 0;
  int completedCount = 0;

  final currency = NumberFormat.currency(symbol: "₱");

  @override
  void initState() {
    super.initState();
    controller.createSampleBooking();
    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([loadBookings(), loadDashboard()]);
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> loadBookings() async {
    bookings = await controller.getBookings();
  }

  Future<void> loadDashboard() async {
    totalBookings = await controller.countAll();
    pendingCount = await controller.countPending();
    confirmedCount = await controller.countConfirmed();
    completedCount = await controller.countCompleted();
  }

  // ================= ACTION LOGIC =================

  Future<void> _updateStatus(String id, String newStatus) async {
    await controller.updateBookingStatus(id, newStatus);
    await loadAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking status updated to $newStatus")),
      );
    }
  }

  void _confirmAction(String id, String status, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm $status"),
        content: Text("Are you sure you want to set this booking to $status?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(id, status);
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showViewDialog(Booking b) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Booking Details #${b.bookingId}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${b.customerName}"),
            Text("Service: ${b.service}"),
            Text("Total: ${currency.format(b.totalAmount)}"),
            const SizedBox(height: 10),
            const Text("Notes:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(b.notes.isEmpty ? "No notes added." : b.notes),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
      ),
    );
  }

  void _showNoteDialog(Booking b) {
    final noteController = TextEditingController(text: b.notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), 
        content: SizedBox(
          width: 450, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF145D7A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: const Text(
                  "Booking Notes",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(b.customerName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                    const SizedBox(height: 20),
                    const Text("Notes", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteController,
                      maxLines: 4,
                      readOnly: true,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD1DBE0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD1DBE0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3498DB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Ok", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusPicker(Booking b) {
    final statuses = ["Pending", "Confirmed", "Completed", "Cancelled", "Rejected"];
    String currentSelectedStatus = statuses.firstWhere(
      (s) => s.toLowerCase() == b.status.toLowerCase(),
      orElse: () => "Pending",
    );
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: const [
              Icon(Icons.sync, color: Colors.orange),
              SizedBox(width: 8),
              Text("Update Status", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 100, child: Text("Booking ID:", style: TextStyle(color: Colors.black87, fontSize: 13))),
                          Text(b.bookingId, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(width: 100, child: Text("Customer:", style: TextStyle(color: Colors.black87, fontSize: 13))),
                          Flexible(child: Text(b.customerName, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text("New Status", style: TextStyle(color: Colors.black87, fontSize: 13)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: currentSelectedStatus,
                      items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => currentSelectedStatus = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Internal Note (Optional)", style: TextStyle(color: Colors.black87, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Add note...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.withOpacity(0.15),
                foregroundColor: Colors.orange,
                elevation: 0,
                side: BorderSide(color: Colors.orange.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.sync, size: 16),
              label: const Text("Update Status", style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: () async {
                Navigator.pop(context);
                await _updateStatus(b.bookingId, currentSelectedStatus);
                if (noteController.text.trim().isNotEmpty) {
                  final newNoteStr = b.notes.isEmpty 
                      ? noteController.text.trim() 
                      : "${b.notes}\n${noteController.text.trim()}";
                  final updated = b.copyWith(notes: newNoteStr);
                  await controller.updateBooking(updated);
                  loadAll();
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI BUILDERS =================

  List<Booking> get filteredBookings {
    return bookings.where((b) {
      final matchStatus = selectedStatus == "All" ||
          b.status.toLowerCase() == selectedStatus.toLowerCase();
      final matchSearch = b.customerName.toLowerCase().contains(searchText.toLowerCase()) ||
          b.service.toLowerCase().contains(searchText.toLowerCase()) ||
          b.bookingId.contains(searchText);
      final matchDate = selectedDate == null ||
          (b.dateTime.year == selectedDate!.year &&
              b.dateTime.month == selectedDate!.month &&
              b.dateTime.day == selectedDate!.day);
      return matchStatus && matchSearch && matchDate;
    }).toList();
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed": return Colors.blue;
      case "completed": return Colors.green;
      case "canceled":
      case "cancelled":
      case "rejected": return Colors.red;
      default: return Colors.orange;
    }
  }

  String formatDate(DateTime d) => DateFormat("yyyy-MM-dd\n'at' h:mm a").format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F8),

      drawer: const StaffDrawer(
        activeRoute: AppRoutes.bookingManagement,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // ✅ TOP BAR WITH BURGER BUTTON (APPBAR REMOVED)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu, color: Color(0xFF145D7A)),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bookings Management",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF145D7A))),
                              SizedBox(height: 4),
                              Text("Manage your assigned bookings and reservations.",
                                style: TextStyle(color: Color(0xFF145D7A))),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          CircleAvatar(radius: 22, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Staff Name", style: TextStyle(fontWeight: FontWeight.w600)),
                              Text("Staff Member", style: TextStyle(color: Colors.blueGrey)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      dashboardCard("ASSIGNED TO ME", totalBookings, Icons.calendar_month, Colors.blue),
                      dashboardCard("PENDING", pendingCount, Icons.access_time_filled, Colors.orange),
                      dashboardCard("CONFIRMED", confirmedCount, Icons.check_circle, Colors.blue),
                      dashboardCard("COMPLETED", completedCount, Icons.check_box, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("My Assigned Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: ["All", "Pending", "Confirmed", "Completed", "Cancelled", "Rejected"]
                                  .map((status) => statusChip(status)).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Search", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search customer, service...",
                                      hintStyle: const TextStyle(fontSize: 14),
                                      prefixIcon: const Icon(Icons.search, size: 20),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                    ),
                                    onChanged: (v) => setState(() => searchText = v),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Date", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: selectedDate == null ? "mm/dd/yyyy" : DateFormat('MM/dd/yyyy').format(selectedDate!),
                                      hintStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                    ),
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) setState(() => selectedDate = picked);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        tableHeader(),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredBookings.length,
                          separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.black12),
                          itemBuilder: (_, i) => tableRow(filteredBookings[i]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget dashboardCard(String title, int value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$value", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statusChip(String label) {
    final active = selectedStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        selectedColor: const Color(0xFF145D7A),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(color: active ? Colors.white : Colors.black54, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
        onSelected: (_) => setState(() => selectedStatus = label),
      ),
    );
  }

  Widget tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFCBEAF4),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          tableCell("Booking\nID", 2, Alignment.centerLeft, true),
          tableCell("Customer", 3, Alignment.centerLeft, true),
          tableCell("Services", 3, Alignment.centerLeft, true),
          tableCell("Date and\nTime", 3, Alignment.centerLeft, true),
          tableCell("Items", 2, Alignment.centerLeft, true),
          tableCell("Total", 2, Alignment.centerLeft, true),
          tableCell("Status", 3, Alignment.center, true),
          tableCell("Actions", 3, Alignment.center, true),
        ],
      ),
    );
  }

  Widget tableRow(Booking b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          tableCell("#${b.bookingId}", 2, Alignment.centerLeft, false),
          tableCell(b.customerName, 3, Alignment.centerLeft, false),
          tableCell(b.service, 3, Alignment.centerLeft, false),
          tableCell(formatDate(b.dateTime), 3, Alignment.centerLeft, false),
          tableCell("${b.itemsCount} Items", 2, Alignment.centerLeft, false),
          tableCell(currency.format(b.totalAmount), 2, Alignment.centerLeft, false),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor(b.status).withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor(b.status).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(b.status.toLowerCase() == 'completed' ? Icons.check : Icons.circle, color: statusColor(b.status), size: 10),
                    const SizedBox(width: 6),
                    Text(b.status, style: TextStyle(color: statusColor(b.status), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: _buildActionButtons(b)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(Booking b) {
    final status = b.status.toLowerCase();
    List<Widget> buttons = [
      actionBtn(Icons.visibility, "View", Colors.blue, () => _showViewDialog(b)),
    ];
    if (status == "pending") {
      buttons.add(actionBtn(Icons.check, "Accept", Colors.green, () => _confirmAction(b.bookingId, "Confirmed", Colors.green)));
      buttons.add(actionBtn(Icons.close, "Reject", Colors.red, () => _confirmAction(b.bookingId, "Rejected", Colors.red)));
    }
    buttons.add(actionBtn(Icons.circle_outlined, "Status", Colors.orange, () => _showStatusPicker(b)));
    buttons.add(actionBtn(Icons.note, "Note", Colors.purpleAccent, () => _showNoteDialog(b)));
    return buttons;
  }

  static Widget tableCell(String text, int flex, [Alignment alignment = Alignment.center, bool isHeader = false]) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Text(text, textAlign: alignment == Alignment.center ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
            fontSize: isHeader ? 14 : 13,
            color: isHeader ? const Color(0xFF2C3E50) : Colors.black,
          )),
      ),
    );
  }

  Widget actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
