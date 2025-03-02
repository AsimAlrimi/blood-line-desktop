import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage

class AdminRequestsLogic {
  // Create an instance of secure storage
  static final _storage = const FlutterSecureStorage();

  // Fetch pending registration requests
  static Future<List<Map<String, dynamic>>?> fetchRegistrationRequests(BuildContext context) async {
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
        
        return null;
      }

      // Prepare the GET request with JWT authentication
      final response = await http.get(
        Uri.parse('http://localhost:5000/admin/get_registration_requests'), // Adjust the URL
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        // Parse and return the list of registration requests
        List<dynamic> requestsList = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(requestsList);
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return null;
      } else {
        // Ensure the widget is still mounted before showing the SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch registration requests.')),
          );
        }
        return null;
      }
    } catch (e) {
      
      // Ensure the widget is still mounted before showing the SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return null;
    }
  }
}
