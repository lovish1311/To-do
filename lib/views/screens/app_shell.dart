// lib/views/screens/app_shell.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Still needed if you consume providers for global logic
import 'package:to_do/utils/app_themes.dart'; // Still needed for AppDimens in CustomBottomNavBar calc
import 'package:to_do/viewmodels/theme_view_model.dart'; // Still needed for ThemeViewModel in CustomBottomNavBar calc
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/views/screens/task_lists_screen.dart'; // Import TaskListsScreen

// You'll need more screens for other tabs eventually
// import 'package:to_do/views/screens/calendar_screen.dart';
// import 'package:to_do/views/screens/focus_screen.dart';
// import 'package:to_do/views/screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedTabIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // For 'Index' (Tasks) tab
    GlobalKey<NavigatorState>(), // For 'Calendar' tab
    GlobalKey<NavigatorState>(), // For 'Focus' tab
    GlobalKey<NavigatorState>(), // For 'Profile' tab
  ];

  void _onTabTapped(int index) {
    if (_selectedTabIndex == index) {
      // If tapping the currently active tab, pop to the root of that tab's navigator
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedTabIndex = index;
      });
    }
    print('AppShell: Selected tab index: $_selectedTabIndex');
  }

  void _onAddFabPressed() {
    // When FAB is pressed, navigate to TaskDetailScreen using the current tab's navigator.
    // This assumes TaskDetailScreen is general purpose for adding tasks.
    _navigatorKeys[_selectedTabIndex].currentState?.push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(), // TODO: Replace with TaskDetailScreen
      ),
    );
    print('AppShell: Floating Action Button pressed!');
  }

  @override
  Widget build(BuildContext context) {
    // No theme or ThemeViewModel consumption here for AppBar
    // final theme = Theme.of(context);
    // final themeViewModel = Provider.of<ThemeViewModel>(context);

    final List<Widget> _tabBodies = [
      // Tab 0: 'Index' (Tasks)
      Navigator(
        key: _navigatorKeys[0],
        onGenerateRoute: (settings) {
          // This ensures TaskListsScreen is the root of this Navigator's stack
          return MaterialPageRoute(builder: (context) => const TaskListsScreen());
        },
      ),
      // Tab 1: 'Calendar'
      Navigator(
        key: _navigatorKeys[1],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Center(child: Text("Calendar Screen (TODO)")));
        },
      ),
      // Tab 2: 'Focus'
      Navigator(
        key: _navigatorKeys[2],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Center(child: Text("Focus Screen (TODO)")));
        },
      ),
      // Tab 3: 'Profile'
      Navigator(
        key: _navigatorKeys[3],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Center(child: Text("Profile Screen (TODO)")));
        },
      ),
    ];

    return Scaffold(
      // No AppBar here! Each child screen will have its own AppBar.
      // appBar: null, // Removed AppBar from AppShell
      body: IndexedStack(
        index: _selectedTabIndex,
        children: _tabBodies,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CustomBottomNavBar(
          currentIndex: _selectedTabIndex,
          onTap: _onTabTapped,
          onFabPressed: _onAddFabPressed,
        ),
      ),
    );
  }
}