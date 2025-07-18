// lib/utils/app_themes.dart
import 'package:flutter/material.dart';

// --- Custom Color Palettes ---
// Defining custom color palettes ensures consistency across light and dark themes.
// These are not the actual primary/secondary colors for ThemeData directly,
// but rather the base colors we'll use to build our color schemes.

// Light Mode Colors
class AppColorsLight {
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.lightBlueAccent;
  static const Color textColor = Colors.black87;
  static const Color subTextColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color deleteColor = Colors.red;
  static const Color editColor = Colors.blueGrey;
  static const Color wishTaskColor = Color(0xFF9C27B0); // Deep Purple for Wish Task
}

// Dark Mode Colors
class AppColorsDark {
  static const Color primaryColor = Colors.blueGrey; // A different primary for dark mode
  static const Color accentColor = Colors.cyan;
  static const Color textColor = Colors.white;
  static const Color subTextColor = Colors.grey;
  static const Color backgroundColor = Color(0xFF121212); // Darker background
  static const Color cardColor = Color(0xFF1E1E1E); // Darker card background
  static const Color deleteColor = Colors.redAccent; // More visible red for dark mode
  static const Color editColor = Colors.lightBlue;
  static const Color wishTaskColor = Color(0xFFCE93D8); // Lighter purple for dark mode contrast
}

// --- Custom Text Styles ---
// Defining consistent text styles for headings, body text, etc.
// The fontFamily is removed to use default Material Design font,
// allowing system-wide font changes or Material 3 defaults to apply.
class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  );
}

// --- App Themes Definition ---
// This class provides the light and dark ThemeData objects.
class AppThemes {
  // Light Theme Configuration
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      // `primaryColor` is deprecated, prefer `colorScheme.primary`
      primaryColor: AppColorsLight.primaryColor,
      scaffoldBackgroundColor: AppColorsLight.backgroundColor,
      cardColor: AppColorsLight.cardColor,
      // Define ColorScheme based on our custom light colors
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsLight.primaryColor,
        brightness: Brightness.light,
        primary: AppColorsLight.primaryColor,
        secondary: AppColorsLight.accentColor,
        onPrimary: AppColorsLight.textColor, // Text on primary background
        onSecondary: AppColorsLight.textColor, // Text on secondary background
        surface: AppColorsLight.cardColor, // Color of surfaces like cards
        onSurface: AppColorsLight.textColor, // Text on surface
        background: AppColorsLight.backgroundColor, // Scaffold background
        onBackground: AppColorsLight.textColor, // Text on background
        error: AppColorsLight.deleteColor, // Error indicators
        onError: Colors.white, // Text on error background
      ),
      // Define AppBarTheme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsLight.primaryColor,
        foregroundColor: AppColorsLight.textColor, // Text/icon color on app bar
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColorsLight.textColor),
      ),
      // Define TextTheme using our custom styles
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColorsLight.textColor),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColorsLight.textColor),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColorsLight.textColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColorsLight.textColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColorsLight.textColor),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColorsLight.subTextColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorsLight.primaryColor,
        foregroundColor: Colors.white,
      ),
      // CORRECTED: TextButtonThemeData needs style property with ButtonStyle
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsLight.primaryColor, // Default text color for text buttons
          textStyle: AppTextStyles.bodyMedium, // Use TextStyle here
        ),
      ),
      cardTheme: CardThemeData( // Reverted to CardThemeData
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      listTileTheme: ListTileThemeData(
        textColor: AppColorsLight.textColor,
      ),
      dialogTheme: DialogThemeData( // Reverted to DialogThemeData
        backgroundColor: AppColorsLight.backgroundColor,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColorsLight.textColor),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColorsLight.textColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  // Dark Theme Configuration
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColorsDark.primaryColor,
      scaffoldBackgroundColor: AppColorsDark.backgroundColor,
      cardColor: AppColorsDark.cardColor,
      // Define ColorScheme based on our custom dark colors
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsDark.primaryColor,
        brightness: Brightness.dark,
        primary: AppColorsDark.primaryColor,
        secondary: AppColorsDark.accentColor,
        onPrimary: AppColorsDark.textColor,
        onSecondary: AppColorsDark.textColor,
        surface: AppColorsDark.cardColor,
        onSurface: AppColorsDark.textColor,
        background: AppColorsDark.backgroundColor,
        onBackground: AppColorsDark.textColor,
        error: AppColorsDark.deleteColor,
        onError: Colors.black,
      ),
      // Define AppBarTheme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsDark.primaryColor,
        foregroundColor: AppColorsDark.textColor,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColorsDark.textColor),
      ),
      // Define TextTheme using our custom styles
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColorsDark.textColor),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColorsDark.textColor),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColorsDark.textColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColorsDark.textColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColorsDark.textColor),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColorsDark.subTextColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorsDark.primaryColor,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDark.primaryColor,
          textStyle: AppTextStyles.bodyMedium, // Use TextStyle here
        ),
      ),
      cardTheme: CardThemeData( // Reverted to CardThemeData
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      listTileTheme: ListTileThemeData(
        textColor: AppColorsDark.textColor,
      ),
      dialogTheme: DialogThemeData( // Reverted to DialogThemeData
        backgroundColor: AppColorsDark.backgroundColor,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColorsDark.textColor),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColorsDark.textColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}

// --- Dimensions (Dimens) in Flutter ---
// Instead of separate XMLs, we define common spacing, font sizes, etc., as constants.
// This file can be expanded with more layout constants as needed.
class AppDimens {
  // Layout & Padding
  static const double screenPadding = 16.0;
  static const double cardMargin = 12.0; // Margin between cards
  static const double listItemPadding = 16.0; // Horizontal padding for list items
  static const double cardInternalVerticalPadding = 14.0; // Adjusted base (was 16.0)

  // Card Appearance
  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 10.0;

  // Icon Sizes
  static const double iconSize = 24.0;

  // FAB Dimensions
  static const double fabSize = 60.0; // Diameter of the FAB
  static const double fabIconSize = 28.0; // Size of the icon inside the FAB

  // Tag Dimensions
  static const double tagHorizontalPadding = 10.0; // Padding inside tags horizontally
  static const double tagVerticalPadding = 4.0; // Padding inside tags vertically
  static const double tagSpacing = 6.0; // Horizontal space between tags in a Wrap
  static const double tagRunSpacing = 4.0; // Vertical space if tags wrap

  // Social Icons
  static const double socialIconSize = 48.0;
  static const double socialIconPadding = 8.0;

  // Spacing Constants (Generic)
  static const double extraSmallGap = 2.0;
  static const double smallGap = 4.0;
  static const double mediumGap = 6.0;
  static const double largeGap = 8.0;

  // Form Spacing (used in Login/Register)
  static const double formTopSpacing = 32.0;
  static const double fieldSpacing = 16.0;
  static const double titleTopSpacing = 24.0;
  static const double titleBottomSpacing = 8.0;
  static const double dividerSpacing = 32.0;
  static const double dividerTextPadding = 12.0;

  // Button Sizes
  static const double buttonHeight = 48.0;

  // Radius
  static const double borderRadius = 12.0;

  // Custom additions for Login/Register
  static const double paddingTopAfterStatusBar = 16.0;
}
