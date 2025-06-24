import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:path_provider/path_provider.dart';
import 'package:to_do/utils/constants.dart'; // Import path_provider for Hive path

void main() async {
  // Ensure Flutter widgets are initialized before Hive
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory for Hive to store its files
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Open the Hive boxes. We'll define the models for these boxes later.
  // Using .openBox() is generally fine for main boxes used throughout the app.
  // For 'task_lists', we'll store our categories of tasks.
  await Hive.openBox(AppConstants.taskListBox);
  // For 'tasks', we'll store individual tasks.
  await Hive.openBox(AppConstants.taskBox); // We'll use a separate box for individual tasks

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App', // Updated app title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Changed seed color
        useMaterial3: true, // Enable Material 3 if not already
      ),
      // Set the home to a placeholder for TaskListsScreen for now.
      // We will replace this with the actual TaskListsScreen widget once created.
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Task Lists'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Loading Task Lists (Placeholder)',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

// The MyHomePage and its State are no longer needed for our To-Do app,
// so they are removed from this main.dart file.