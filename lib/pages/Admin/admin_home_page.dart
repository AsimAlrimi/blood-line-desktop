import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomHeader(title: "Home"),
          Text(
            'Admin Home Page',
            style:AppTheme.instruction(),
          ),
        ],
      ),
    );
  }
}