import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task_list.dart';
import 'package:to_do/viewmodels/task_list_view_model.dart';

/// A utility class or collection of static methods for showing common dialogs.
/// This centralizes dialog logic, making it reusable and keeping screens clean.
class DialogUtils {
  /// Shows a dialog for adding a new TaskList or editing an existing one.
  /// If [taskList] is provided, it's an edit operation; otherwise, it's an add operation.
  static void showTaskListFormDialog(BuildContext context, {TaskList? taskList}) {
    final TextEditingController controller = TextEditingController(text: taskList?.name ?? '');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme; // Get textTheme

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            taskList == null ? 'New Task List' : 'Edit Task List',
            style: theme.dialogTheme.titleTextStyle,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter task list name',
              hintStyle: theme.inputDecorationTheme.hintStyle,
              enabledBorder: theme.inputDecorationTheme.enabledBorder,
              focusedBorder: theme.inputDecorationTheme.focusedBorder,
              border: theme.inputDecorationTheme.border,
            ),
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          actions: <Widget>[
            TextButton(
              // Corrected: Use textTheme.labelLarge and copyWith for color
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              // Corrected: Use textTheme.labelLarge and copyWith for color
              child: Text(
                taskList == null ? 'Add' : 'Save',
                style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final viewModel = Provider.of<TaskListViewModel>(
                      dialogContext, // Use dialogContext to ensure correct provider scope
                      listen: false);
                  if (taskList == null) {
                    viewModel.addTaskList(controller.text);
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Task list "${controller.text}" added.',
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                        backgroundColor: colorScheme.surface,
                      ),
                    );
                  } else if (controller.text != taskList.name) {
                    viewModel.updateTaskList(taskList.id, controller.text);
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Task list updated to "${controller.text}".',
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                        backgroundColor: colorScheme.surface,
                      ),
                    );
                  }
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog before deleting a task list.
  static void showDeleteConfirmationDialog(
      BuildContext context, TaskListViewModel viewModel, TaskList taskList) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme; // Get textTheme

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: theme.dialogTheme.titleTextStyle,
          ),
          content: Text(
            'Are you sure you want to delete "${taskList.name}"?',
            style: theme.dialogTheme.contentTextStyle,
          ),
          actions: <Widget>[
            TextButton(
              // Corrected: Use textTheme.labelLarge and copyWith for color
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              // Corrected: Use textTheme.labelLarge and copyWith for color
              child: Text(
                'Delete',
                style: textTheme.labelLarge?.copyWith(color: colorScheme.error),
              ),
              onPressed: () {
                viewModel.deleteTaskList(taskList.id);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      '"${taskList.name}" deleted.',
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                    backgroundColor: colorScheme.surface,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
