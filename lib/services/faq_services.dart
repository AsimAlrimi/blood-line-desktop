import 'dart:convert';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FaqService {
  static final _storage = const FlutterSecureStorage();
  static const String baseUrl = 'http://localhost:5000';

  /// Add a new FAQ
  static Future<bool> addFaq(BuildContext context, String question, String answer) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please login.')),
          );
        }
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/admin/add_faq'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'question': question, 'answer': answer}),
      );

      if (response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAQ added successfully')),
          );
        }
        return true;
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return false;
      }
       else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add FAQ: ${response.body}')),
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

  /// Fetch all FAQs
  static Future<List<Map<String, dynamic>>?> getFaqs(BuildContext context) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please login.')),
          );
        }
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/donor/faqs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['faqs']);
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return null;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch FAQs: ${response.body}')),
          );
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while fetching FAQs.')),
        );
      }
      return null;
    }
  }

  /// Delete an FAQ by its ID
  static Future<bool> deleteFaq(BuildContext context, int faqId) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access token not found. Please login.')),
          );
        }
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/delete_faq/$faqId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('FAQ with ID $faqId deleted successfully')),
          );
        }
        return true;
      }else if (response.statusCode == 401){
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
           return false;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete FAQ: ${response.body}')),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while deleting the FAQ.')),
        );
      }
      return false;
    }
  }
}
