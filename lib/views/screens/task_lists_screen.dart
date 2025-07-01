import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/dialog_utils.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/views/widgets/task_card.dart';
import 'package:to_do/views/widgets/completed_tasks_section.dart';
import 'package:to_do/views/screens/task_detail_screen.dart'; // NEW: Import TaskDetailScreen
import 'package:flutter_svg/flutter_svg.dart';

class TaskListsScreen extends StatefulWidget {
  const TaskListsScreen({super.key});

  @override
  State<TaskListsScreen> createState() => _TaskListsScreenState();
}

class _TaskListsScreenState extends State<TaskListsScreen> {
  int _selectedTabIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      print('Selected tab index: $_selectedTabIndex');
    });
  }

  void _onAddFabPressed(BuildContext context) {
    // Navigate to TaskDetailScreen to add a new task
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TaskDetailScreen(), // No task passed for new creation
      ),
    );
    print('Navigating to TaskDetailScreen to add a new task.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    final bool isBottomNavVisible = true;

    // Calculate the total height of the CustomBottomNavBar including FAB protrusion.
    // This must precisely match the 'totalHeightWithFabProtrusion' calculated in CustomBottomNavBar.
    final double customBottomNavBarTotalHeight = kBottomNavigationBarHeight + (AppDimens.fabSize / 2 + 4);

    // The bottom padding for the body content.
    // This ensures the scrollable content clears the entire bottom navigation area,
    // including the FAB that is half-out.
    final double bottomContentPadding = MediaQuery.of(context).viewInsets.bottom +
        (isBottomNavVisible ? customBottomNavBarTotalHeight + AppDimens.cardMargin : AppDimens.screenPadding);


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.background,
      appBar: AppBar(
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
              bottom: bottomContentPadding,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: activeTasks.isEmpty && completedTasks.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
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
                            task: task,
                            onToggleComplete: () {
                              taskViewModel.toggleTaskCompletion(task.id);
                            },
                            onTap: () {
                              print('Tapped on Active Task: ${task.title}');
                              // TODO: Implement navigation to Task Details/Edit Screen
                            },
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
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: null,
      floatingActionButtonLocation: null,
      bottomNavigationBar: CustomBottomNavBar(
        isVisible: isBottomNavVisible,
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
        onFabPressed: () => _onAddFabPressed(context),
      ),
    );
  }
}
