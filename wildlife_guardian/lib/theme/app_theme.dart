import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // VS Code dark theme colors
  static const Color primaryDark = Color(0xFF1E1E1E);
  static const Color secondaryDark = Color(0xFF252526);
  static const Color tertiaryDark = Color(0xFF333333);
  
  // Accent colors
  static const Color accentGreen = Color(0xFF3DDC84);  // Neon Green
  static const Color accentBlue = Color(0xFF00B8D4);   // Neon Blue
  static const Color accentOrange = Color(0xFFFF9800); // Orange
  static const Color warningRed = Color(0xFFF44336);   // Warning Red
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCCCCCC);
  static const Color textMuted = Color(0xFF8E8E8E);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: accentGreen,
      secondary: accentBlue,
      tertiary: accentOrange,
      background: primaryDark,
      surface: secondaryDark,
      error: warningRed,
    ),
    scaffoldBackgroundColor: primaryDark,
    cardColor: secondaryDark,
    dividerColor: tertiaryDark,
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(color: textPrimary),
        displayMedium: const TextStyle(color: textPrimary),
        displaySmall: const TextStyle(color: textPrimary),
        headlineLarge: const TextStyle(color: textPrimary),
        headlineMedium: const TextStyle(color: textPrimary),
        headlineSmall: const TextStyle(color: textPrimary),
        titleLarge: const TextStyle(color: textPrimary),
        titleMedium: const TextStyle(color: textPrimary),
        titleSmall: const TextStyle(color: textPrimary),
        bodyLarge: const TextStyle(color: textSecondary),
        bodyMedium: const TextStyle(color: textSecondary),
        bodySmall: const TextStyle(color: textMuted),
        labelLarge: const TextStyle(color: textPrimary),
        labelMedium: const TextStyle(color: textSecondary),
        labelSmall: const TextStyle(color: textMuted),
      ),
    ),
    
    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    
    // Card theme
    cardTheme: CardTheme(
      color: secondaryDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tertiaryDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentBlue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: textMuted),
    ),
    
    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textPrimary,
        backgroundColor: accentGreen,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: accentBlue, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Icon theme
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: 24,
    ),
    
    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: secondaryDark,
      selectedItemColor: accentGreen,
      unselectedItemColor: textMuted,
      selectedIconTheme: IconThemeData(size: 26),
      unselectedIconTheme: IconThemeData(size: 24),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentGreen,
      foregroundColor: textPrimary,
      elevation: 4,
    ),
    
    // List tile theme
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: textSecondary,
      textColor: textPrimary,
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      color: tertiaryDark,
      thickness: 1,
      space: 1,
    ),
    
    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: tertiaryDark,
      contentTextStyle: const TextStyle(color: textSecondary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
  );

  // Button Styles
  static ButtonStyle gradientButtonStyle({
    Color startColor = accentGreen,
    Color endColor = accentBlue,
    double borderRadius = 8.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(padding),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      elevation: MaterialStateProperty.all(0),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.1);
          }
          return null;
        },
      ),
    );
  }

  // Gradient Widget
  static Widget gradientButton({
    required Widget child,
    required VoidCallback onPressed,
    Color startColor = accentGreen,
    Color endColor = accentBlue,
    double borderRadius = 8.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: gradientButtonStyle(
          startColor: startColor,
          endColor: endColor,
          borderRadius: borderRadius,
          padding: padding,
        ),
        child: child,
      ),
    );
  }
} 