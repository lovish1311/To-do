import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task.dart'; // Import Task model instead of TaskList
import 'package:to_do/viewmodels/task_view_model.dart'; // NEW: Import TaskViewModel
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/dialog_utils.dart'; // Still used for common dialog patterns, will be adapted
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/views/widgets/task_card.dart'; // NEW: Import TaskCard
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG support

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
      // In a real app, this would navigate to different main screens (Index, Calendar, Focus, Profile)
    });
  }

  // NOTE: The dialog functions below are currently for TaskList.
  // They will be replaced/adapted in WBS Task 2.2 for Task-specific dialogs.
  // For now, the FAB will trigger a placeholder for adding a task.

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    final bool isBottomNavVisible = true;
    final double bottomContentPadding =
        MediaQuery.of(context).viewInsets.bottom +
        (isBottomNavVisible
            ? kBottomNavigationBarHeight + AppDimens.cardMargin
            : AppDimens.screenPadding);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Tasks', // Changed title to reflect displaying tasks
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
          IconButton(
            icon: Icon(
              Icons.brightness_auto,
              color: theme.appBarTheme.foregroundColor,
            ),
            onPressed: () {
              // themeViewModel.setThemeMode(ThemeModeType.system);
            },
            tooltip: 'System Theme',
          ),
          SizedBox(width: AppDimens.screenPadding / 2),
        ],
      ),
      // CHANGED: Consumer now listens to TaskViewModel
      body: Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
          if (taskViewModel.tasks.isEmpty) {
            // Check taskViewModel.tasks
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppDimens.screenPadding,
                  right: AppDimens.screenPadding,
                  top: AppDimens.screenPadding * 2,
                  bottom: bottomContentPadding,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),
                      SvgPicture.asset(
                        "assets/images/img_checklist.svg",
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: AppDimens.screenPadding),
                      Text(
                        "What do you want to do today?",
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimens.cardMargin),
                      Text(
                        "Tap + to add your tasks",
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimens.screenPadding),
                      Text(
                        'Your tasks will appear here.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Display actual tasks when tasks are present
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppDimens.screenPadding,
                  right: AppDimens.screenPadding,
                  top: AppDimens.screenPadding,
                  bottom: bottomContentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskViewModel.tasks.length,
                      // Iterate over tasks
                      itemBuilder: (context, index) {
                        final task =
                            taskViewModel.tasks[index]; // Get a Task object
                        return TaskCard(
                          // Using the new TaskCard widget here
                          task: task,
                          onToggleComplete: () {
                            // Call TaskViewModel to toggle completion
                            taskViewModel.toggleTaskCompletion(task.id);
                          },
                          onTap: () {
                            print('Tapped on Task: ${task.title}');
                            // TODO: Implement navigation to Task Details/Edit Screen for this individual task
                            // This will be part of WBS Task 2.2
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: This will be updated in WBS Task 2.2 to show a full Task form dialog.
          // For now, let's add a dummy task to demonstrate.
          final taskViewModel = Provider.of<TaskViewModel>(
            context,
            listen: false,
          );
          taskViewModel.addTask(
            title: 'New Task ${taskViewModel.tasks.length + 1}',
            taskListId: 'default_list_id', // Using a dummy ID for now
            dueDateTime: DateTime.now().add(const Duration(days: 1)),
            priority: 'medium',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Dummy task added!',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          print('Add new Task FAB pressed (dummy add)');
        },
        tooltip: 'Add Task',
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        isVisible: isBottomNavVisible,
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
