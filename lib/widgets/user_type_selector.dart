import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:flutter/material.dart';

class UserTypeSelector extends StatefulWidget {
  final String initialUserType;
  final ValueChanged<String> onUserTypeChanged;

  UserTypeSelector({required this.initialUserType, required this.onUserTypeChanged});

  @override
  _UserTypeSelectorState createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  late String _selectedUserType;

  @override
  void initState() {
    super.initState();
    _selectedUserType = widget.initialUserType;
  }

  void _handleUserTypeChange(String userType) {
    setState(() {
      _selectedUserType = userType;
    });
    widget.onUserTypeChanged(userType);
  }

  Widget _buildUserType(String userType) {
    bool isSelected = _selectedUserType == userType;

    TextStyle textStyle = isSelected
        ? AppTheme.h4().copyWith(color: AppTheme.red, fontWeight: FontWeight.bold)
        : AppTheme.h4().copyWith(color: AppTheme.grey);

    return GestureDetector(
      onTap: () => _handleUserTypeChange(userType),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: <Widget>[
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 150),
              style: textStyle,
              child: Text(userType),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: Duration(milliseconds: 150),
              height: 4,
              width: isSelected ? 60 : 0,
              decoration: BoxDecoration(
                color: AppTheme.red,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: <Widget>[
            const SizedBox(width: 15),
            _buildUserType('Staff'),
            const SizedBox(width: 16),
            _buildUserType('Manager'),
            const SizedBox(width: 16),
            _buildUserType('Admin'),
            // const SizedBox(width: 16),
            // _buildUserType('ForgotPassword'),

          ],
        );
      },
    );
  }
}
