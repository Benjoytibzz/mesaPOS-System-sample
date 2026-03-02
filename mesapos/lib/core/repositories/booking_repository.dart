import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingRepository {
  final BookingService _service;

  BookingRepository(this._service);

  // ======================================================
  // CRUD
  // ======================================================

  Future<void> create(Booking booking) =>
      _service.createBooking(booking);

  Future<List<Booking>> getAll() =>
      _service.getAllBookings();

  Future<Booking?> getById(String id) =>
      _service.getBookingById(id);

  Future<void> update(String id, Booking booking) =>
      _service.updateBooking(id, booking);

  Future<void> delete(String id) =>
      _service.deleteBooking(id);

  // ======================================================
  // ⭐ FILTERING
  // ======================================================

  Future<List<Booking>> getByStatus(String status) async {
    final list = await _service.getAllBookings();
    return list
        .where((b) =>
            b.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Future<List<Booking>> search(String query) async {
    final list = await _service.getAllBookings();
    final q = query.toLowerCase();

    return list.where((b) {
      return b.customerName.toLowerCase().contains(q) ||
          b.service.toLowerCase().contains(q) ||
          b.bookingId.toLowerCase().contains(q);
    }).toList();
  }

  Future<List<Booking>> filterByDate(DateTime date) async {
    final list = await _service.getAllBookings();

    return list.where((b) {
      return b.dateTime.year == date.year &&
          b.dateTime.month == date.month &&
          b.dateTime.day == date.day;
    }).toList();
  }

  // ======================================================
  // ⭐ DASHBOARD STATS
  // ======================================================

  Future<int> countAll() async {
    final list = await _service.getAllBookings();
    return list.length;
  }

  Future<int> countByStatus(String status) async {
    final list = await _service.getAllBookings();
    return list
        .where((b) =>
            b.status.toLowerCase() == status.toLowerCase())
        .length;
  }

  Future<int> countPending() => countByStatus("Pending");
  Future<int> countConfirmed() => countByStatus("Confirmed");
  Future<int> countCompleted() => countByStatus("Completed");
  Future<int> countCancelled() => countByStatus("Cancelled");
  Future<int> countRejected() => countByStatus("Rejected");

  // ======================================================
  // ⭐ FINANCIAL STATS (VERY USEFUL)
  // ======================================================

  Future<double> totsalRevenue() async {
    final list = await _service.getAllBookings();
    return list.fold<double>(
      0.0,
      (sum, booking) => sum + booking.totalAmount,
    );
  }

  Future<int> totalItemsSold() async {
    final list = await _service.getAllBookings();
    return list.fold<int>(
      0,
      (sum, booking) => sum + booking.itemsCount,
    );
  }
}

