import 'package:flutter/material.dart';

class AppTheme {
  // الألوان الأساسية - موحدة مع بقية التطبيق
  static const Color primaryBlue = Color(0xFF2342B0); // اللون الأساسي للتطبيق
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningRed = Color(0xFFE74C3C);
  static const Color alertOrange = Color(0xFFF59E0B);
  static const Color lightBlue = Color(0xFF3B67F3); // اللون الفاتح الأساسي
  static const Color purpleBlue = Color(0xFF6366F1); // اللون البنفسجي المزرق
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF7F8C8D);
  
  // تدرجات الألوان
  static const Color acceptedStart = Color(0xFF10B981);
  static const Color acceptedEnd = Color(0xFF34D399);
  static const Color rejectedStart = Color(0xFFE74C3C);
  static const Color rejectedEnd = Color(0xFFF1948A);
  static const Color reviewStart = Color(0xFFF59E0B);
  static const Color reviewEnd = Color(0xFFFBBF24);
  static const Color stoppedStart = Color(0xFF6B7280);
  static const Color stoppedEnd = Color(0xFF9CA3AF);
  
  // ألوان النص
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnButton = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // fontFamily: 'Cairo', // سيتم استخدام الخط الافتراضي حتى يتم إضافة خط Cairo
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightBlue,
        primary: lightBlue,
        secondary: purpleBlue,
        error: warningRed,
        surface: lightGray,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: textOnButton,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            // fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 14,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          // fontFamily: 'Cairo',
          fontSize: 12,
          color: textSecondary,
        ),
      ),
    );
  }
}
