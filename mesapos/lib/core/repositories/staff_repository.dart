import '../models/staff_model.dart';
import '../models/schedule_model.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class StaffRepository {
  final DatabaseService _databaseService;
  final ApiService _apiService;
  final AuthService _authService;

  StaffRepository({
    required DatabaseService databaseService,
    required ApiService apiService,
    required AuthService authService,
  })  : _databaseService = databaseService,
        _apiService = apiService,
        _authService = authService;

  // Get current staff profile
  StaffModel? getCurrentStaff() {
    return _authService.currentUser;
  }

  // Get schedule for current staff
  Future<List<ScheduleModel>> getSchedule() async {
    return await _databaseService.getSchedule();
  }

  // Get schedule by date range
  Future<List<ScheduleModel>> getScheduleByDateRange(
    DateTime start, 
    DateTime end
  ) async {
    final allSchedule = await _databaseService.getSchedule();
    return allSchedule.where((s) {
      return s.date.isAfter(start.subtract(const Duration(days: 1))) &&
          s.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Check if staff is available at specific date/time
  Future<bool> isAvailable(DateTime date, TimeOfDay time) async {
    final schedule = await _databaseService.getSchedule();
    
    final daySchedule = schedule.firstWhere(
      (s) => 
          s.date.year == date.year &&
          s.date.month == date.month &&
          s.date.day == date.day,
      orElse: () => ScheduleModel(
        id: '',
        date: date,
        shiftType: ShiftType.dayOff,
        isAvailable: false,
      ),
    );
    
    if (!daySchedule.isAvailable || daySchedule.shiftType != ShiftType.duty) {
      return false;
    }
    
    if (daySchedule.startTime != null && daySchedule.endTime != null) {
      final timeInMinutes = time.hour * 60 + time.minute;
      final startMinutes = daySchedule.startTime!.hour * 60 + daySchedule.startTime!.minute;
      final endMinutes = daySchedule.endTime!.hour * 60 + daySchedule.endTime!.minute;
      
      return timeInMinutes >= startMinutes && timeInMinutes <= endMinutes;
    }
    
    return true;
  }
}