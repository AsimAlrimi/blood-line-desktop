import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/user_profile_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:blood_line_desktop/widgets/users_change_pass.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool editModeOn = false;
  Map<String, dynamic>? userProfile;
  Map<String, String> changedFields = {};  // Track changed fields
  
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();

  // Store original values
  String? originalUsername;
  String? originalEmail;
  String? originalPhone;
  String? originalGender;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    _usernameController.addListener(() {
      _handleFieldChange('username', _usernameController.text, originalUsername);
    });
    _emailController.addListener(() {
      _handleFieldChange('email', _emailController.text, originalEmail);
    });
    _phoneController.addListener(() {
      _handleFieldChange('phone_number', _phoneController.text, originalPhone);
    });
    _genderController.addListener(() {
      _handleFieldChange('gender', _genderController.text, originalGender);
    });
  }

  void _handleFieldChange(String field, String newValue, String? originalValue) {
    if (editModeOn && newValue != originalValue) {
      changedFields[field] = newValue;
    } else {
      changedFields.remove(field);
    }
  }

  Future<void> _fetchUserProfile() async {
    final profile = await UserProfileService.fetchUserProfile(context);

    if (profile != null) {
      setState(() {
        userProfile = profile;
        
        // Store original values
        originalUsername = profile['username'] ?? '';
        originalEmail = profile['email'] ?? '';
        originalPhone = profile['phone_number'] ?? '';
        originalGender = profile['gender'] ?? '';

        // Set controller values
        _usernameController.text = originalUsername ?? '';
        _emailController.text = originalEmail ?? '';
        _phoneController.text = originalPhone ?? '';
        _genderController.text = originalGender ?? '';
      });
    }
  }

  void _resetToOriginalValues() {
    _usernameController.text = originalUsername ?? '';
    _emailController.text = originalEmail ?? '';
    _phoneController.text = originalPhone ?? '';
    _genderController.text = originalGender ?? '';
    changedFields.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(title: "Profile"),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.account_circle,
                size: 150,
                color: AppTheme.grey,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    CustomTextfieldLoginpage(
                      hintText: 'Username',
                      controller: _usernameController,
                      enabled: editModeOn,
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    CustomTextfieldLoginpage(
                      hintText: 'Email',
                      controller: _emailController,
                      enabled: editModeOn,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Phone Number",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    CustomTextfieldLoginpage(
                      hintText: 'Phone Number',
                      controller: _phoneController,
                      enabled: editModeOn,
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gender",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    CustomTextfieldLoginpage(
                      hintText: 'Gender',
                      controller: _genderController,
                      enabled: editModeOn,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 300),
              child: Column(
                children: [
                  editModeOn
                      ? Row(
                          children: [
                            CustomButtonLoginpage(
                              size: const Size(170, 40),
                              text: "Save",
                              onPressed: () async {
                                if (changedFields.isNotEmpty) {
                                  final success = await UserProfileService.updateUserProfile(
                                    context, 
                                    changedFields
                                  );
                                  print(changedFields);

                                  if (success) {
                                    await _fetchUserProfile();
                                    setState(() {
                                      editModeOn = false;
                                      changedFields.clear();
                                    });
                                  }
                                } else {
                                  setState(() {
                                    editModeOn = false;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            CustomButtonLoginpage(
                              size: const Size(170, 40),
                              backgroundColor: Colors.transparent,
                              text: "Cancel",
                              onPressed: () {
                                setState(() {
                                  editModeOn = false;
                                  _resetToOriginalValues();
                                });
                              },
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            CustomButtonLoginpage(
                              size: const Size(170, 40),
                              text: "Edit",
                              onPressed: () {
                                setState(() {
                                  editModeOn = true;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            CustomButtonLoginpage(
                              backgroundColor:  Colors.transparent,
                              text: "Change pass",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UsersChangePass();
                                  },
                                );
                              },
                              size: const Size(170, 40),
                            ),
                          ],
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}