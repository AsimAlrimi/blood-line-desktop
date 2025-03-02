import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ManagerGetStaff {
  static final _storage = const FlutterSecureStorage();

  static Future<List<Map<String, dynamic>>?> fetchStaffMembers(BuildContext context) async {
    try {
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

      final response = await http.get(
        Uri.parse('http://localhost:5000/get-staff'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['staff']);
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return null;
      } else {
        print('Failed to load staff members.');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load staff members.')),
          );
        }
        return null;
      }
    } catch (e) {
      print('Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while fetching staff members.')),
        );
      }
      return null;
    }
  }

  static Future<bool> deleteStaffMember(BuildContext context, int staffId) async {
    try {
      String? accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        print('No access token found.');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No access token found. Please log in again.')),
          );
        }
        return false;
      }

      final response = await http.delete(
        Uri.parse('http://localhost:5000/delete-staff/$staffId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Staff member deleted successfully')),
          );
        }
        return true;
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return false;
      } else {
        print('Failed to delete staff member.');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete staff member.')),
          );
        }
        return false;
      }
    } catch (e) {
      print('Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while deleting the staff member.')),
        );
      }
      return false;
    }
  }
}
