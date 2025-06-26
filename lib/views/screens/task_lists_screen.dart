import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task_list.dart';
import 'package:to_do/viewmodels/task_list_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/dialog_utils.dart';
import 'package:to_do/views/widgets/custom_bottom_nav_bar.dart'; // Import CustomBottomNavBar
import 'package:to_do/views/widgets/task_list_item.dart'; // Import the new TaskListItem widget
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG support

class TaskListsScreen extends StatefulWidget {
  const TaskListsScreen({super.key});

  @override
  State<TaskListsScreen> createState() => _TaskListsScreenState();
}

class _TaskListsScreenState extends State<TaskListsScreen> {
  int _selectedTabIndex = 0; // Keeping track of the selected tab for future navigation

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      // In a real app, you would navigate to different screens here
      print('Selected tab index: $_selectedTabIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    // Determine the dynamic bottom padding for the scrollable content.
    final bool isBottomNavVisible = true;
    final double bottomContentPadding = MediaQuery.of(context).viewInsets.bottom +
        (isBottomNavVisible ? kBottomNavigationBarHeight + AppDimens.cardMargin : AppDimens.screenPadding);


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Index',
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
              themeViewModel.setThemeMode(ThemeModeType.system);
            },
            tooltip: 'System Theme',
          ),
          SizedBox(width: AppDimens.screenPadding / 2),
        ],
      ),
      body: Consumer<TaskListViewModel>(
        builder: (context, taskListViewModel, child) {
          if (taskListViewModel.taskLists.isEmpty) {
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
                        "assets/images/img_checklist.svg", // Path to your SVG asset
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
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
                      itemCount: taskListViewModel.taskLists.length,
                      itemBuilder: (context, index) {
                        final taskList = taskListViewModel.taskLists[index];
                        return TaskListItem( // Using the new TaskListItem widget here
                          taskList: taskList,
                          onEdit: () {
                            DialogUtils.showTaskListFormDialog(context, taskList: taskList);
                          },
                          onDelete: () {
                            // Pass taskListViewModel to the dialog for direct deletion access
                            DialogUtils.showDeleteConfirmationDialog(context, taskListViewModel, taskList);
                          },
                          onTap: () {
                            print('Tapped on ${taskList.name}');
                            // TODO: Navigate to Task Details Screen for this taskList
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
          DialogUtils.showTaskListFormDialog(context);
        },
        tooltip: 'Add Task List',
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
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
