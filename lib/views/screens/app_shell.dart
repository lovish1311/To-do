import 'package:flutter/material.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/views/screens/task_lists_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedTabIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTabTapped(int index) {
    if (_selectedTabIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedTabIndex = index;
      });
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
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const TaskListsScreen());
        },
      ),
      Navigator(
        key: _navigatorKeys[1],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Center(child: Text("Calendar Screen (TODO)")));
        },
      ),
      Navigator(
        key: _navigatorKeys[2],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Center(child: Text("Focus Screen (TODO)")));
        },
      ),
      Navigator(
        key: _navigatorKeys[3],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Center(child: Text("Profile Screen (TODO)")));
        },
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        final NavigatorState currentTabNav = _navigatorKeys[_selectedTabIndex].currentState!;
        if (await currentTabNav.maybePop()) {
          // If the current tab can pop, just pop it.
          return false;
        } else if (_selectedTabIndex != 0) {
          // If user is not on tab 0, switch to tab 0 instead of exiting
          setState(() => _selectedTabIndex = 0);
          return false;
        }
        // Allow app to exit (default Android behavior)
        return true;
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
