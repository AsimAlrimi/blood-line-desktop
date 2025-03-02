import 'package:blood_line_desktop/services/login_logic.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _codeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int currentStep = 1;
  bool isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _checkEmail() async {
    if (!_emailKey.currentState!.validate()) return;

    _setLoading(true);
    final String email = _emailController.text;
    
    try {
      bool? isEmailUsed = await LoginLogic.sendVerificationCode(context, email, false);
      
      if (!mounted) return;
      
      if (isEmailUsed == null) {
        _showSnackBar('Error sending verification code');
      } else if (isEmailUsed) {
        _showSnackBar('Email not found in our records');
      } else {
        setState(() => currentStep++);
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _verifyCode() async {
    if (!_codeKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      bool success = await LoginLogic.verifyCode(
        context, 
        _emailController.text, 
        _codeController.text
      );

      if (!mounted) return;

      if (success) {
        setState(() => currentStep++);
      } else {
        _showSnackBar('Invalid verification code');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_passwordKey.currentState!.validate()) return;
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    }

    _setLoading(true);
    try {
      bool success = await LoginLogic.updatePassword(
        context,
        _emailController.text,
        _passwordController.text
      );

      if (!mounted) return;

      if (success) {
        _showSnackBar('Password reset successfully');
        Navigator.of(context).pop();
      } else {
        _showSnackBar('Failed to reset password');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text("Forgot Your Password?", style: AppTheme.h2()),
                  const SizedBox(height: 20),
                  _buildStepIndicators(),
                  const SizedBox(height: 20),
                  if (currentStep == 1) _buildStep1(),
                  if (currentStep == 2) _buildStep2(),
                  if (currentStep == 3) _buildStep3(),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(1, currentStep >= 1),
        _buildStepLine(),
        _buildStepIndicator(2, currentStep >= 2),
        _buildStepLine(),
        _buildStepIndicator(3, currentStep >= 3),
      ],
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _emailKey,
      child: Column(
        children: [
          Text("Enter your registered email", style: AppTheme.h2()),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            hintText: "Ex: email@example.com",
            controller: _emailController,
            width: 300,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButtonLoginpage(
            text: "Send",
            onPressed: _checkEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _codeKey,
      child: Column(
        children: [
          Text("Verify Code", style: AppTheme.h2()),
          const SizedBox(height: 10),
          Text(
            "An authentication code has been sent to your email.",
            style: AppTheme.h4(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            hintText: "Enter Code",
            controller: _codeController,
            width: 300,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the verification code';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtonLoginpage(
                text: "Back",
                onPressed: () => setState(() => currentStep--),
              ),
              const SizedBox(width: 10),
              CustomButtonLoginpage(
                text: "Verify",
                onPressed: _verifyCode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _passwordKey,
      child: Column(
        children: [
          Text("Set a New Password", style: AppTheme.h2()),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            hintText: "Create New Password",
            controller: _passwordController,
            width: 300,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            hintText: "Re-enter Password",
            controller: _confirmPasswordController,
            width: 300,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButtonLoginpage(
            text: "Set Password",
            onPressed: _resetPassword,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActive ? AppTheme.red : Colors.grey,
      child: Text(
        "$step",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 2,
      color: AppTheme.grey,
    );
  }
}