import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_ai_chat/constants/colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
      color: tDarkColor,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: tDarkColor,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: tSecondaryColor,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: tSecondaryColor,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: tDarkColor,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
      color: tWhiteColor,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: tWhiteColor,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: tWhiteColor,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: tWhiteColor,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: tWhiteColor,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );
}
