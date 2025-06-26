import 'package:flutter/material.dart';

// Enum to define the possible theme modes: light, dark, or system default.
enum ThemeModeType { light, dark, system }

/// ThemeViewModel manages the current theme mode of the application.
/// It extends ChangeNotifier to notify widgets when the theme changes,
/// allowing the UI to react and rebuild with the new theme.
class ThemeViewModel extends ChangeNotifier {
  // Private variable to hold the currently selected theme mode.
  // It defaults to system, meaning it will follow the device's theme settings.
  ThemeModeType _themeMode = ThemeModeType.system;

  // Public getter to access the current theme mode.
  ThemeModeType get themeMode => _themeMode;

  /// Sets the application's theme mode.
  /// Calls notifyListeners() to inform any listening widgets (like MaterialApp)
  /// to rebuild with the new theme settings.
  void setThemeMode(ThemeModeType mode) {
    if (_themeMode != mode) { // Only update if the mode has actually changed
      _themeMode = mode;
      notifyListeners(); // Tell the UI to update
      print('Theme changed to: $_themeMode'); // For debugging
    }
  }

  /// Converts the ThemeModeType enum to Flutter's built-in ThemeMode enum.
  /// This is used directly by the MaterialApp widget.
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return ThemeMode.system;
    }
  }
}
