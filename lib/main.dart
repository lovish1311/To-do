import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // <--- ADD THIS IMPORT
import 'package:to_do/models/task_list.dart';
import 'package:to_do/services/task_list_service.dart'; // <--- ADD THIS IMPORT
import 'package:to_do/viewmodels/task_list_view_model.dart'; // <--- ADD THIS IMPORT
import 'package:to_do/utils/constants.dart'; // For AppConstants
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/views/screens/task_lists_screen.dart'; // <--- ADD THIS IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(TaskListAdapter());

  await Hive.openBox<TaskList>(AppConstants.taskListBox); // Use constant
  await Hive.openBox(AppConstants.taskBox); // Use constant

  // Initialize the TaskListService
  final taskListService = TaskListService();

  runApp(
    // Wrap MyApp with ChangeNotifierProvider to make TaskListViewModel available
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              TaskListViewModel(taskListService), // Pass the service
        ),
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set the home to TaskListsScreen
      home:
          const TaskListsScreen(), // Now TaskListsScreen will have access to the ViewModel
    );
  }
}
