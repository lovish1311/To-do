// lib/views/screens/index_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/viewmodels/theme_view_model.dart'; // Re-import ThemeViewModel for its AppBar
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/widgets/task_card.dart';
import 'package:to_do/views/widgets/completed_tasks_section.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  // _selectedTabIndex and _onTabTapped are moved to AppShell.

  void _navigateToEditTask(BuildContext context, Task task) {
    // context.go('/tasks/${task.id}');
    // context.go(AppConstants.taskDetailPath);

    print('Navigating to TaskDetailScreen to edit task: ${task.title}');
  }
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _listening = false;
  String _transcript = '';

  static const _functionUrl =
      'https://asia-south1-navigation-38d3a.cloudfunctions.net/parseSpeechToTask';

  Future<bool> _ensureMicPermission() async {
    // 1) Check current status
    final status = await Permission.microphone.status; // granted / denied / permanentlyDenied etc.
    if (status.isGranted) return true; // No dialog, already approved

    // 2) Request on tap – will show OS dialog only if not yet granted
    final newStatus = await Permission.microphone.request();
    if (newStatus.isGranted) return true;

    // 3) Handle permanent denial (user selected “Don’t ask again” on Android)
    // 3) Handle permanent denial (user selected “Don’t ask again” on Android)
    if (newStatus.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission permanently denied. Open Settings to enable.'),
          ),
        );
      }
      await openAppSettings(); // permission_handler helper to open app settings
    }

    return false;
  }

  Future<void> _onMicPressed() async {
    if (!_listening) {
      final allowed = await _ensureMicPermission(); // Only asks if not granted
      if (!allowed) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
        return;
      }

      // Initialize speech engine – on iOS/Android this now succeeds after permission
      final available = await _speech.initialize(
        onError: (e) => debugPrint('Speech error: $e'),
        onStatus: (s) => debugPrint('Speech status: $s'),
      );
      if (!available) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech not available')),
        );
        return;
      }

      setState(() => _listening = true);
      _speech.listen(
        onResult: (r) => setState(() => _transcript = r.recognizedWords),
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      );
    } else {
      await _speech.stop();
      setState(() => _listening = false);
      final text = _transcript.trim();
      if (text.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No speech captured')),
        );
        return;
      }
      await _callAiAndCreateTask(text); // Your existing function to call the HTTPS endpoint
    }
  }
  Future<void> _callAiAndCreateTask(String text) async {
    final vm = context.read<TaskViewModel>();
    final tz = await FlutterNativeTimezone.getLocalTimezone();
    final nowIso = DateTime.now().toIso8601String();

    try {
      final resp = await http.post(
        Uri.parse(_functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'tz': tz,
          'nowIso': nowIso,
          'taskListId': 'default_list_id',
        }),
      );

      if (resp.statusCode != 200) {
        debugPrint('Function error: ${resp.statusCode} ${resp.body}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI parsing failed')),
        );
        return;
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      await vm.addTask(
        title: (data['title'] ?? '').toString(),
        description: data['description'] as String?,
        taskListId: (data['taskListId'] ?? 'default_list_id').toString(),
        dueDateTime: data['dueDateTime'] != null
            ? DateTime.parse(data['dueDateTime'] as String)
            : null,
        priority: data['priority'] as String?,
        subtasks: (data['subtasks'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        isWishTask: (data['isWishTask'] as bool?) ?? false,
        wishTaskDeadline: data['wishTaskDeadline'] != null
            ? DateTime.parse(data['wishTaskDeadline'] as String)
            : null,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI task added: ${data['title']}')),
      );
    } catch (e) {
      debugPrint('HTTP error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error while creating AI task')),
      );
    }
  }
  @override
  void dispose() {
    _speech.stop();
    super.dispose();
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
              Theme.of(context).brightness == Brightness.light
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.appBarTheme.foregroundColor,
              size: AppDimens.iconSize * 1.2,
            ),
            onPressed: () {
              // Toggle between light/dark, not system
              themeViewModel.setThemeMode(
                Theme.of(context).brightness == Brightness.light
                    ? ThemeModeType.dark
                    : ThemeModeType.light,
              );
            },
            tooltip: 'Toggle Theme',
          ),

          IconButton(
            tooltip: _listening ? 'Stop & Create Task' : 'AI Task (Mic)',
            icon: Icon(_listening ? Icons.stop_circle : Icons.mic),
            onPressed: _onMicPressed,
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