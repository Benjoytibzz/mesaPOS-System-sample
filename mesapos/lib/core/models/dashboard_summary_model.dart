class DashboardSummary {
  final int upcomingAppointments;
  final int completedToday;
  final int todayBookings;
  final int pendingBookings;

  DashboardSummary({
    required this.upcomingAppointments,
    required this.completedToday,
    required this.todayBookings,
    required this.pendingBookings,
  });
}