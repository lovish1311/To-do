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

  void _onAddFabPressed(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    taskViewModel.addTask(
      title: 'New Task ${taskViewModel.tasks.length + 1}',
      taskListId: 'default_list_id',
      dueDateTime: DateTime.now().add(const Duration(days: 1)),
      priority: 'medium',
    );
    print('Add new Task FAB pressed (dummy add). Task card should appear.');
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
    // The FAB's protrusion amount (how much it sticks out above the BottomAppBar) is AppDimens.fabSize / 2.
    final double customBottomNavBarTotalHeight = kBottomNavigationBarHeight + (AppDimens.fabSize / 2);


    // The bottom padding for the body content.
    // This ensures the scrollable content clears the entire bottom navigation area,
    // including the FAB that is half-out.
    final double bottomContentPadding = MediaQuery.of(context).viewInsets.bottom +
        (isBottomNavVisible ? customBottomNavBarTotalHeight: AppDimens.screenPadding);


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
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppDimens.screenPadding,
              right: AppDimens.screenPadding,
              top: AppDimens.screenPadding,
              bottom: bottomContentPadding,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: taskViewModel.tasks.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (taskViewModel.tasks.isEmpty) ...[
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
