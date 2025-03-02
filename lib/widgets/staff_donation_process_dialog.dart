import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/blood_type_drop_down.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:blood_line_desktop/services/donation_process_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StaffDonationProcessDialog extends StatefulWidget {
  final String donorName;
  final int AppointmentID;
  const StaffDonationProcessDialog({super.key, required this.donorName, required this.AppointmentID});

  @override
  _StaffDonationProcessDialogState createState() => _StaffDonationProcessDialogState();
}

class _StaffDonationProcessDialogState extends State<StaffDonationProcessDialog> {
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _bloodPulseController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _bloodAmountController = TextEditingController();
  
  final _formKey1 = GlobalKey<FormState>();  // Form key for step 1
  final _formKey2 = GlobalKey<FormState>();  // Form key for step 2

  int currentStep = 1;
  bool isLoading = false;

  // Custom number input formatter that allows decimal points
  static final _decimalInputFormatter = FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'));
  // Custom number input formatter that only allows integers
  static final _integerInputFormatter = FilteringTextInputFormatter.digitsOnly;

  String? validateBloodPressure(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood pressure is required';
    }
    return null;
  }

  String? validateTemperature(String? value) {
    if (value == null || value.isEmpty) {
      return 'Temperature is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    double temp = double.parse(value);
    if (temp < 35.0 || temp > 42.0) {
      return 'Temperature must be between 35.0°C and 42.0°C';
    }
    return null;
  }

  String? validateBloodPulse(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood pulse is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    double pulse = double.parse(value);
    if (pulse < 40.0 || pulse > 200.0) {
      return 'Blood pulse must be between 40 and 200';
    }
    return null;
  }

  String? validateBloodAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood amount is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid whole number';
    }
    int amount = int.parse(value);
    if (amount < 1 || amount > 10) {
      return 'Blood amount must be between 1 and 10 units';
    }
    return null;
  }

  @override
  void dispose() {
    _bloodPressureController.dispose();
    _temperatureController.dispose();
    _bloodPulseController.dispose();
    _bloodTypeController.dispose();
    _bloodAmountController.dispose();
    super.dispose();
  }

  Future<void> _completeAppointment() async {
    setState(() {
      isLoading = true;
    });

    final appointmentData = {
      'blood_pressure': _bloodPressureController.text,
      'donor_temperature': double.tryParse(_temperatureController.text),
      'donor_blood_pulse': double.tryParse(_bloodPulseController.text),
      'blood_type': _bloodTypeController.text,
      'quantity_donated': int.tryParse(_bloodAmountController.text),
    };

    final success = await DonationProcessServices.completeAppointment(
      context,
      widget.AppointmentID,
      appointmentData,
    );

    if (success) {
      Navigator.of(context).pop();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: screenWidth * 0.5,
        height: screenHeight * 0.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Donation Process", style: AppTheme.h2()),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(1, currentStep >= 1),
                  _buildStepLine(),
                  _buildStepIndicator(2, currentStep >= 2),
                  _buildStepLine(),
                  _buildStepIndicator(3, currentStep >= 3),
                ],
              ),
              const SizedBox(height: 20),
              if (currentStep == 1) _buildStep1(),
              if (currentStep == 2) _buildStep2(),
              if (currentStep == 3) _buildStep3(),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.donorName, style: AppTheme.h2()),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextfieldLoginpage(
                    hintText: "Blood pressure",
                    controller: _bloodPressureController,
                    width: 300,
                    validator: validateBloodPressure,
                  ),
                  CustomTextfieldLoginpage(
                    hintText: "Temperature",
                    controller: _temperatureController,
                    width: 300,
                    validator: validateTemperature,
                    inputFormatters: [_decimalInputFormatter],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextfieldLoginpage(
                    hintText: "Blood pulse",
                    controller: _bloodPulseController,
                    width: 300,
                    validator: validateBloodPulse,
                    inputFormatters: [_decimalInputFormatter],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  BloodTypeDropdown(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Blood Type is required';
                      }
                      return null;
                    },
                    hintText: "Blood Type",
                    onChanged: (value) {
                      setState(() {
                        _bloodTypeController.text = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtonLoginpage(
                text: "Back",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 5),
              CustomButtonLoginpage(
                text: "Continue",
                onPressed: () {
                  if (_formKey1.currentState!.validate()) {
                    setState(() {
                      currentStep++;
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.donorName, style: AppTheme.h2()),
          const SizedBox(height: 10),
          Text("How many units of whole blood?", style: AppTheme.h4(color: AppTheme.black)),
          Text("One unit of whole blood (approximately 450 mL to 500 mL)", style: AppTheme.instruction()),
          const SizedBox(height: 10),
          CustomTextfieldLoginpage(
            hintText: "",
            controller: _bloodAmountController,
            width: 300,
            validator: validateBloodAmount,
            inputFormatters: [_integerInputFormatter],
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtonLoginpage(
                text: "Back",
                onPressed: () {
                  setState(() {
                    currentStep--;
                  });
                },
              ),
              const SizedBox(width: 5),
              CustomButtonLoginpage(
                text: "Continue",
                onPressed: () {
                  if (_formKey2.currentState!.validate()) {
                    setState(() {
                      currentStep++;
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.donorName, style: AppTheme.h2()),
        const SizedBox(height: 10),
        Text("Donation Complete Successfully", style: AppTheme.h4(color: AppTheme.black)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonLoginpage(
              text: "Back",
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
            ),
            const SizedBox(width: 5),
            CustomButtonLoginpage(
              text: "Finish",
              onPressed: _completeAppointment,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActive ? AppTheme.red : Colors.grey,
      child: Text(
        "$step",
        style: const TextStyle(color: AppTheme.white),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 2,
      color: AppTheme.grey,
    );
  }
}