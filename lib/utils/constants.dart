/// Utility class to hold application-wide constants,
/// including Hive box names, routes, etc.
class AppConstants {
  // Hive Box Names
  static const String taskListBox = 'task_lists';
  static const String taskBox = 'tasks';

// Other constants can go here later, e.g.:
// static const String appName = 'My To-Do App';
// static const String defaultTheme = 'system';
  static const String indexPath        = '/tasks';
  static const String taskDetailPath  = '/tasks/:id';
  static const String calendarPath    = '/calendar';
  static const String focusPath       = '/focus';
  static const String profilePath     = '/profile';

}
class AppAssets {
  static const String _base = 'assets';
  static const String _icons = '$_base/icons';
  static const String _images = '$_base/images';

  // Icons
  static const String googleIcon = '$_icons/google_icon.svg';

  static String appleIcon='$_icons/apple_icon.svg';

  static String facebookIcon='$_icons/facebook_icon.svg';

// Add other icons or images below like:
// static const String appleIcon = '$_icons/apple_icon.svg';
// static const String loginBackground = '$_images/login_bg.png';
}