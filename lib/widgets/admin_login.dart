import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/pages/forgot_password_page.dart';
import 'package:blood_line_desktop/services/login_logic.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  final String userType;

  AdminLogin({required this.userType});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {  // Validate the form
      final String email = _emailController.text;
      final String password = _passwordController.text;

      bool success = await LoginLogic.login(context, email, password);

      if (!success) {
        print('Login failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            color: Colors.white,
            elevation: 0.01,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width:  screenWidth*1 ,
                height: screenHeight*0.65,
                child: Form(  // Wrap the form fields with a Form widget
                  key: _formKey,  // Assign the form key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("${widget.userType} Login", style: AppTheme.h1()),
                      const SizedBox(height: 6),
                      Text("Please Enter Your Username & Password", style: AppTheme.instruction()),
                      const SizedBox(height: 30),
                      Text("Email", style: AppTheme.h3()),
                      const SizedBox(height: 10),
                      
                      CustomTextfieldLoginpage(
                        controller: _emailController,
                        hintText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text("Password", style: AppTheme.h3()),
                      const SizedBox(height: 10),
                      CustomTextfieldLoginpage(
                        controller: _passwordController,
                        hintText: "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
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
                        onPressed: _login, // Trigger the login logic
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
