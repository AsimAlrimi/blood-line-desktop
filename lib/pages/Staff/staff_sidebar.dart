import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/login_logic.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StaffSidebar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  StaffSidebar({required this.onItemTapped, required this.selectedIndex});

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 40,
            
            decoration: BoxDecoration(
              color: selectedIndex == index ? const Color.fromARGB(255, 255, 255, 255) : Colors.transparent, // Vertical line
              borderRadius: BorderRadius.all(
                Radius.circular(30)
              )
            ),
          ),
          SizedBox(width: 8), // Space between the line and the icon
          Icon(icon, color: AppTheme.white, size: 32),
        ],
      ),
      title: Text(title, style: AppTheme.instruction(color: AppTheme.white)),
      onTap: () => onItemTapped(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 28.0, bottom: 10.0), // Adjust spacing
          child: Column(
            children: [
              Image.asset("assets/images/logo.png", width: 110),
              SizedBox(height: 8), // Add spacing between logo and divider
              Container(child: Divider(color: AppTheme.lightwhite, thickness: 1), width: screenWidth*0.14,), // Add a white divider
            ],
          ),
        ),
        Flexible(
          child: ListView(
            children: [
              buildMenuItem(icon: Icons.home, title: "Home", index: 0),
              buildMenuItem(icon: Icons.water_drop, title: "Blood Groups", index: 1),
              buildMenuItem(icon: Icons.event_available_outlined, title: "Appointments", index: 2),
              buildMenuItem(icon: Icons.people_alt, title: "Donors", index: 3),
              buildMenuItem(icon: Icons.settings_suggest_sharp, title: "Donations", index: 4),
              buildMenuItem(icon: Icons.event_note_outlined, title: "Events", index: 5),
              buildMenuItem(icon: Icons.volunteer_activism_outlined, title: "Voluntters", index: 6),
              buildMenuItem(icon: Icons.account_circle_outlined, title: "Profile", index: 7),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout, color: AppTheme.white, size: 32),
          title: Text("Logout", style: AppTheme.instruction(color: AppTheme.white)),
          onTap: () {
            LoginLogic.logout(context);
          },
        ),
      ],
    );
  }
}
