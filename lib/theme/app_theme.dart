import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color red = Color(0xFFBC1F34);
  static const Color lightred = Color(0x33CF3045);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color white = Colors.white;
  static const Color lightwhite = Color.fromARGB(209, 255, 255, 255);
  static const Color grey = Color(0xFF757575);


  static TextStyle mainHeader({Color? color}) {
    return TextStyle(
      color: color ?? Colors.black, // Use provided color, fallback to black
      fontSize: 35,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle h1({Color? color}) {
    return TextStyle(
      color: color ?? Colors.black, // Use provided color, fallback to black
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle h2({Color? color}) {
    return TextStyle(
      color: color ?? Colors.black, // Use provided color, fallback to black
      fontSize: 22,
      fontWeight: FontWeight.w600, // Semi-bold
    );
  }

  static TextStyle h3({Color? color}) {
    return TextStyle(
      color: color ?? Colors.black, // Use provided color, fallback to black
      fontSize: 20,
      fontWeight: FontWeight.w500, // Medium weight
    );
  }

  static TextStyle h4({Color? color}) {
    return TextStyle(
      color: color ?? Colors.black, // Use provided color, fallback to black
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle instruction({Color? color}) {
    return TextStyle(
      color: color ?? Colors.grey, // Use provided color, fallback to grey
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
  }

  static const TextStyle instructionRed = TextStyle(
    color: red, // Gray color for instruction text
    fontSize: 14, // Slightly smaller font size for instructions
    fontWeight: FontWeight.normal, // Normal weight
  );


  static ThemeData lightTheme = ThemeData(

    cardTheme: CardTheme(
      color: lightwhite, // Set the default card color to white
      elevation: 0.1,
    ),

    scaffoldBackgroundColor: Colors.white,

    popupMenuTheme: PopupMenuThemeData(
      color: white, // Set background color of popup menu to white
      textStyle: TextStyle(color: black), // Set text color of popup menu to black
    ),

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: const Color.fromARGB(255, 187, 187, 187).withOpacity(0.5), // Highlight color when text is selected
      cursorColor: Colors.black,
      selectionHandleColor: const Color.fromARGB(255, 187, 187, 187).withOpacity(0.5), // Color of the selection handles
    ),

  );
}
