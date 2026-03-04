import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';
import '../services/auth_service.dart';

class BookingController extends ChangeNotifier {
  final BookingRepository _repository;
  final AuthService _authService;

  List<BookingModel> _bookings = [];
  List<BookingModel> _filteredBookings = [];
  BookingModel? _selectedBooking;
  Map<String, int> _counts = {};
  String _searchQuery = '';
  DateTime? _selectedDate;
  BookingStatus? _selectedStatus;
  bool _isLoading = false;
  String? _error;

  BookingController({
    required BookingRepository repository,
    required AuthService authService,
  })  : _repository = repository,
        _authService = authService;

  // Getters
  List<BookingModel> get bookings => _filteredBookings;
  BookingModel? get selectedBooking => _selectedBooking;
  Map<String, int> get counts => _counts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  BookingStatus? get selectedStatus => _selectedStatus;

  // Load bookings
  Future<void> loadBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final staff = _authService.currentUser;
      if (staff != null) {
        _bookings = await _repository.getAssignedBookings(staff.id);
        _counts = await _repository.getBookingCounts(staff.id);
        _applyFilters();
      }
    } catch (e) {
      _error = 'Failed to load bookings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search bookings
  void searchBookings(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by date
  void filterByDate(DateTime? date) {
    _selectedDate = date;
    _applyFilters();
  }

  // Filter by status
  void filterByStatus(BookingStatus? status) {
    _selectedStatus = status;
    _applyFilters();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedDate = null;
    _selectedStatus = null;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    _filteredBookings = List.from(_bookings);

    // Apply status filter
    if (_selectedStatus != null) {
      _filteredBookings = _filteredBookings
          .where((b) => b.status == _selectedStatus)
          .toList();
    }

    // Apply date filter
    if (_selectedDate != null) {
      _filteredBookings = _filteredBookings.where((b) {
        return b.dateTime.year == _selectedDate!.year &&
            b.dateTime.month == _selectedDate!.month &&
            b.dateTime.day == _selectedDate!.day;
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredBookings = _filteredBookings.where((b) {
        return b.customerName.toLowerCase().contains(query) ||
            b.service.toLowerCase().contains(query) ||
            b.bookingId.toLowerCase().contains(query);
      }).toList();
    }

    notifyListeners();
  }

  // Select booking
  void selectBooking(BookingModel booking) {
    _selectedBooking = booking;
    notifyListeners();
  }

  // Clear selected booking
  void clearSelectedBooking() {
    _selectedBooking = null;
    notifyListeners();
  }

  // Update booking status
  Future<bool> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.updateBookingStatus(bookingId, newStatus);
      await loadBookings(); // Reload to get updated data
      
      return true;
    } catch (e) {
      _error = 'Failed to update status: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add booking notes
  Future<bool> addBookingNotes(String bookingId, String notes) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.addBookingNotes(bookingId, notes);
      if (_selectedBooking?.id == bookingId) {
        _selectedBooking = await _repository.getBookingById(bookingId);
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to add notes: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get booking by ID
  Future<void> loadBookingById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedBooking = await _repository.getBookingById(id);
    } catch (e) {
      _error = 'Failed to load booking: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}