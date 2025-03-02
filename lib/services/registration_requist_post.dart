import 'dart:convert';
import 'dart:io'; // Import for SocketException
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:blood_line_desktop/routes/app_routes.dart'; // Adjust path as needed

class RegistrationRequestPost {
  // Method to send registration request
  static Future<bool> sendRegistrationRequest(
    BuildContext context,
    String organizationName,
    String contactInfo,
    String managerName,
    String managerPosition,
    String managerEmail,
    String startHour,
    String closeHour,
    double latitude,
    double longitude
  ) async {
    try {
      // Prepare registration request
      final response = await http.post(
        Uri.parse('http://localhost:5000/request_registration'), // Update with your API URL
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'organization_name': organizationName,
          'contact_info': contactInfo,
          'manager_name': managerName,
          'manager_position': managerPosition,
          'manager_email': managerEmail,
          'latitude' : latitude,
          'longitude' : longitude,
          'start_hour' : startHour,
          'close_hour' : closeHour
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String message = data['message'];
        print('Server message: $message');

        // Navigate to login page after successful request
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginPage,
            (Route<dynamic> route) => false,
          );
        }

        return true;
      } else if (response.statusCode == 409) {
        // Handle email already exists case
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already exists.')),
          );
        }
        return false;
      } else {
        // Handle other failure cases
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit registration request.')),
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
      // Handle other unexpected errors
      print('Error during registration request: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }
}
