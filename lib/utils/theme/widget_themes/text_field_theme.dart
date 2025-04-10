import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_ai_chat/constants/colors.dart';
import 'package:project_ai_chat/constants/sizes.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();
  
  static InputDecorationTheme lightInputDecorationTheme = const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: tSecondaryColor,
    floatingLabelStyle: TextStyle(color: tSecondaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: tSecondaryColor),
    )
  );

  static InputDecorationTheme darkInputDecorationTheme = const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: tPrimaryColor,
      floatingLabelStyle: TextStyle(color: tPrimaryColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: tPrimaryColor),
      )
  );
}
