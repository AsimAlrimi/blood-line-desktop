import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/admin_login.dart';
import 'package:blood_line_desktop/widgets/backround_decoration.dart';
import 'package:blood_line_desktop/widgets/staff_login.dart';
import 'package:blood_line_desktop/widgets/manager_login.dart';
import 'package:blood_line_desktop/widgets/user_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  final String initialUserType;

  const LoginPage({super.key, this.initialUserType = 'Staff'});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _selectedUserType;

  @override
  void initState() {
    super.initState();
    _selectedUserType = widget.initialUserType;
  }

  void _onUserTypeChanged(String newUserType) {
    setState(() {
      _selectedUserType = newUserType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundDecorations(),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 800;

                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: Card(
                    color: AppTheme.lightwhite,
                    elevation: 0.01,
                    margin: EdgeInsets.symmetric(
                      horizontal: isWideScreen ? 50.0 : 20.0,
                      vertical: 20.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: isWideScreen
                          ? Row(
                              children: <Widget>[
                                // Left Side - Logo
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Lottie.asset(
                                      'assets/animations/blood.json',
                                      width: 400,
                                      height: 400,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 1,
                                  height: double.infinity,
                                  color: AppTheme.grey.withOpacity(0.5),
                                ),

                                const SizedBox(width: 10.0),
                                // Right Side
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UserTypeSelector(
                                          initialUserType: _selectedUserType,
                                          onUserTypeChanged: _onUserTypeChanged,
                                        ),
                                        const SizedBox(height: 4),
                                        // Render the login card based on the selected user type
                                        if (_selectedUserType == "Staff")
                                          StaffLogin(userType: _selectedUserType)
                                        else if (_selectedUserType == "Manager")
                                          ManagerLogin(userType: _selectedUserType)
                                        else if (_selectedUserType == "Admin")
                                          AdminLogin(userType: _selectedUserType)

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                // Top Side - Logo
                                Container(
                                  alignment: Alignment.center,
                                  child: Lottie.asset(
                                    'assets/animations/blood.json',
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                const SizedBox(height: 20.0),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: AppTheme.grey.withOpacity(0.5),
                                ),

                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UserTypeSelector(
                                          initialUserType: _selectedUserType,
                                          onUserTypeChanged: _onUserTypeChanged,
                                        ),
                                        const SizedBox(height: 4),
                                        // Render the login card based on the selected user type
                                        if (_selectedUserType == "Staff")
                                          StaffLogin(userType: _selectedUserType)
                                        else if (_selectedUserType == "Manager")
                                          ManagerLogin(userType: _selectedUserType)
                                        else if (_selectedUserType == "Admin")
                                            AdminLogin(userType: _selectedUserType)

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
