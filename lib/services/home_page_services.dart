import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blood_line_desktop/routes/app_routes.dart';

class HomePageService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://localhost:5000';

  /// Fetch user data based on their role
  static Future<Map<String, dynamic>?> fetchUserData(BuildContext context) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        _redirectToLogin(context);
        return null;
      }

      // Make GET request to fetch user data
      final response = await http.get(
        Uri.parse('$_baseUrl/get_user_data'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }else if (response.statusCode == 401){
        _redirectToLogin(context);
        return null;
      } else if (response.statusCode == 403) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unauthorized access.')),
          );
        }
      } else if (response.statusCode == 404) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found.')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch data: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
    return null; // Return null in case of an error
  }

  /// Redirect user to login page with a message
  static void _redirectToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access token not found or expired. Please log in again.')),
      );
    }
  }
}
