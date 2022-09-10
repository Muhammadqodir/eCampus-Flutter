import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF009AD1);
const colorAccent = Color(0xFFE1F2F0);
const lightGray = Color(0xFFcccccc);

BoxShadow shadow = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  spreadRadius: 0.4,
  blurRadius: 1,
  offset: const Offset(0, 1),
);
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  secondaryHeaderColor: colorAccent,
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
    titleMedium: TextStyle(
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

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  secondaryHeaderColor: HexColor.fromHex("#1E1E1E"),
  dividerColor: HexColor.fromHex("#515151"),
  fontFamily: 'Montserrat',
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
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
  scaffoldBackgroundColor: HexColor.fromHex("#121212"),
  appBarTheme: AppBarTheme(
    backgroundColor: HexColor.fromHex("#121212"),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor.fromHex("#121212"),
    elevation: 0,
  ),
);
