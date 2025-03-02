import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/blood_inventory_service.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BloodNeedDialog extends StatefulWidget {
  final String bloodType;

  const BloodNeedDialog({
    super.key,
    required this.bloodType,
  });

  @override
  State<BloodNeedDialog> createState() => _BloodNeedDialogState();
}

class _BloodNeedDialogState extends State<BloodNeedDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _bloodTypesController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _expireTimeController = TextEditingController();
  
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _bloodTypesController.text = widget.bloodType;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:  AppTheme.red,
              onPrimary: AppTheme.white,
              surface: AppTheme.white,
              onSurface: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _expireDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
                Text("Request Blood from Donors", style: AppTheme.h2()),
                const SizedBox(height: 35.0),
                Text(widget.bloodType),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Units Required",
                  controller: _unitsController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter required units';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Location",
                  controller: _locationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Date Picker Field
                InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: CustomTextfieldLoginpage(
                      hintText: "Select Expire Date",
                      controller: _expireDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the expiry date';
                        }
                        return null;
                      },
                    
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Time Picker Field
                CustomTextfieldLoginpage(
                  hintText: "Expire Time (HH:MM)",
                  controller: _expireTimeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the expiry time';
                    }
                    try {
                      DateFormat('HH:mm').parse(value);
                    } catch (e) {
                      return 'Please enter a valid time (HH:MM)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButtonLoginpage(
                  text: "Submit Request",
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final success = await BloodInventoryService.createBloodNeed(
                        context,
                        bloodType: widget.bloodType,
                        units: int.parse(_unitsController.text),
                        location: _locationController.text,
                        expireDate: _expireDateController.text,
                        expireTime: _expireTimeController.text,
                      );

                      if (success) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}