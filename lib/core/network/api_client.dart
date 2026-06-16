import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://milstock.onrender.com/api';
  static const Duration timeoutDuration = Duration(seconds: 15);
  
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await _client.get(url, headers: headers).timeout(timeoutDuration);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await _client.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    ).timeout(timeoutDuration);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await _client.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    ).timeout(timeoutDuration);
  }

  Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await _client.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    ).timeout(timeoutDuration);
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await _client.delete(url, headers: headers).timeout(timeoutDuration);
  }
}
