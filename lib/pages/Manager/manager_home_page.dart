import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ManagerHomePage extends StatelessWidget {
  const ManagerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Manager Home Page',
        style:AppTheme.h1(),
      ),
    );
  }
}