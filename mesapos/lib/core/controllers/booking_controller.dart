import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../repositories/booking_repository.dart';

class BookingController {
  final BookingRepository _repo = BookingRepository(BookingService());

  // ======================================================
  // ✅ CREATE SAMPLE BOOKING (NOW WITH ITEMS + TOTAL)
  // ======================================================
  Future<void> createSampleBooking() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await _repo.create(
      Booking(
        bookingId: now.toString(),
        customerName: "Marc Anthony",
        service: "Table Service",
        dateTime: DateTime.now(),
        status: "Pending",
        notes: "VIP Customer",

        // ⭐ NEW REQUIRED DATA
        itemsCount: 2,
        totalAmount: 239.98,
      ),
    );
  }

  // ======================================================
  // ✅ READ ALL
  // ======================================================
  Future<List<Booking>> getBookings() async {
    return await _repo.getAll();
  }

  // ======================================================
  // ✅ UPDATE FULL BOOKING
  // ======================================================
  Future<void> updateBooking(Booking booking) async {
    await _repo.update(booking.bookingId, booking);
  }

  // ======================================================
  // ✅ UPDATE STATUS ONLY
  // ======================================================
  Future<void> updateBookingStatus(String id, String status) async {
    final booking = await getBookingById(id);

    if (booking == null) {
      throw Exception("Booking not found");
    }

    final updated = booking.copyWith(status: status);
    await _repo.update(id, updated);
  }

  // ======================================================
  // ✅ DELETE
  // ======================================================
  Future<void> deleteBooking(String id) async {
    await _repo.delete(id);
  }

  // ======================================================
  // ✅ GET BY ID
  // ======================================================
  Future<Booking?> getBookingById(String id) async {
    final bookings = await _repo.getAll();

    try {
      return bookings.firstWhere((b) => b.bookingId == id);
    } catch (_) {
      return null;
    }
  }

  // ======================================================
  // ⭐ DASHBOARD STATS (FOR INSIGHT CARDS)
  // ======================================================
  Future<int> countAll() async {
    final list = await _repo.getAll();
    return list.length;
  }

  Future<int> countByStatus(String status) async {
    final list = await _repo.getAll();
    return list.where((b) => b.status.toLowerCase() == status.toLowerCase()).length;
  }

  Future<int> countPending() async => countByStatus("Pending");
  Future<int> countConfirmed() async => countByStatus("Confirmed");
  Future<int> countCompleted() async => countByStatus("Completed");

  // ======================================================
  // ⭐ FILTER HELPERS (FOR TABLE FILTER BUTTONS)
  // ======================================================
  Future<List<Booking>> getByStatus(String status) async {
    final list = await _repo.getAll();
    return list
        .where((b) => b.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Future<List<Booking>> searchBookings(String query) async {
    final list = await _repo.getAll();

    return list.where((b) {
      final q = query.toLowerCase();
      return b.customerName.toLowerCase().contains(q) ||
          b.service.toLowerCase().contains(q) ||
          b.bookingId.toLowerCase().contains(q);
    }).toList();
  }

  Future<List<Booking>> filterByDate(DateTime date) async {
    final list = await _repo.getAll();

    return list.where((b) {
      return b.dateTime.year == date.year &&
          b.dateTime.month == date.month &&
          b.dateTime.day == date.day;
    }).toList();
  }
}
