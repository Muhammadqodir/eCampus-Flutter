import 'package:flutter/material.dart';

const primaryColor = Color(0xFF009AD1);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  fontFamily: 'Montserrat',
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Colors.black87,
      fontSize: 20,
    ),
    titleSmall: TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    )
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  )
);