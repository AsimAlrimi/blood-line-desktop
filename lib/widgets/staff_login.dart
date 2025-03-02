import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/pages/forgot_password_page.dart';
import 'package:blood_line_desktop/services/login_logic.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';

class StaffLogin extends StatelessWidget {
  final String userType;

  StaffLogin({required this.userType});

  // Controllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form key to handle validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            color: AppTheme.white,
            elevation: 0.01,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width:  screenWidth*1 ,
                height: screenHeight*0.65,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$userType Login", style: AppTheme.h1()),
                      const SizedBox(height: 6),
                      Text("Please Enter Your Email & Password", style: AppTheme.instruction()),
                      const SizedBox(height: 30),
                      Text("Email", style: AppTheme.h3()),
                      const SizedBox(height: 10),
                      CustomTextfieldLoginpage(
                        controller: emailController,
                        hintText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text("Password", style: AppTheme.h3()),
                      const SizedBox(height: 10),
                      CustomTextfieldLoginpage(
                        controller: passwordController,
                        hintText: "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Bayan Add Text forgot password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ForgotPasswordPage();
                              },
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style:AppTheme.instructionRed,
                          ),
                        ),
                      ),
                      // ****

                      const SizedBox(height: 12),

                      CustomButtonLoginpage(
                        text: "Login",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, attempt to log in
                            bool success = await LoginLogic.login(
                              context,
                              emailController.text,
                              passwordController.text,
                            );
                            if (success) {
                              // Perform additional actions on successful login if needed
                              print("Login successful");
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
