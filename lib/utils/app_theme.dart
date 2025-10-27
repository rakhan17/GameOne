import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette - Yellow and Blue Theme
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color lightYellow = Color(0xFFFFF9E6);
  static const Color darkYellow = Color(0xFFFFB800);
  
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color accentBlue = Color(0xFF0D47A1);
  
  static const Color backgroundLight = Color(0xFFF5F8FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryYellow,
        surface: cardBackground,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardBackground,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryYellow,
        foregroundColor: textPrimary,
        elevation: 6,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightBlue,
        selectedColor: primaryBlue,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBlue.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Gradient decorations
  static BoxDecoration get gradientBackground {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryBlue.withOpacity(0.1),
          primaryYellow.withOpacity(0.1),
        ],
      ),
    );
  }

  static BoxDecoration cardGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        lightBlue.withOpacity(0.3),
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
