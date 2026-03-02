import '../models/booking_model.dart';

class BookingService {
  final List<Booking> _bookings = [];

  // ======================================================
  // CREATE
  // ======================================================
  Future<void> createBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookings.add(booking);
  }

  // ======================================================
  // READ ALL (SAFE COPY)
  // ======================================================
  Future<List<Booking>> getAllBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_bookings);
  }

  // ======================================================
  // READ ONE (SAFE NULL RETURN)
  // ======================================================
  Future<Booking?> getBookingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _bookings.firstWhere((b) => b.bookingId == id);
    } catch (_) {
      return null;
    }
  }

  // ======================================================
  // UPDATE
  // ======================================================
  Future<void> updateBooking(String id, Booking updatedBooking) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _bookings.indexWhere((b) => b.bookingId == id);

    if (index == -1) {
      throw Exception("Booking not found");
    }

    _bookings[index] = updatedBooking;
  }

  // ======================================================
  // DELETE
  // ======================================================
  Future<void> deleteBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookings.removeWhere((b) => b.bookingId == id);
  }
}
