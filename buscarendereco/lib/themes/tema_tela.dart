import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.light().textTheme,
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade50,
    primary: const Color(0xFF375b8d),
    primaryFixed: Colors.white,
    secondary: Colors.blue.shade200,
    onTertiary: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.dark().textTheme,
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: const Color(0xFF132b4d),
    primaryFixed: Colors.white,
    secondary: Colors.blue.shade600,
    onTertiary: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade800,
  ),
);