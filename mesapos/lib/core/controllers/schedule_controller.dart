import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../repositories/staff_repository.dart';

class ScheduleController extends ChangeNotifier {
  final StaffRepository _repository;

  List<ScheduleModel> _schedule = [];
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  ScheduleViewType _viewType = ScheduleViewType.month;
  bool _isLoading = false;
  String? _error;

  ScheduleController({
    required StaffRepository repository,
  }) : _repository = repository;

  // Getters
  List<ScheduleModel> get schedule => _schedule;
  DateTime get currentMonth => _currentMonth;
  DateTime? get selectedDate => _selectedDate;
  ScheduleViewType get viewType => _viewType;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load schedule
  Future<void> loadSchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _schedule = await _repository.getSchedule();
    } catch (e) {
      _error = 'Failed to load schedule: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change month
  void previousMonth() {
    _currentMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month - 1,
      1,
    );
    notifyListeners();
  }

  void nextMonth() {
    _currentMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      1,
    );
    notifyListeners();
  }

  // Change view type
  void setViewType(ScheduleViewType type) {
    _viewType = type;
    notifyListeners();
  }

  // Select date
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Get schedule for a specific date
  ScheduleModel? getScheduleForDate(DateTime date) {
    try {
      return _schedule.firstWhere((s) =>
          s.date.year == date.year &&
          s.date.month == date.month &&
          s.date.day == date.day);
    } catch (e) {
      return null;
    }
  }

  // Get available time slots for selected date
  List<TimeOfDay> getAvailableTimeSlots() {
    if (_selectedDate == null) return [];

    final daySchedule = getScheduleForDate(_selectedDate!);
    if (daySchedule == null || 
        daySchedule.shiftType != ShiftType.duty || 
        !daySchedule.isAvailable) {
      return [];
    }

    if (daySchedule.startTime == null || daySchedule.endTime == null) {
      return [];
    }

    final slots = <TimeOfDay>[];
    var current = daySchedule.startTime!;
    
    while (current.hour < daySchedule.endTime!.hour ||
        (current.hour == daySchedule.endTime!.hour && 
         current.minute <= daySchedule.endTime!.minute)) {
      slots.add(current);
      
      // Add 1 hour
      current = TimeOfDay(
        hour: current.hour + 1,
        minute: current.minute,
      );
    }
    
    return slots;
  }
}

enum ScheduleViewType { day, week, month }