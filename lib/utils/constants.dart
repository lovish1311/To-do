/// Utility class to hold application-wide constants,
/// including Hive box names, routes, etc.
class AppConstants {
  // Hive Box Names
  static const String taskListBox = 'task_lists';
  static const String taskBox = 'tasks';

  static const String splashPath = '/';
  static const String indexPath = '/index';
  static const String calendarPath = '/calendar';
  static const String focusPath = '/focus';
  static const String profilePath = '/profile';
  static const String taskDetailPath = '/task-detail/:id';
  static const String loginPath = '/login';
  static const String registerPath = '/register';

  // Route Names (stringified for navigation and consistency)
  static const String splashRouteName = 'splash';
  static const String indexRouteName = 'index';
  static const String calendarRouteName = 'calendar';
  static const String focusRouteName = 'focus';
  static const String profileRouteName = 'profile';
  static const String taskDetailRouteName = 'taskDetail';
  static const String loginRouteName = 'login';
  static const String registerRouteName = 'register';

}

class AppSvg{
  static const String googleIconPath = 'assets/icons/google_icon.svg';
  static const String facebookIconPath = 'assets/icons/facebook_icon.svg';
  static const String appleIconPath = 'assets/icons/apple_icon.svg';
  static const String grootLogoPath = 'assets/icons/groot_logo.svg';
}