// lib/services/schedule_service.dart
import '../models/schedule_model.dart';
import '../repositories/holiday_repository.dart';
import '../repositories/schedule_repository.dart';

class ScheduleService {
  final HolidayRepository _holidayRepo = HolidayRepository();
  final ScheduleRepository _scheduleRepo = ScheduleRepository();

  Future<List<DailySchedule>> getMonthlySchedule(int year, int month) async {
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 0); // Last day of the month

    // Fetch both simultaneously for performance
    final results = await Future.wait([
      _holidayRepo.fetchPhilippineHolidays(year),
      _scheduleRepo.fetchStaffSchedules(startDate, endDate)
    ]);

    final List<Holiday> holidays = results[0] as List<Holiday>;
    final List<DailySchedule> baseSchedules = results[1] as List<DailySchedule>;

    // Merge logic: Map holidays to the respective schedule days
    return baseSchedules.map((schedule) {
      final holidayMatch = holidays.where((h) => 
        h.date.year == schedule.date.year &&
        h.date.month == schedule.date.month &&
        h.date.day == schedule.date.day
      ).toList();

      if (holidayMatch.isNotEmpty) {
        return DailySchedule(
          date: schedule.date,
          holiday: holidayMatch.first,
          isDayOff: false, // Override to show as Holiday
          slots: [], // No available slots on holidays
        );
      }
      return schedule;
    }).toList();
  }
}