import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';

class CreateFaqDialog extends StatefulWidget {
  final Function(String question, String answer) onSave;

  const CreateFaqDialog({super.key, required this.onSave});

  @override
  State<CreateFaqDialog> createState() => _CreateFaqDialogState();
}

class _CreateFaqDialogState extends State<CreateFaqDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: screenWidth * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Create New FAQ", style: AppTheme.h2()),
                const SizedBox(height: 35.0),
                CustomTextfieldLoginpage(
                  hintText: "Question",
                  controller: _questionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Question is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Answer",
                  controller: _answerController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Answer is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButtonLoginpage(
                  text: "Add",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        _questionController.text.trim(),
                        _answerController.text.trim(),
                      );
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

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}