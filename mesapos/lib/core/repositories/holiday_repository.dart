import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule_model.dart';

class HolidayRepository {
  // Using Nager.Date API for real-time Public Holidays
  Future<List<Holiday>> fetchPhilippineHolidays(int year) async {
    final url = Uri.parse('https://date.nager.at/api/v3/PublicHolidays/$year/PH');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Holiday.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load holidays');
      }
    } catch (e) {
      // Fallback or rethrow for the service layer to handle
      throw Exception('Error fetching holidays: $e');
    }
  }
}