import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFC9D5CFF);
  static const Color secondary = Color(0xFF1E1B33);
  static const Color tertiary = Color(0xFFD1C4E9);
  static const Color neutral = Color(0xFF0D0B14);
  static const Color muted = Color(0xFF968DA0);

  static const Color purple50 = Color(0xFFF5EFFF);
  static const Color purple100 = Color(0xFFE1CCFF);
  static const Color purple200 = Color(0xFFD2B4FF);
  static const Color purple300 = Color(0xFFBD92FF);
  static const Color purple400 = Color(0xFFB17DFF);
  static const Color purple500 = Color(0xFF9D5CFF);
  static const Color purple600 = Color(0xFF8F54E8);
  static const Color purple700 = Color(0xFF6F41B5);
  static const Color purple800 = Color(0xFF56338C);
  static const Color purple900 = Color(0xFF42276B);

  static const Color darkPurple50 = Color(0xFFE9E8EB);
  static const Color darkPurple100 = Color(0xFFBAB8C0);
  static const Color darkPurple200 = Color(0xFF9896A2);
  static const Color darkPurple300 = Color(0xFF696677);
  static const Color darkPurple400 = Color(0xFF4C495D);
  static const Color darkPurple500 = Color(0xFF1F1B34);
  static const Color darkPurple600 = Color(0xFF1C192F);
  static const Color darkPurple700 = Color(0xFF161325);
  static const Color darkPurple800 = Color(0xFF110F1D);
  static const Color darkPurple900 = Color(0xFF0D0B16);

  static const Color palePurple50 = Color(0xFFFAF9FD);
  static const Color palePurple100 = Color(0xFFF1EDF8);
  static const Color palePurple200 = Color(0xFFEAE4F5);
  static const Color palePurple300 = Color(0xFFE0D8F0);
  static const Color palePurple400 = Color(0xFFDAD1ED);
  static const Color palePurple500 = Color(0xFFD1C5E9);
  static const Color palePurple600 = Color(0xFFBEB3D4);
  static const Color palePurple700 = Color(0xFF948CA5);
  static const Color palePurple800 = Color(0xFF736C80);
  static const Color palePurple900 = Color(0xFF585362);

  static const Color neutral50 = Color(0xFFE7E7E8);
  static const Color neutral100 = Color(0xFFB4B3B6);
  static const Color neutral200 = Color(0xFF8F8F93);
  static const Color neutral300 = Color(0xFF5C5C62);
  static const Color neutral400 = Color(0xFF3D3C43);
  static const Color neutral500 = Color(0xFF000000);
  static const Color neutral600 = Color(0xFF0B0A12);
  static const Color neutral700 = Color(0xFF09080E);
  static const Color neutral800 = Color(0xFF07060B);
  static const Color neutral900 = Color(0xFF050508);
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.neutral,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.neutral,
        error: Colors.redAccent,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }
}
