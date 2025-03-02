import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BloodInventoryService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://localhost:5000';

  /// Fetch blood inventory for the staff's associated blood bank
  static Future<List<Map<String, dynamic>>?> fetchBloodInventory(BuildContext context) async {
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
        return null;
      }

      // Make GET request
      final response = await http.get(
        Uri.parse('$_baseUrl/blood_inventory'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['inventory'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else if (response.statusCode == 401) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch inventory: ${response.statusCode}')),
          );
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return null;
    }
    return null;
  }

    /// Take specific units of a blood type from the inventory
  static Future<bool> takeBloodUnits(
    BuildContext context,
    String bloodType,
    int quantity,
  ) async {
    try {
      // Retrieve access token from secure storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please log in again.')),
          );
        }
        return false;
      }

      // Prepare request body
      final requestBody = jsonEncode({
        'blood_type': bloodType,
        'quantity': quantity,
      });

      // Make POST request
      final response = await http.post(
        Uri.parse('$_baseUrl/blood_inventory/take'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
        body: requestBody,
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Operation successful')),
          );
        }
        return true;
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorData['error'] ?? 'Request failed')),
          );
        }
        return false;
      } else if (response.statusCode == 401) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        return false;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to take blood units: ${response.statusCode}')),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }


   /// Create a new blood need
static Future<bool> createBloodNeed(
  BuildContext context, {
  required String bloodType, // Changed to a single string
  required int units,
  required String location,
  required String expireDate,
  required String expireTime,
}) async {
  try {
    // Retrieve access token from secure storage
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) {
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access token not found. Please log in again.')),
        );
      }
      return false;
    }

    // Prepare request body
    final requestBody = jsonEncode({
      'bloodTypes': bloodType, // Send as a single string
      'units': units,
      'location': location,
      'expireDate': expireDate,
      'expireTime': expireTime,
    });

    // Make POST request
    final response = await http.post(
      Uri.parse('$_baseUrl/blood_need'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Attach JWT token
      },
      body: requestBody,
    );

    // Handle response
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Blood need created successfully')),
        );
      }
      return true;
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Bad request')),
        );
      }
      return false;
    } else if (response.statusCode == 403) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized access')),
        );
      }
      return false;
    } else if (response.statusCode == 404) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blood bank not found')),
        );
      }
      return false;
    } else if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
      return false;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create blood need: ${response.statusCode}')),
        );
      }
      return false;
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
    return false;
  }
}



}
