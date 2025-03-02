import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:blood_line_desktop/services/registration_requist_post.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/backround_decoration.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:blood_line_desktop/widgets/map_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class RequestRegistrationPage extends StatefulWidget {
  RequestRegistrationPage({super.key});

  @override
  State<RequestRegistrationPage> createState() => _RequestRegistrationPageState();
}

class _RequestRegistrationPageState extends State<RequestRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _organizationName = TextEditingController();
  final TextEditingController _contactInfo = TextEditingController();
  final TextEditingController _managerName = TextEditingController();
  final TextEditingController _managerPosition = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _startHour = TextEditingController();
  final TextEditingController _closeHour = TextEditingController();

  late double _latitude = 0.0;
  late double _longitude = 0.0;

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String organizationName = _organizationName.text;
      final String contactInfo = _contactInfo.text;
      final String managerName = _managerName.text;
      final String managerPosition = _managerPosition.text;
      final String managerEmail = _emailController.text;
      final String startHour = _startHour.text;
      final String closeHour= _closeHour.text;

      if (_latitude == 0 || _longitude ==0){
          if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You need to select location')),
          );
        }
      }

      else{
        bool success = await RegistrationRequestPost.sendRegistrationRequest(
          context,
          organizationName,
          contactInfo,
          managerName,
          managerPosition,
          managerEmail,
          startHour,
          closeHour,
          _latitude,
          _longitude,
        );

        if (!success) {
          print('Register failed');
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundDecorations(),
          Positioned(
            top: 30, // Adjust the position to suit your design
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.red, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.loginPage); // Navigate back to the previous page (LoginPage)
              },
            ),
          ),
          Center(
            child: Container(
              width:  screenWidth*0.9 ,
              height: screenHeight*0.80,
              // width: 1028,
              // height: 570,
              color: Colors.transparent,
              child: Card(
                elevation: 0.2,
                color: AppTheme.lightwhite,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView( // Wrap content with SingleChildScrollView to prevent overflow
                    child: Row(
                      children: [
                        // Left Side (Organization's Details)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Request Registration", style: AppTheme.h1()),
                                const SizedBox(height: 10),
                                Text("Organization's Details", style: AppTheme.instruction()),
                                const SizedBox(height: 10),

                                // Organization Name Field
                                Text("Organization Name", style: AppTheme.h3()),
                                const SizedBox(height: 8),
                                CustomTextfieldLoginpage(
                                  hintText: "Name",
                                  controller: _organizationName,
                                  validator: (value) =>
                                      value == null || value.isEmpty ? "Please enter organization name" : null,
                                ),
                                const SizedBox(height: 10),

                                // Contact Information Field
                                Text("Contact Information", style: AppTheme.h3()),
                                const SizedBox(height: 8),
                                CustomTextfieldLoginpage(
                                  hintText: "Phone Number",
                                  controller: _contactInfo,
                                  validator: (value) =>
                                      value == null || value.isEmpty ? "Please enter contact information" : null,
                                ),
                                const SizedBox(height: 10),

                                // operating_Hours Field
                                Text("Operating Hours", style: AppTheme.h3()),
                                Text("24-Hour Time Format", style: AppTheme.instruction(),),
                                const SizedBox(height: 8),
                                Row(children: [
                                  CustomTextfieldLoginpage(hintText: "Start Hour: HH:MM", width: 210,
                                    controller: _startHour,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Start Hour" ;
                                      }
                                      try {
                                        DateFormat('HH:mm').parse(value); // Parse time without seconds
                                      } catch (e) {
                                        return 'Enter a valid time (HH:MM)';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(width: 30,),
                                  CustomTextfieldLoginpage(hintText: "Close Hour: HH:MM", width: 210,
                                      controller: _closeHour,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Close Hour" ;
                                      }
                                      try {
                                        DateFormat('HH:mm').parse(value); // Parse time without seconds
                                      } catch (e) {
                                        return 'Enter a valid time (HH:MM)';
                                      }
                                      return null;
                                    },
                                  )
                                ],),
                                const SizedBox(height: 10),
                                // Organization Address Field
                                Row(children: [
                                    Text("Organization Address", style: AppTheme.h3()),
                                    const SizedBox(width: 10),
                                    IconButton(
                                    icon: const Icon(Icons.location_on_outlined, color: AppTheme.red, size: 33.3),
                                    onPressed: (){     
                                        showDialog<Map<String, double>>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const MapDialog();
                                          },
                                        ).then((result) {
                                          if (result != null) {
                                            final latitude = result['latitude'];
                                            final longitude = result['longitude'];
                                            setState(() {
                                                _latitude = latitude!;
                                                _longitude = longitude!;
                                            });
                                            // Use the latitude and longitude values
                                            print("Selected Latitude: $latitude, Longitude: $longitude");
                                          } else {
                                            // Handle case when the user closes the dialog without selecting a location
                                            print("No location selected");
                                          }
                                        });
                                      },
                                    ),
                                ],),
                                Text(
                                  _latitude == 0.0 && _longitude == 0.0 
                                    ? "Not Selected" 
                                    : "Latitude: ${_latitude.toStringAsFixed(4)}, Longitude: ${_longitude.toStringAsFixed(4)}", 
                                  style: AppTheme.instruction(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 400,
                          color: AppTheme.grey.withOpacity(0.5),
                        ),
                        // Right Side (Manager's Details)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 60),
                                Text("Manager's Details", style: AppTheme.instruction()),
                                const SizedBox(height: 10),

                                // Manager Name Field
                                Text("Full Name", style: AppTheme.h3()),
                                const SizedBox(height: 8),
                                CustomTextfieldLoginpage(
                                  hintText: "Name",
                                  controller: _managerName,
                                  validator: (value) =>
                                      value == null || value.isEmpty ? "Please enter manager's name" : null,
                                ),
                                const SizedBox(height: 10),

                                // Manager Position Field
                                Text("Position/Title", style: AppTheme.h3()),
                                const SizedBox(height: 8),
                                CustomTextfieldLoginpage(
                                  hintText: "Position",
                                  controller: _managerPosition,
                                  validator: (value) =>
                                      value == null || value.isEmpty ? "Please enter manager's position" : null,
                                ),
                                const SizedBox(height: 10),

                                // Manager Email Field
                                Text("Email", style: AppTheme.h3()),
                                const SizedBox(height: 8),
                                CustomTextfieldLoginpage(
                                  hintText: "Email, Ex: manager@example.com",
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter an email";
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomButtonLoginpage(
                                    text: "Confirm",
                                    onPressed: _register,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
