import 'package:flutter/material.dart';

const primaryColor = Color(0xFF009AD1);
const lightGray = Color(0xFFcccccc);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  dividerColor: lightGray,
  fontFamily: 'Montserrat',
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.black87,
      fontSize: 12,
    ),
    bodyMedium: TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(
      color: Colors.black87,
      fontSize: 20,
    ),
    titleMedium:  TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    titleSmall: TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    headlineLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
);