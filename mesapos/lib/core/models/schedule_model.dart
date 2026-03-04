import 'package:flutter/material.dart';

enum ShiftType { duty, holiday, dayOff }

class ScheduleModel {
  final String id;
  final DateTime date;
  final ShiftType shiftType;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? notes;
  final bool isAvailable;

  ScheduleModel({
    required this.id,
    required this.date,
    required this.shiftType,
    this.startTime,
    this.endTime,
    this.notes,
    this.isAvailable = true,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      shiftType: _parseShiftType(json['shiftType']),
      startTime: json['startTime'] != null 
          ? _parseTimeOfDay(json['startTime']) 
          : null,
      endTime: json['endTime'] != null 
          ? _parseTimeOfDay(json['endTime']) 
          : null,
      notes: json['notes'],
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  static ShiftType _parseShiftType(String? type) {
    switch (type?.toLowerCase()) {
      case 'duty':
      case 'duty day':
        return ShiftType.duty;
      case 'holiday':
        return ShiftType.holiday;
      case 'dayoff':
      case 'day off':
        return ShiftType.dayOff;
      default:
        return ShiftType.duty;
    }
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'shiftType': shiftType.toString().split('.').last,
      'startTime': startTime != null 
          ? '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'endTime': endTime != null 
          ? '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'notes': notes,
      'isAvailable': isAvailable,
    };
  }

  String get shiftDisplay {
    switch (shiftType) {
      case ShiftType.duty:
        return 'Duty Day';
      case ShiftType.holiday:
        return 'Holiday';
      case ShiftType.dayOff:
        return 'Day Off';
    }
  }

  Color get shiftColor {
    switch (shiftType) {
      case ShiftType.duty:
        return const Color(0xFF4CAF50);
      case ShiftType.holiday:
        return const Color(0xFFFFA726);
      case ShiftType.dayOff:
        return const Color(0xFF9E9E9E);
    }
  }

  String? timeDisplay(BuildContext context) {
    if (startTime != null && endTime != null) {
      return '${startTime!.format(context)} - ${endTime!.format(context)}';
    }
    return null;
  }
}

// Note: TimeOfDay formatting requires BuildContext, so we'll handle that in the view