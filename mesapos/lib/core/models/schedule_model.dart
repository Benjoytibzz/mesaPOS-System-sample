import 'package:flutter/material.dart';

class Holiday {
  final DateTime date;
  final String name;

  Holiday({required this.date, required this.name});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: DateTime.parse(json['date']),
      name: json['name'],
    );
  }
}

class TimeSlot {
  final TimeOfDay time;
  final bool isAvailable;

  TimeSlot({required this.time, this.isAvailable = true});
}

class DailySchedule {
  final DateTime date;
  final bool isDayOff;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Holiday? holiday;
  final List<TimeSlot> slots;

  DailySchedule({
    required this.date,
    this.isDayOff = false,
    this.startTime,
    this.endTime,
    this.holiday,
    this.slots = const [],
  });

  bool get isHoliday => holiday != null;
  bool get isDutyDay => !isDayOff && !isHoliday;
}