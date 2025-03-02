import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminRequestsUpdateLogic {
  // Create an instance of secure storage
  static final _storage = const FlutterSecureStorage();

  // Update the registration request status (Accept or Reject)
  static Future<bool> updateRegistrationRequest({
    required BuildContext context,
    required int requestId,
    required String newStatus, // "Accept" or "Reject"
    required String message, // Add the message parameter
  }) async {
    try {
      // Get the access token from secure storage
      String? accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
         Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        print('No access token found.');
        
        // Ensure the widget is still mounted before showing the SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No access token found. Please log in again.')),
          );
        }
        
        return false;
      }

      // Prepare the POST request with JWT authentication
      final response = await http.post(
        Uri.parse('http://localhost:5000/admin/update_registration_request'), // Adjust the URL
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'request_id': requestId,
          'status': newStatus, // Either "Accept" or "Reject"
          'adim_message_body': message, // Include the message in the request body
        }),
      );

      if (response.statusCode == 200) {
        // Display success message based on the server response
        final successMessage = jsonDecode(response.body)['msg'];
        
        // Ensure the widget is still mounted before showing the SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
        }
        
        return true;
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return false;
      } else {
        // Handle unauthorized or error responses
        final errorMessage = jsonDecode(response.body)['msg'] ?? 'Failed to update request.';
        
        // Ensure the widget is still mounted before showing the SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
        
        return false;
      }
    } catch (e) {
      // Ensure the widget is still mounted before showing the SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      
      return false;
    }
  }
}
