import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/dialog_utils.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart';
import 'package:to_do/views/widgets/task_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    final bool isBottomNavVisible = true; // Set to true to always show the bottom nav bar
    final double bottomContentPadding = MediaQuery.of(context).viewInsets.bottom +
        (isBottomNavVisible ? kBottomNavigationBarHeight + AppDimens.cardMargin : AppDimens.screenPadding);


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
          SizedBox(width: AppDimens.screenPadding), // Dynamic spacing
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.screenPadding), // Increased right padding
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
          if (taskViewModel.tasks.isEmpty) {
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
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: AppDimens.screenPadding),
                      Text(
                        "What do you want to do today?",
                        style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onBackground),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimens.cardMargin),
                      Text(
                        "Tap + to add your tasks",
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimens.screenPadding),
                      Text(
                        'Your tasks will appear here.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            );
          } else {
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
                      itemBuilder: (context, index) {
                        final task = taskViewModel.tasks[index];
                        return TaskCard(
                          task: task,
                          onToggleComplete: () {
                            taskViewModel.toggleTaskCompletion(task.id);
                          },
                          onTap: () {
                            print('Tapped on Task: ${task.title}');
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
          final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
          taskViewModel.addTask(
            title: 'New Task ${taskViewModel.tasks.length + 1}',
            taskListId: 'default_list_id',
            dueDateTime: DateTime.now().add(const Duration(days: 1)),
            priority: 'medium',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Dummy task added!',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              backgroundColor: colorScheme.surface,
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
      bottomNavigationBar: CustomBottomNavBar( // Ensure this widget is called
        isVisible: isBottomNavVisible, // Ensure this is true
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
