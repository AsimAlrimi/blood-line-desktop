import 'package:blood_line_desktop/pages/logo_page.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_desktop/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds, then navigate to the LoginPage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LogoPage();
  }
}
