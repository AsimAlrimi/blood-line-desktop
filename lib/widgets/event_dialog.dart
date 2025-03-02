import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/event_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDialog extends StatefulWidget {
  final VoidCallback onEventCreated;

  const EventDialog({super.key, required this.onEventCreated});

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.red, // Header background color
              onPrimary: AppTheme.white, // Header text color
              surface: AppTheme.white, // Dialog background color
              onSurface: AppTheme.black, // Calendar text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.red, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format the date as yyyy-MM-dd
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
                Text("Create New Event", style: AppTheme.h2()),
                const SizedBox(height: 35.0),
                CustomTextfieldLoginpage(
                  hintText: "Title",
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Description",
                  controller: _typeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event Description';
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
                      return 'Please enter the event location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: CustomTextfieldLoginpage(
                      hintText: "Select Event Date",
                      controller: _dateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the event date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomTextfieldLoginpage(
                  hintText: "Time (HH:MM)",
                  controller: _timeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event time';
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
                  text: "Add",
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final eventData = {
                        'title': _titleController.text,
                        'description': _typeController.text,
                        'location': _locationController.text,
                        'event_date': _dateController.text,
                        'event_time': _timeController.text,
                      };

                      bool success = await EventService.createEvent(context, eventData);

                      if (success) {
                        widget.onEventCreated();
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