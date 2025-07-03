import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:to_do/views/screens/task_lists_screen.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

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

  void _onAddFabPressed() {
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
