import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/failures.dart';

class ApiClient {
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const ServerFailure('Request timed out');
    }
  }

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const ServerFailure('Request timed out');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw const AuthFailure('Invalid credentials');
    } else {
      throw ServerFailure('Server error: ${response.statusCode}');
    }
  }
}
