import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_core/firebase_core.dart'; // 🔧 Added
import 'firebase_options.dart'; // 🔧 Added

import 'package:to_do/models/task_list.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/services/notification_service.dart';
import 'package:to_do/services/task_list_service.dart';
import 'package:to_do/services/task_service.dart';
import 'package:to_do/viewmodels/task_list_view_model.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/router.dart';
import 'package:to_do/views/screens/login_screen.dart';
import 'package:to_do/views/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(TaskListAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<TaskList>(AppConstants.taskListBox);
  await Hive.openBox<Task>(AppConstants.taskBox);

  final taskListService = TaskListService();
  final taskService = TaskService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskListViewModel(taskListService),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskViewModel(taskService),
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
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<ThemeViewModel>(
          builder: (context, themeViewModel, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'To-Do App',
              theme: AppThemes.lightTheme(),
              darkTheme: AppThemes.darkTheme(),
              themeMode: themeViewModel.flutterThemeMode,
              // 🔧 You can switch back later to routerConfig if needed
              // routerConfig: router,
              home: const RegisterScreen(), // Or LoginScreen
            );
          },
        );
      },
    );
  }
}
