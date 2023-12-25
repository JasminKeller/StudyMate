import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Dart/Ligt Mode Tutorial https://www.youtube.com/watch?v=-jdtfJe_sII

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    // ···
    titleLarge: GoogleFonts.oswald(
      fontSize: 30,
      fontStyle: FontStyle.normal,
    ),
    bodyMedium: GoogleFonts.roboto(),
    displaySmall: GoogleFonts.pacifico(),
  ),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    // ···
    titleLarge: GoogleFonts.oswald(
      fontSize: 30,
      fontStyle: FontStyle.normal,
    ),
    bodyMedium: GoogleFonts.roboto(),
    displaySmall: GoogleFonts.pacifico(),
  ),
  useMaterial3: true,
);