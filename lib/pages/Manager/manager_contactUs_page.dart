import 'package:blood_line_desktop/services/contact_us_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';

class ManagerContactusPage extends StatefulWidget {
  const ManagerContactusPage({super.key});

  @override
  State<ManagerContactusPage> createState() => _ManagerContactusPageState();
}

class _ManagerContactusPageState extends State<ManagerContactusPage> {
  bool editModeOn = false;

  // Controllers for the text fields
  final _bloodBankController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _startHourController = TextEditingController();
  final _closeHourController = TextEditingController();
  final _managerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContactUsData();
  }

  Future<void> _loadContactUsData() async {
    final contactUsData = await ContactUsService.fetchContactUs(context);
    if (contactUsData != null) {
      setState(() {
        _bloodBankController.text = contactUsData['blood_bank'] ?? '';
        _addressController.text = contactUsData['address'] ?? '';
        _emailController.text = contactUsData['email'] ?? '';
        _phoneController.text = contactUsData['phone'] ?? '';
        _startHourController.text = contactUsData['start_hour'] ?? '';
        _closeHourController.text = contactUsData['close_hour'] ?? '';
        _managerController.text = contactUsData['manager'] ?? '';
      });
    }
  }

  Future<void> _saveContactUsData() async {
    final updatedData = {
      'blood_bank': _bloodBankController.text,
      'address': _addressController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'start_hour': _startHourController.text,
      'close_hour': _closeHourController.text,
      'manager': _managerController.text,
    };

    final success = await ContactUsService.updateContactUs(context, updatedData);
    if (success) {
      setState(() {
        editModeOn = false;
      });
    }
  }

  @override
  void dispose() {
    _bloodBankController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _startHourController.dispose();
    _closeHourController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeader(title: "Contact Us"),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildField("Blood Bank", _bloodBankController),
              const SizedBox(width: 20),
              _buildField("Phone Number", _phoneController),
              //_buildField("Address", _addressController),
            ],
          ),

          const SizedBox(height: 20),
          Text(
            "Operating Hours",
            style: AppTheme.h3(),
          ),
          Text(
            "24-Hour Time Format",
            style: AppTheme.instruction(),
          ),
          Row(
            children: [
              _buildField2("Start Hour", _startHourController),
              const SizedBox(width: 7),
              _buildField2("Close Hour", _closeHourController),
              const SizedBox(width: 20),
              _buildField("Email", _emailController),
              //_buildField("Manager", _managerController),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: editModeOn
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtonLoginpage(
                        text: "Save",
                        onPressed: _saveContactUsData,
                      ),
                      const SizedBox(width: 10),
                      CustomButtonLoginpage(
                        text: "Cancel",
                        onPressed: () {
                          setState(() {
                            editModeOn = false;
                          });
                        },
                      ),
                    ],
                  )
                : CustomButtonLoginpage(
                    text: "Edit",
                    onPressed: () {
                      setState(() {
                        editModeOn = true;
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            hintText: label,
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildField2(String label, TextEditingController controller) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            width: 220,
            hintText: label,
            controller: controller,
          ),
        ],
      ),
    );
  }
}
