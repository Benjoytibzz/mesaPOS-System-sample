import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

class CustomerController extends ChangeNotifier {
  final CustomerRepository _repository;

  List<CustomerModel> _customers = [];
  List<CustomerModel> _filteredCustomers = [];
  CustomerModel? _selectedCustomer;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  CustomerController({
    required CustomerRepository repository,
  }) : _repository = repository;

  // Getters
  List<CustomerModel> get customers => _filteredCustomers;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load customers
  Future<void> loadCustomers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customers = await _repository.getCustomers();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load customers: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search customers
  void searchCustomers(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredCustomers = List.from(_customers);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredCustomers = _filteredCustomers.where((c) {
        return c.fullName.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query) ||
            c.phone.contains(query);
      }).toList();
    }

    notifyListeners();
  }

  // Select customer
  void selectCustomer(CustomerModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  // Clear selected customer
  void clearSelectedCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }
}