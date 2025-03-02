import 'package:blood_line_desktop/pages/Staff/appointments_list_page.dart';
import 'package:blood_line_desktop/pages/Staff/blood_group_page.dart';
import 'package:blood_line_desktop/pages/Staff/donation_process_page.dart';
import 'package:blood_line_desktop/pages/Staff/donor_list_page.dart';
import 'package:blood_line_desktop/pages/Staff/events_page.dart';
import 'package:blood_line_desktop/pages/Staff/staff_home_page.dart';
import 'package:blood_line_desktop/pages/Staff/staff_volunteers_page.dart';
import 'package:blood_line_desktop/pages/profile_page.dart';
import 'package:blood_line_desktop/pages/Staff/staff_sidebar.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StaffMainScreen extends StatefulWidget {
  @override
  _StaffMainScreenState createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int _selectedIndex = 0;

  // Lazy loading of pages: only initialize when needed
  final Map<int, Widget> _pages = {};

  Widget _getPage(int index) {
    if (!_pages.containsKey(index)) {
      // Only create the page when it's needed
      switch (index) {
        case 0:
          _pages[index] = StaffHomePage();
          break;
        case 1:
          _pages[index] = BloodGroupPage();
          break;
        case 2:
          _pages[index] = AppointmentsListPage();
          break;
        case 3:
          _pages[index] = DonorListPage();
          break;
        case 4:
          _pages[index] = DonationProcessPage();
          break;
        case 5:
          _pages[index] = EventsPage();
          break;
        case 6:
          _pages[index] = StaffVolunteersPage();
          break;
        case 7:
          _pages[index] = ProfilePage();
        // Add other pages here
      }
    }
    return _pages[index]!;
  }

  // Function to handle page change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.red, // Your custom red color from AppTheme
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            Flexible(
              child: StaffSidebar(
                onItemTapped: _onItemTapped,
                selectedIndex: _selectedIndex, // Pass selected index to highlight the selected menu item
              ),
            ),
            // Main Content Area
            Flexible(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: _getPage(_selectedIndex), // Lazy-loaded page
              ),
            ),
          ],
        ),
      ),
    );
  }
}
