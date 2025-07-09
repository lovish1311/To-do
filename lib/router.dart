// lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/views/screens/task_lists_screen.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:to_do/views/screens/app_shell.dart';
import 'package:to_do/utils/constants.dart'; // Assuming AppRoutes constants are defined here

// Utility widget for placeholder screens
Widget _todo(String title) => Scaffold(
  appBar: AppBar(title: Text(title)),
  body: Center(child: Text('$title Screen (TODO)')),
);

// Define your route names/paths in a constant class for clarity and type safety
// Example, adjust if your AppConstants or AppRoutes are different
class AppRoutes {
  static const String tasks = '/tasks';
  static const String taskDetail = '/tasks/detail'; // Changed from /task-detail for nesting
  static const String calendar = '/calendar';
  static const String focus = '/focus';
  static const String profile = '/profile';
}


final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.tasks, // Start on the tasks tab

  // Error handling for unmatched routes (optional but good practice)
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Error: ${state.error}\nNo route found for ${state.uri.path}'),
    ),
  ),

  routes: [
    // ShellRoute for the main app structure with the bottom navigation bar
    ShellRoute(

      builder: (context, state, child) => AppShell(
        child: child,
        currentPath: state.fullPath!, // Pass the current path to AppShell
      ),
      routes: [
        // TAB 1: Tasks
        GoRoute(
          path: 'tasks', // Relative to the shell's path '/' -> /tasks
          pageBuilder: (context, state) => const MaterialPage(
            key: ValueKey('tasks_list'), // Add a key for better navigation behavior
            child: TaskListsScreen(),
          ),
          routes: [
            // Nested route for Task Detail (opened from within tasks tab)
            // This will be accessible at /tasks/detail
            GoRoute(
              path: 'detail', // Relative to '/tasks' -> /tasks/detail
              pageBuilder: (context, state) {
                final task = state.extra as Task?;
                return MaterialPage(
                  key: const ValueKey('task_detail'), // Add a key
                  fullscreenDialog: true, // Often true for detail screens
                  child: TaskDetailScreen(task: task),
                );
              },
            ),
          ],
        ),

        // TAB 2: Calendar
        GoRoute(
          path: 'calendar', // Relative to '/' -> /calendar
          pageBuilder: (context, state) => MaterialPage(
            key: const ValueKey('calendar'),
            child: _todo("Calendar"),
          ),
        ),

        // TAB 3: Focus
        GoRoute(
          path: 'focus', // Relative to '/' -> /focus
          pageBuilder: (context, state) => MaterialPage(
            key: const ValueKey('focus'),
            child: _todo("Focus"),
          ),
        ),

        // TAB 4: Profile
        GoRoute(
          path: 'profile', // Relative to '/' -> /profile
          pageBuilder: (context, state) => MaterialPage(
            key: const ValueKey('profile'),
            child: _todo("Profile"),
          ),
        ),
      ],
    ),
    // Any routes defined outside the ShellRoute will NOT have the bottom nav bar
    // If you have truly full-screen modals or login flows that should be
    // outside the main app shell, define them here.
    // For now, task-detail is moved inside the shell.
  ],
);