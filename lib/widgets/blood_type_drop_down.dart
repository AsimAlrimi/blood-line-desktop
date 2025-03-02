import 'package:flutter/material.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';

class BloodTypeDropdown extends StatefulWidget {
  final String hintText;
  final double? width; // Optional width for custom sizing
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const BloodTypeDropdown({
    super.key,
    required this.hintText,
    this.width,
    this.validator,
    this.onChanged,
  });

  @override
  _BloodTypeDropdownState createState() => _BloodTypeDropdownState();
}

class _BloodTypeDropdownState extends State<BloodTypeDropdown> {
  String? _selectedBloodType;
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widget.width ?? 300,
      child: DropdownButtonFormField<String>(
        value: _selectedBloodType,
        onChanged: (String? newValue) {
          setState(() {
            _selectedBloodType = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
        validator: widget.validator,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.red, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        hint: Center(
          child: Text(
            widget.hintText,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black, // Placeholder text color
            ),
          ),
        ),
        items: _bloodTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16.0),
            ),
          );
        }).toList(),
      ),
    );
  }
}

