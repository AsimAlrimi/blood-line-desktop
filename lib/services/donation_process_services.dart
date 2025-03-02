import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DonationProcessServices {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://localhost:5000';

  /// Complete an appointment by sending the required data to the backend
  static Future<bool> completeAppointment(
    BuildContext context,
    int appointmentId,
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
         Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return false;
      }

      // Make POST request to complete the appointment
      final response = await http.post(
        Uri.parse('$_baseUrl/complete_appointment/$appointmentId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
        body: jsonEncode(appointmentData),
      );

      // Handle response
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment completed successfully!')),
          );
        }
        return true;
      } else if (response.statusCode == 400) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incomplete data provided. Please check your input.')),
          );
        }
      } else if (response.statusCode == 403) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unauthorized access.')),
          );
        }
      } else if (response.statusCode == 404) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment not found or already completed.')),
          );
        }
      } else if (response.statusCode == 401) {
        // Redirect to login if unauthorized
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to complete appointment: ${response.statusCode}')),
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
}
