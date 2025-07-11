// lib/views/screens/task_lists_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart'; // Re-import ThemeViewModel for its AppBar
import 'package:to_do/utils/app_themes.dart';
// CustomBottomNavBar is still not used directly here
// import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/views/widgets/task_card.dart';
import 'package:to_do/views/widgets/completed_tasks_section.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskListsScreen extends StatefulWidget {
  const TaskListsScreen({super.key});

  @override
  State<TaskListsScreen> createState() => _TaskListsScreenState();
}

class _TaskListsScreenState extends State<TaskListsScreen> {
  // _selectedTabIndex and _onTabTapped are moved to AppShell.

  void _navigateToEditTask(BuildContext context, Task task) {
    // This correctly uses the nested Navigator for navigation within this tab.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
    print('Navigating to TaskDetailScreen to edit task: ${task.title}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeViewModel = Provider.of<ThemeViewModel>(context); // Re-consume ThemeViewModel for AppBar

    // Calculate the height of the CustomBottomNavBar that is _below_ this screen.
    // This is crucial for content padding to prevent obscuring by the bottom bar.
    // We assume here that CustomBottomNavBar's structure maintains its overall visual height.
    // The height of CustomBottomNavBar is kBottomNavigationBarHeight + AppDimens.fabSize / 2.
    final double customBottomNavBarHeight = kBottomNavigationBarHeight + AppDimens.fabSize / 2;

    // Add MediaQuery.of(context).viewPadding.bottom to account for system insets (e.g., safe area for gestures)
    // and then add the height of your CustomBottomNavBar.
    final double bottomContentPadding = MediaQuery.of(context).viewPadding.bottom +
        customBottomNavBarHeight +
        AppDimens.screenPadding; // Add some extra margin

    return Scaffold(
      resizeToAvoidBottomInset: true, // Keep this to handle keyboard
      backgroundColor: colorScheme.background,
      appBar: AppBar( // AppBar restored here
        title: Text(
          'Tasks',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              themeViewModel.themeMode == ThemeModeType.light
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.appBarTheme.foregroundColor,
              size: AppDimens.iconSize * 1.2,
            ),
            onPressed: () {
              themeViewModel.setThemeMode(
                themeViewModel.themeMode == ThemeModeType.light
                    ? ThemeModeType.dark
                    : ThemeModeType.light,
              );
            },
            tooltip: 'Toggle Theme',
          ),
          SizedBox(width: AppDimens.screenPadding),
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.screenPadding),
            child: GestureDetector(
              onTap: () {
                print('Circular image button pressed (no action taken).');
              },
              child: Tooltip(
                message: 'User Profile',
                child: CircleAvatar(
                  radius: AppDimens.iconSize / 1.5,
                  backgroundColor: colorScheme.surface,
                  child: ClipOval(
                    child: Image.network(
                      "https://placehold.co/50x50/cccccc/000000?text=P",
                      width: AppDimens.iconSize * 1.2,
                      height: AppDimens.iconSize * 1.2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: theme.appBarTheme.foregroundColor,
                        size: AppDimens.iconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
          final List<Task> activeTasks = taskViewModel.activeTasks;
          final List<Task> completedTasks = taskViewModel.completedTasks;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppDimens.screenPadding,
              right: AppDimens.screenPadding,
              top: AppDimens.screenPadding,
              bottom: bottomContentPadding, // Use the adjusted padding
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: activeTasks.isEmpty && completedTasks.isEmpty
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (activeTasks.isEmpty && completedTasks.isEmpty) ...[
                    SvgPicture.asset(
                      "assets/images/img_checklist.svg",
                      width: MediaQuery.of(context).size.shortestSide * 0.5,
                      height: MediaQuery.of(context).size.shortestSide * 0.5,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: AppDimens.screenPadding),
                    Text(
                      "What do you want to do today?",
                      style: textTheme.headlineMedium?.copyWith(color: colorScheme.onBackground),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimens.cardMargin),
                    Text(
                      "Tap + to add your tasks",
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground.withOpacity(0.7)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimens.screenPadding),
                    Text(
                      'Your tasks will appear here.',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    if (activeTasks.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeTasks.length,
                        itemBuilder: (context, index) {
                          final task = activeTasks[index];
                          return TaskCard(
                            task: task
                          );
                        },
                      ),
                    if (activeTasks.isNotEmpty && completedTasks.isNotEmpty)
                      SizedBox(height: AppDimens.screenPadding),
                    CompletedTasksSection(
                      completedTasks: completedTasks,
                      onToggleComplete: (taskId) {
                        taskViewModel.toggleTaskCompletion(taskId);
                      },
                      onTapTask: (task) => _navigateToEditTask(context, task),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      // No floatingActionButton or bottomNavigationBar here anymore
    );
  }
}