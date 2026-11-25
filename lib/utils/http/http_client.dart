import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppHttpHelper {
  static const String _baseUrl = 'https://your-api-base-url.com';

  /// Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    _logRequest(method: 'GET', url: url, headers: headers);
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(url, headers: headers);
      stopwatch.stop();
      _logResponse(method: 'GET', url: url, response: response, durationMs: stopwatch.elapsedMilliseconds);
      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'GET', url: url, error: e, durationMs: stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  /// Helper method to make a POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final effectiveHeaders = {'Content-Type': 'application/json', ...?headers};
    final encodedBody = data is String ? data : json.encode(data);
    _logRequest(method: 'POST', url: url, headers: effectiveHeaders, body: data);
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.post(
        url,
        headers: effectiveHeaders,
        body: encodedBody,
      );
      stopwatch.stop();
      _logResponse(method: 'POST', url: url, response: response, durationMs: stopwatch.elapsedMilliseconds);
      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'POST', url: url, error: e, durationMs: stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  /// Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final effectiveHeaders = {'Content-Type': 'application/json', ...?headers};
    final encodedBody = data is String ? data : json.encode(data);
    _logRequest(method: 'PUT', url: url, headers: effectiveHeaders, body: data);
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.put(
        url,
        headers: effectiveHeaders,
        body: encodedBody,
      );
      stopwatch.stop();
      _logResponse(method: 'PUT', url: url, response: response, durationMs: stopwatch.elapsedMilliseconds);
      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PUT', url: url, error: e, durationMs: stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  /// Helper method to make a PATCH request
  static Future<Map<String, dynamic>> patch(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final effectiveHeaders = {'Content-Type': 'application/json', ...?headers};
    final encodedBody = data is String ? data : json.encode(data);
    _logRequest(method: 'PATCH', url: url, headers: effectiveHeaders, body: data);
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.patch(
        url,
        headers: effectiveHeaders,
        body: encodedBody,
      );
      stopwatch.stop();
      _logResponse(method: 'PATCH', url: url, response: response, durationMs: stopwatch.elapsedMilliseconds);
      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PATCH', url: url, error: e, durationMs: stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  /// DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers, dynamic data}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final effectiveHeaders = data != null ? {'Content-Type': 'application/json', ...?headers} : headers;
    final encodedBody = data != null ? (data is String ? data : json.encode(data)) : null;
    _logRequest(method: 'DELETE', url: url, headers: effectiveHeaders, body: data);
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.delete(
        url,
        headers: effectiveHeaders,
        body: encodedBody,
      );
      stopwatch.stop();
      _logResponse(method: 'DELETE', url: url, response: response, durationMs: stopwatch.elapsedMilliseconds);
      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'DELETE', url: url, error: e, durationMs: stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  /// Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return <String, dynamic>{};
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } else {
      throw Exception('Failed to load data: [${response.statusCode}] ${response.body}');
    }
  }

  /// Format JSON or object for pretty printing
  static String _prettyFormat(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is String) {
        final decoded = json.decode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  /// Request logger
  static void _logRequest({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    if (!kDebugMode) return;
    final buffer = StringBuffer();
    buffer.writeln('==================== [HTTP API REQUEST] ====================');
    buffer.writeln('--> $method $url');
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }
    if (body != null) {
      buffer.writeln('Body:\n${_prettyFormat(body)}');
    }
    buffer.writeln('===========================================================');
    debugPrint(buffer.toString());
  }

  /// Response logger
  static void _logResponse({
    required String method,
    required Uri url,
    required http.Response response,
    required int durationMs,
  }) {
    if (!kDebugMode) return;
    final buffer = StringBuffer();
    buffer.writeln('==================== [HTTP API RESPONSE] ====================');
    buffer.writeln('<-- $method ${response.statusCode} $url (${durationMs}ms)');
    if (response.headers.isNotEmpty) {
      buffer.writeln('Headers: ${response.headers}');
    }
    buffer.writeln('Body:\n${_prettyFormat(response.body)}');
    buffer.writeln('============================================================');
    debugPrint(buffer.toString());
  }

  /// Error logger
  static void _logError({
    required String method,
    required Uri url,
    required dynamic error,
    required int durationMs,
  }) {
    if (!kDebugMode) return;
    final buffer = StringBuffer();
    buffer.writeln('==================== [HTTP API ERROR] ====================');
    buffer.writeln('<-- $method ERROR $url (${durationMs}ms)');
    buffer.writeln('Error Details: $error');
    buffer.writeln('==========================================================');
    debugPrint(buffer.toString());
  }
}
