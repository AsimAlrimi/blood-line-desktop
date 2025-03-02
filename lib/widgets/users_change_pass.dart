import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_desktop/services/users_change_pass_service.dart'; // Import the service

class UsersChangePass extends StatefulWidget {
  const UsersChangePass({super.key});

  @override
  State<UsersChangePass> createState() => _UsersChangePassState();
}

class _UsersChangePassState extends State<UsersChangePass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldpassController = TextEditingController();
  final TextEditingController _newpassController = TextEditingController();

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      bool success = await UsersChangePassService.changePassword(
        context,
        _oldpassController.text.trim(),
        _newpassController.text.trim(),
      );

      if (success) {
        Navigator.pop(context); // Close the dialog on success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: screenWidth * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Change Password", style: AppTheme.h2()),
                const SizedBox(height: 35.0),
                CustomTextfieldLoginpage(
                  isPassword: true,
                  hintText: "Old password",
                  controller: _oldpassController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Old password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  isPassword: true,
                  hintText: "New password",
                  controller: _newpassController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'New password is required';
                    }
                    if (value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Must contain an uppercase letter';
                    }
                    if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Must contain a lowercase letter';
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Must contain a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButtonLoginpage(
                  text: "Confirm",
                  onPressed: _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldpassController.dispose();
    _newpassController.dispose();
    super.dispose();
  }
}
