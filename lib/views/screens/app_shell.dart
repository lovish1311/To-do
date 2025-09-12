import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/utils/constants.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const AppShell({super.key, required this.child,required this.state,});

  bool _shouldShowBottomNav(String location) {
    // Define all routes that should hide the bottom navigation bar.
    const hiddenPaths = [AppConstants.taskDetailPath];
    return hiddenPaths.every((path) => !location.startsWith(path));
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith(AppConstants.indexPath)) return 0;
    if (location.startsWith(AppConstants.calendarPath)) return 1;
    if (location.startsWith(AppConstants.focusPath)) return 2;
    if (location.startsWith(AppConstants.profilePath)) return 3;
    return 0;
  }

  void _onTapNav(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppConstants.indexPath);
        break;
      case 1:
        context.go(AppConstants.calendarPath);
        break;
      case 2:
        context.go(AppConstants.focusPath);
        break;
      case 3:
        context.go(AppConstants.profilePath);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
     final location = state.uri.toString();
    final showBottomNav = _shouldShowBottomNav(location);
    final selectedIndex = _calculateSelectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        isVisible: showBottomNav,
        currentIndex: selectedIndex,
        onTap: (index) => _onTapNav(context, index),
      ),
      floatingActionButton: showBottomNav
          ? FloatingActionButton(
        onPressed: () => context.pushNamed('taskDetail')
        // onPressed: () => context.push(AppConstants.loginPath)
        ,
        child: const Icon(Icons.add),
        shape: CircleBorder(),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
