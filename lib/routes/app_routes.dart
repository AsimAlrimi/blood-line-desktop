import 'package:blood_line_desktop/pages/Admin/admin_main_screen.dart';
import 'package:blood_line_desktop/pages/Manager/manager_main_screen.dart';
import 'package:blood_line_desktop/pages/Manager/requist_registeration_page.dart';
import 'package:blood_line_desktop/pages/Staff/appointments_list_page.dart';
import 'package:blood_line_desktop/pages/Staff/blood_group_page.dart';
import 'package:blood_line_desktop/pages/Staff/donation_process_page.dart';
import 'package:blood_line_desktop/pages/Staff/donor_list_page.dart';
import 'package:blood_line_desktop/pages/Staff/events_page.dart';
import 'package:blood_line_desktop/pages/Staff/staff_main_screen.dart';
import 'package:blood_line_desktop/pages/profile_page.dart';
import 'package:blood_line_desktop/pages/forgot_password_page.dart';
import 'package:blood_line_desktop/pages/login_page.dart';
import 'package:blood_line_desktop/pages/test.dart';
import 'package:blood_line_desktop/widgets/staff_donation_process_dialog.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_desktop/pages/logo_page.dart';

class AppRoutes{
  static String test = "/test";
  static String logoPage = "/logoPage";
  static String loginPage = "/LoginPage";
  static String requistRegisterationPage = "/requistRegisterationPage";
  static String staffMainScreem = "/staffMainScreem";
  static String magerMainScreen = "/magerMainScreen";
  static String adminMainScteen = "/adminMainScteen";
  static String forgotpasswordpage= "/forgotpasswordpage";
  static String appointmentslistpage= "/appointmentslistpage";
  static String donationprocessPage= "/donationprocessPage";
  static String staffdonationprocessdialog= "/staffdonationprocessdialog";
  static String eventspage= "/eventspage";
  static String bloodgrouppage= "/bloodgrouppage";
  static String donorlistPage= "/donorlistPage";
  static String staffprofilepage= "/staffprofilepage";




  static Map<String, WidgetBuilder> routes = {
    test: (context) => const Test(),
    logoPage: (context) => const LogoPage(),
    loginPage:(context) => const LoginPage(),
    requistRegisterationPage: (context) => RequestRegistrationPage(),
    staffMainScreem: (context) =>  StaffMainScreen(),
    magerMainScreen: (context) => ManagerMainScreen(),
    adminMainScteen: (context) => AdminMainScreen(),
    forgotpasswordpage:(context) => ForgotPasswordPage(),
    appointmentslistpage:(context)=>AppointmentsListPage(),
    donationprocessPage:(context)=>DonationProcessPage(),
    staffdonationprocessdialog:(context)=>StaffDonationProcessDialog(donorName: '', AppointmentID: 0,),
    eventspage:(context)=>EventsPage(),
    bloodgrouppage:(context)=>BloodGroupPage(),
    donorlistPage:(context)=>DonorListPage(),
    staffprofilepage:(context)=>ProfilePage(),
  };
}