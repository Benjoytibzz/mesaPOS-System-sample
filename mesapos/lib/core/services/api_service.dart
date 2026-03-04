import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'https://api.example.com/v1';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
    _headers['Authorization'] = 'Bearer $token';
  }

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> patch(String endpoint, {Map<String, dynamic>? data}) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );
    _handleErrors(response);
    return response;
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode >= 400) {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'API Error ($statusCode): $message';
}