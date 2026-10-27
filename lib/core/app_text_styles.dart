import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings & Branding (Poltawski Nowy)
  static TextStyle brandTitle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.primaryDark,
  }) {
    return GoogleFonts.poltawskiNowy(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Currency & Numerical Amounts (Roboto Slab)
  static TextStyle amount({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textBlack,
  }) {
    return GoogleFonts.robotoSlab(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle robotoSlab({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textDark,
  }) {
    return GoogleFonts.robotoSlab(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // UI, Buttons, Subtitles & Form Labels (Poppins)
  static TextStyle button({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color color = Colors.white,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textDark,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle caption({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textGrey,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

