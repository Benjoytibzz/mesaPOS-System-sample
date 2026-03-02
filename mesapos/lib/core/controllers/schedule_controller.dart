import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/schedule_service.dart';

enum ViewMode { day, week, month }

class ScheduleController extends ChangeNotifier {
  final ScheduleService _service = ScheduleService();

  DateTime currentDate = DateTime.now(); // Defaults to current month/year
  ViewMode currentView = ViewMode.month;
  
  List<DailySchedule> schedules = [];
  bool isLoading = false;
  String? errorMessage;

  ScheduleController() {
    loadSchedules();
  }

  void setViewMode(ViewMode mode) {
    currentView = mode;
    notifyListeners();
  }

  void nextMonth() {
    currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
    loadSchedules();
  }

  void previousMonth() {
    currentDate = DateTime(currentDate.year, currentDate.month - 1, 1);
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      schedules = await _service.getMonthlySchedule(currentDate.year, currentDate.month);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}