import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/environment_config.dart';

class HttpService {
  /// Helper to get headers (centralized for easy Auth token injection later)
  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// POST REQUEST
  /// [baseUrlKey]: The exact key name in your .env (e.g., 'AUTH_URL' or 'BASE_URL')
  /// [endpoint]: The path (e.g., '/login')
  /// [token]: Optional Bearer token for authentication
  Future<http.Response> post({
    required String baseUrlKey,
    required String endpoint,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final baseUrl = dotenv.env[baseUrlKey] ?? '';
    if (baseUrl.isEmpty) {
      final availableKeys = dotenv.env.keys.toList();
      throw Exception(
        'Environment variable "$baseUrlKey" is not set.\n'
        'Available keys: ${availableKeys.isEmpty ? "NONE" : availableKeys.join(", ")}\n'
        'Please add "$baseUrlKey=your_api_url" to your .env file.',
      );
    }
    final url = Uri.parse('$baseUrl$endpoint');

    return _sendRequest(
      () => http.post(url, headers: _getHeaders(token: token), body: jsonEncode(body)),
      method: 'POST',
      url: url,
      body: body,
    );
  }

  /// GET REQUEST
  /// [baseUrlKey]: The exact key name in your .env (e.g., 'AUTH_URL' or 'BASE_URL')
  /// [endpoint]: The path (e.g., '/auth/me')
  /// [token]: Optional Bearer token for authentication
  Future<http.Response> get({
    required String baseUrlKey,
    required String endpoint,
    String? token,
  }) async {
    final baseUrl = dotenv.env[baseUrlKey] ?? '';
    if (baseUrl.isEmpty) {
      final availableKeys = dotenv.env.keys.toList();
      throw Exception(
        'Environment variable "$baseUrlKey" is not set.\n'
        'Available keys: ${availableKeys.isEmpty ? "NONE" : availableKeys.join(", ")}\n'
        'Please add "$baseUrlKey=your_api_url" to your .env file.',
      );
    }
    final url = Uri.parse('$baseUrl$endpoint');

    return _sendRequest(
      () => http.get(url, headers: _getHeaders(token: token)),
      method: 'GET',
      url: url,
    );
  }

  /// PUT REQUEST
  Future<http.Response> put({
    required String baseUrlKey,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final baseUrl = dotenv.env[baseUrlKey] ?? '';
    if (baseUrl.isEmpty) {
      throw Exception('Environment variable "$baseUrlKey" is not set. Please check your .env file.');
    }
    final url = Uri.parse('$baseUrl$endpoint');

    return _sendRequest(
      () => http.put(url, headers: _getHeaders(), body: jsonEncode(body)),
      method: 'PUT',
      url: url,
      body: body,
    );
  }

  /// DELETE REQUEST 
  Future<http.Response> delete({
    required String baseUrlKey,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final baseUrl = dotenv.env[baseUrlKey] ?? '';
    if (baseUrl.isEmpty) {
      throw Exception('Environment variable "$baseUrlKey" is not set. Please check your .env file.');
    }
    final url = Uri.parse('$baseUrl$endpoint');

    return _sendRequest(
      () => http.delete(url, headers: _getHeaders(), body: jsonEncode(body)),
      method:'DELETE',
      url: url,
      body: body,
    );
  }

  /// Internal request wrapper for logging, timeouts, and error handling
  Future<http.Response> _sendRequest(
    Future<http.Response> Function() requestFn, {
    required String method,
    required Uri url,
    Map<String, dynamic>? body,
  }) async {
    try {
      if (EnvironmentConfig.isDevelopment) {
        print('🌐 HTTP Request: [$method] -> $url');
        if (body != null) print('📦 Payload: ${jsonEncode(body)}');
      }

      // Execute request with a 15-second timeout
      final response = await requestFn().timeout(const Duration(seconds: 15));

      if (EnvironmentConfig.isDevelopment) {
        print('📥 Response [${response.statusCode}]: ${response.body}');
      }

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Couldn\'t find the post 😱');
    } on FormatException {
      throw Exception('Bad response format 👎');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  /// Centralized Status Code Logic
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      // You can parse response.body here if your API returns specific error JSON
      throw Exception('Server Error ${response.statusCode}: ${response.body}');
    }
  }
}