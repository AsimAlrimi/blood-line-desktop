import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/manager_staff_creation_post.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';

class ManagerAddStaffDialog extends StatefulWidget {
  const ManagerAddStaffDialog({super.key});

  @override
  _ManagerAddStaffDialogState createState() => _ManagerAddStaffDialogState();
}

class _ManagerAddStaffDialogState extends State<ManagerAddStaffDialog> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.red),
        );
      },
    );
    bool success = await StaffCreationService.createStaffMember(
      context,
      _fullNameController.text,
      _roleController.text,
      _emailController.text,
    );
    Navigator.of(context).pop();
    if (success) {
      Navigator.of(context).pop(); // Close the dialog
    } else {
      print("error");
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
        height: screenHeight * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Create Staff Account", style: AppTheme.h2()),
                const SizedBox(height: 35.0),
                CustomTextfieldLoginpage(
                  hintText: "Full Name",
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the full name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Role",
                  controller: _roleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the role.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Email",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address.';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButtonLoginpage(
                  text: "Confirm",
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
