import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventService {
  static final _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'http://localhost:5000';

  /// Create Event
  static Future<bool> createEvent(BuildContext context, Map<String, dynamic> eventData) async {
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

      // Make POST request
      final response = await http.post(
        Uri.parse('$_baseUrl/events'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach JWT token
        },
        body: jsonEncode(eventData),
      );

      // Handle response
      if (response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully.')),
          );
        }
        return true;
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
         
      } else if (response.statusCode == 403) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unauthorized access. Please log in again.')),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create event: ${response.statusCode}')),
          );
        }
        return false;
      }
       return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }
  /// Fetch Events
static Future<List<Map<String, dynamic>>?> fetchEvents(BuildContext context) async {
  try {
    // Retrieve access token from secure storage
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access token not found. Please log in again.')),
        );
      }
      return null;
    }

    // Make GET request
    final response = await http.get(
      Uri.parse('$_baseUrl/get/events'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Attach JWT token
      },
    );

    // Handle response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> events = data['events'];
      return events.map((event) => event as Map<String, dynamic>).toList();
    }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return null;
      } else if (response.statusCode == 403) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized access. Please log in again.')),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
      }
      return null;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch events: ${response.statusCode}')),
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
}
/// Delete Event
static Future<bool> deleteEvent(BuildContext context, int eventId) async {
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

    // Make DELETE request
    final response = await http.delete(
      Uri.parse('$_baseUrl/delete/events/$eventId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Attach JWT token
      },
    );

    // Handle response
    if (response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully.')),
        );
      }
      return true;
    }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return false;
      } else if (response.statusCode == 403) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized access. Please log in again.')),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
      }
      return false;
    } else if (response.statusCode == 404) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event not found or not authorized to delete.')),
        );
      }
      return false;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event: ${response.statusCode}')),
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
