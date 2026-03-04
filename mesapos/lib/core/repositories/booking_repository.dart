import '../models/booking_model.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';

class BookingRepository {
  final DatabaseService _databaseService;
  final ApiService _apiService;

  BookingRepository({
    required DatabaseService databaseService,
    required ApiService apiService,
  })  : _databaseService = databaseService,
        _apiService = apiService;

  // Get all bookings
  Future<List<BookingModel>> getBookings() async {
    return await _databaseService.getBookings();
  }

  // Get bookings by status
  Future<List<BookingModel>> getBookingsByStatus(BookingStatus status) async {
    final allBookings = await _databaseService.getBookings();
    return allBookings.where((b) => b.status == status).toList();
  }

  // Get bookings assigned to specific staff
  Future<List<BookingModel>> getAssignedBookings(String staffId) async {
    final allBookings = await _databaseService.getBookings();
    return allBookings.where((b) => b.assignedStaffId == staffId).toList();
  }

  // Get booking by ID
  Future<BookingModel?> getBookingById(String id) async {
    return await _databaseService.getBookingById(id);
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    final booking = await _databaseService.getBookingById(bookingId);
    if (booking != null) {
      final updatedBooking = booking.copyWith(
        status: newStatus,
        lastUpdated: DateTime.now(),
      );
      await _databaseService.updateBooking(updatedBooking);
      
      // Sync with API in real app
      try {
        await _apiService.patch('bookings/$bookingId', data: {
          'status': newStatus.toString().split('.').last,
        });
      } catch (e) {
        // Handle sync error
      }
    }
  }

  // Add notes to booking
  Future<void> addBookingNotes(String bookingId, String notes) async {
    final booking = await _databaseService.getBookingById(bookingId);
    if (booking != null) {
      final updatedBooking = booking.copyWith(
        notes: notes,
        lastUpdated: DateTime.now(),
      );
      await _databaseService.updateBooking(updatedBooking);
    }
  }

  // Get booking counts
  Future<Map<String, int>> getBookingCounts(String staffId) async {
    final assigned = await getAssignedBookings(staffId);
    return {
      'assigned': assigned.length,
      'pending': assigned.where((b) => b.status == BookingStatus.pending).length,
      'confirmed': assigned.where((b) => b.status == BookingStatus.confirmed).length,
      'completed': assigned.where((b) => b.status == BookingStatus.completed).length,
      'cancelled': assigned.where((b) => b.status == BookingStatus.cancelled).length,
      'rejected': assigned.where((b) => b.status == BookingStatus.rejected).length,
    };
  }

  // Search bookings
  Future<List<BookingModel>> searchBookings(String query) async {
    final allBookings = await _databaseService.getBookings();
    if (query.isEmpty) return allBookings;
    
    final lowerQuery = query.toLowerCase();
    return allBookings.where((b) {
      return b.customerName.toLowerCase().contains(lowerQuery) ||
          b.service.toLowerCase().contains(lowerQuery) ||
          b.bookingId.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter bookings by date
  Future<List<BookingModel>> filterBookingsByDate(DateTime date) async {
    final allBookings = await _databaseService.getBookings();
    return allBookings.where((b) {
      return b.dateTime.year == date.year &&
          b.dateTime.month == date.month &&
          b.dateTime.day == date.day;
    }).toList();
  }
}