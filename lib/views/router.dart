import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/screens/app_shell.dart';
import 'package:to_do/views/screens/login_screen.dart';
import 'package:to_do/views/screens/register_screen.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:to_do/views/screens/index_screen.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  // initialLocation: AppConstants.indexPath,
  initialLocation: AppConstants.loginPath,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(state: state, child: child),
      routes: [
        GoRoute(
          path: AppConstants.indexPath,
          name: 'index',
          pageBuilder: (context, state) => const NoTransitionPage(child: IndexScreen()),
        ),
        GoRoute(
          path: AppConstants.calendarPath,
          name: 'calendar',
          pageBuilder: (context, state) => const NoTransitionPage(child: const Text("Calender Screen")),
        ),
        GoRoute(
          path: AppConstants.focusPath,
          name: 'focus',
          pageBuilder: (context, state) => const NoTransitionPage(child: const Text("Focus Screen")),
        ),
        GoRoute(
          path: AppConstants.profilePath,
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: const Text("Focus Screen")),
        ),
      ],
    ),
    GoRoute(
      path: AppConstants.taskDetailPath,
      name: 'taskDetail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TaskDetailScreen(
          task: id == 'new' ? null : null, // Replace with real fetch logic
        );
      },
    ),
    GoRoute(
      path: AppConstants.loginPath,
      name: 'login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppConstants.registerPath,
      name: 'register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
