import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfieldLoginpage extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? enabled;
  
  const CustomTextfieldLoginpage({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.width,
    this.inputFormatters,
    this.keyboardType,
    this.enabled,
  });

  @override
  _CustomTextfieldLoginpageState createState() => _CustomTextfieldLoginpageState();
}

class _CustomTextfieldLoginpageState extends State<CustomTextfieldLoginpage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 450,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscureText,
        enabled: widget.enabled,
        style: TextStyle(
          fontSize: 15.0,
          color: widget.enabled == false ? Colors.black : Colors.black,
        ),
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.enabled == false ? Colors.black : Colors.black54,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
        validator: widget.validator,
      ),
    );
  }
}