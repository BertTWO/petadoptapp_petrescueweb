// lib/core/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.2:8000/api';
  static const Duration timeoutDuration = Duration(seconds: 30);

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('Error clearing token: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (includeAuth) {
        final token = await getToken();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      print('POST $url');
      print('Headers: $headers');
      print('Body: ${body ?? {}}');

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(timeoutDuration);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException {
      throw Exception('Connection error');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      print('Post request error: $e');
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('GET $url');
      print('Headers: $headers');

      final response = await http
          .get(url, headers: headers)
          .timeout(timeoutDuration);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException {
      throw Exception('Connection error');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      print('Get request error: $e');
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    try {
      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final responseBody = jsonDecode(response.body);

      if (statusCode >= 200 && statusCode < 300) {
        return responseBody;
      } else {
        // Handle Laravel validation errors
        if (responseBody.containsKey('errors')) {
          final errors = responseBody['errors'];
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            throw Exception(firstError.first.toString());
          }
        }

        final errorMessage =
            responseBody['message'] ??
            responseBody['error'] ??
            responseBody['errors'] ??
            'API Error: ${response.reasonPhrase}';
        throw Exception(errorMessage.toString());
      }
    } on FormatException {
      throw Exception('Invalid response format from server');
    } catch (e) {
      throw Exception('Failed to handle response: ${e.toString()}');
    }
  }
}
