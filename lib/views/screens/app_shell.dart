import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:to_do/views/screens/task_lists_screen.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';

import '../../services/notification_service.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final String currentPath; // The full path of the current route

  // NEW: Update the constructor to require these properties
  const AppShell({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedTabIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Index
    GlobalKey<NavigatorState>(), // Calendar
    GlobalKey<NavigatorState>(), // Focus
    GlobalKey<NavigatorState>(), // Profile
  ];

  void _onTabTapped(int index) {
    if (_selectedTabIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedTabIndex = index);
    }
  }

  void _onAddFabPressed() async {
// Schedule a delayed notification after 15 seconds
//     await NotificationService().showInstant(id: 102, title: "title", body: 'body');
//     await NotificationService().scheduleOnce(
//       id: 1001,
//       title: 'Reminder',
//       body: 'Don\'t forget to complete your new task!',
//       delay: const Duration(seconds: 15),
//     );
    _navigatorKeys[_selectedTabIndex].currentState?.push(
      MaterialPageRoute(builder: (context) => TaskDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabBodies = [
      Navigator(
        key: _navigatorKeys[0],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const TaskListsScreen(),
        ),
      ),
      Navigator(
        key: _navigatorKeys[1],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const Center(child: Text("Calendar Screen (TODO)")),
        ),
      ),
      Navigator(
        key: _navigatorKeys[2],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const Center(child: Text("Focus Screen (TODO)")),
        ),
      ),
      Navigator(
        key: _navigatorKeys[3],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const Center(child: Text("Profile Screen (TODO)")),
        ),
      ),
    ];

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;

        final navigator = _navigatorKeys[_selectedTabIndex].currentState!;
        navigator.maybePop().then((didActuallyPop) {
          if (didActuallyPop) return;

          if (_selectedTabIndex != 0) {
            setState(() => _selectedTabIndex = 0);
          } else {
            SystemNavigator.pop(); // Exit the app
          }
        });
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedTabIndex,
          children: _tabBodies,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddFabPressed,
          tooltip: 'Add Task',
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: const CircleBorder(),
          child: Icon(Icons.add, size: AppDimens.fabIconSize),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          top: false,
          child: CustomBottomNavBar(
            currentIndex: _selectedTabIndex,
            onTap: _onTabTapped,
          ),
        ),
      ),
    );
  }
}
