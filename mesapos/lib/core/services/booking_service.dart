import 'package:mesapos/core/models/booking_model.dart';

class BookingModelService {
  final List<BookingModel> _bookings = [];

  // ======================================================
  // CREATE
  // ======================================================
  Future<void> createBookingModel(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookings.add(booking);
  }

  // ======================================================
  // READ ALL (SAFE COPY)
  // ======================================================
  Future<List<BookingModel>> getAllBookingModels() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_bookings);
  }

  // ======================================================
  // READ ONE (SAFE NULL RETURN)
  // ======================================================
  Future<BookingModel?> getBookingModelById(String id) async {
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
  Future<void> updateBookingModel(String id, BookingModel updatedBookingModel) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _bookings.indexWhere((b) => b.bookingId == id);

    if (index == -1) {
      throw Exception("BookingModel not found");
    }

    _bookings[index] = updatedBookingModel;
  }

  // ======================================================
  // DELETE
  // ======================================================
  Future<void> deleteBookingModel(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookings.removeWhere((b) => b.bookingId == id);
  }
}
