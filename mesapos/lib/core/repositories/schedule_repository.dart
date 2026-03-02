import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ScheduleRepository {
  // Mocking database fetch for POS staff schedules
  Future<List<DailySchedule>> fetchStaffSchedules(DateTime startDate, DateTime endDate) async {
    // In production, this queries your POS local DB or backend
    await Future.delayed(const Duration(milliseconds: 500)); 
    
    List<DailySchedule> schedules = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      
      // Mock rule: Sundays are Day Off
      bool isDayOff = currentDate.weekday == DateTime.sunday;
      
      schedules.add(DailySchedule(
        date: currentDate,
        isDayOff: isDayOff,
        startTime: isDayOff ? null : const TimeOfDay(hour: 8, minute: 0),
        endTime: isDayOff ? null : const TimeOfDay(hour: 17, minute: 0),
        slots: _generateSlots(),
      ));
    }
    return schedules;
  }

  List<TimeSlot> _generateSlots() {
    return List.generate(
      10, 
      (index) => TimeSlot(time: TimeOfDay(hour: 9 + index, minute: 0), isAvailable: true)
    );
  }
}