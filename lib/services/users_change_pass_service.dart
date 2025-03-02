import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blood_line_desktop/routes/app_routes.dart';

class UsersChangePassService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://localhost:5000';

  /// Change user password
  static Future<bool> changePassword(BuildContext context, String oldPassword, String newPassword) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        _redirectToLogin(context);
        return false;
      }

      // Prepare the request body
      final body = jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      });

      // Make PUT request
      final response = await http.put(
        Uri.parse('$_baseUrl/change_password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
        body: body,
      );

      // Handle response
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
        }
        return true;
      } else if (response.statusCode == 400) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Old password is incorrect.')),
          );
        }
      } else if (response.statusCode == 401) {
        _redirectToLogin(context);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to change password: ${response.statusCode}')),
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
    return false;
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
