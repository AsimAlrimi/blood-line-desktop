import 'dart:convert';
import 'dart:io'; // For SocketException
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StaffCreationService {
  // Create an instance of FlutterSecureStorage
  static final _storage = const FlutterSecureStorage();

  // Method to create a staff member
  static Future<bool> createStaffMember(
    BuildContext context,
    String fullName,
    String role,
    String email,
  ) async {
    try {
      // Get the access token from secure storage
      String? accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No access token found. Please log in again.')),
          );
        }
        return false;
      }

      // Prepare the POST request with JWT authentication
      final response = await http.post(
        Uri.parse('http://localhost:5000/create-staff'), // Update with your API URL
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': fullName,
          'role': role,
          'email': email,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Staff member created successfully.')),
          );
        }
        return true;
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
          return false;
      }
       else if (response.statusCode == 409) {
        // Handle email already in use
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already in use.')),
          );
        }
        return false;
      } else {
        // Handle other failure cases
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create staff member.')),
          );
        }
        return false;
      }
    } on SocketException {
      // Handle network errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Please check your connection.')),
        );
      }
      return false;
    } catch (e) {
      // Handle other errors
      print('Error during staff creation: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }
}
