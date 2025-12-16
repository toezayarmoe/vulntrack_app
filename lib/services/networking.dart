import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHelper {
  NetworkHelper(this.url);
  final Uri url;

  /// GET without auth
  /// Returns the raw http.Response object regardless of status code.
  Future<http.Response> getData() async {
    final response = await http.get(url);

    // Simply return the response object
    return response;
  }

  /// GET with Authorization token
  /// Returns the raw http.Response object regardless of status code.
  Future<http.Response> getDataWithAuth() async {
    // Note: It's better to use your Preferences class's synchronous getter here
    // once it's fully integrated and loaded in main().
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // It's usually better to throw a specific error or return a custom error
      // state than an http.Response, but for now, we keep the throw.
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    // Simply return the response object
    return response;
  }

  /// POST without auth
  /// Returns the raw http.Response object regardless of status code.
  Future<http.Response> postData(Map<String, dynamic> body) async {
    // The implementation is already correct for your goal: it returns the raw object.
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
  }

  /// POST with Authorization token
  /// Returns the raw http.Response object regardless of status code.
  Future<http.Response> postDataWithAuth(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found');
    }

    // The implementation is already correct for your goal: it returns the raw object.
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
