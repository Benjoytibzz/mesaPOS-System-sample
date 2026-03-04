import '../models/customer_model.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';

class CustomerRepository {
  final DatabaseService _databaseService;
  final ApiService _apiService;

  CustomerRepository({
    required DatabaseService databaseService,
    required ApiService apiService,
  })  : _databaseService = databaseService,
        _apiService = apiService;

  // Get all customers
  Future<List<CustomerModel>> getCustomers() async {
    return await _databaseService.getCustomers();
  }

  // Search customers
  Future<List<CustomerModel>> searchCustomers(String query) async {
    final allCustomers = await _databaseService.getCustomers();
    if (query.isEmpty) return allCustomers;
    
    final lowerQuery = query.toLowerCase();
    return allCustomers.where((c) {
      return c.fullName.toLowerCase().contains(lowerQuery) ||
          c.email.toLowerCase().contains(lowerQuery) ||
          c.phone.contains(query);
    }).toList();
  }

  // Get customer by ID
  Future<CustomerModel?> getCustomerById(String id) async {
    final allCustomers = await _databaseService.getCustomers();
    try {
      return allCustomers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get frequent customers
  Future<List<CustomerModel>> getFrequentCustomers({int minBookings = 5}) async {
    final allCustomers = await _databaseService.getCustomers();
    return allCustomers.where((c) => c.totalBookings >= minBookings).toList();
  }
}