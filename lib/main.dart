import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:to_do/models/task_list.dart'; // Provides TaskListAdapter
import 'package:to_do/models/task.dart'; // NEW: Import Task model
import 'package:to_do/services/task_list_service.dart';
import 'package:to_do/services/task_service.dart'; // NEW: Import TaskService
import 'package:to_do/viewmodels/task_list_view_model.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/screens/app_shell.dart';
import 'package:to_do/views/screens/task_lists_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Register adapters for both TaskList and Task models
  Hive.registerAdapter(TaskListAdapter());
  Hive.registerAdapter(TaskAdapter()); // NEW: Register TaskAdapter

  // Open the Hive boxes using constants
  await Hive.openBox<TaskList>(AppConstants.taskListBox);
  await Hive.openBox<Task>(AppConstants.taskBox); // UPDATED: Open Task box with <Task> type

  // Initialize both services
  final taskListService = TaskListService();
  final taskService = TaskService(); // NEW: Initialize TaskService

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskListViewModel(taskListService),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeViewModel(),
        ),
        // NEW: Provider for TaskViewModel
        ChangeNotifierProvider(
          create: (context) => TaskViewModel(taskService), // Pass the new taskService
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeViewModel, child) {
        return MaterialApp(
          title: 'To-Do App',
          theme: AppThemes.lightTheme(),
          debugShowCheckedModeBanner: false,
          darkTheme: AppThemes.darkTheme(),
          themeMode: themeViewModel.flutterThemeMode,
          home: const AppShell(),
        );
      },
    );
  }
}
