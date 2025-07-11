// lib/views/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/utils/app_themes.dart'; // Import AppDimens and AppColors
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:to_do/views/screens/task_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// A reusable widget to display a single task.
/// It shows the task's title, completion status, and provides callbacks for interactions.
class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  void _navigateToEditTask(BuildContext context, Task task) {
    GoRouter.of(context).pushNamed(
      'taskDetail',
      pathParameters: {'id': task.id},
    );

    print('Navigating to TaskDetailScreen to edit task: ${task.title}');
  }

  Future<void> _deleteTask(BuildContext context, String taskId) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool confirmDelete =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                'Delete Task',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              content: Text(
                'Are you sure you want to delete "${task.title}"?',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Delete',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
            false;

    if (confirmDelete) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      taskViewModel.deleteTask(taskId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task "${task.title}" deleted!')));
      print('Task with ID $taskId deleted.');
    } else {
      print('Deletion cancelled for task with ID $taskId.');
    }
  }

  void _toggleComplete(BuildContext context, String taskId) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    taskViewModel.toggleTaskCompletion(taskId);
    print('Task with ID $taskId completion toggled.');
  }

  // Helper to format dates
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    // Compare year and month
    if (dateTime.year == now.year && dateTime.month == now.month) {
      return DateFormat('dd/MMM hh:mm a').format(dateTime.toLocal()); // Same month: date, time and AM/PM
    } else {
      return DateFormat('MMM dd, yyyy, hh:mm a').format(dateTime.toLocal()); // Different month: month, date, year, time and AM/PM
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Determine current theme for specific colors
    final bool isLightMode = theme.brightness == Brightness.light;
    final Color wishTaskTagColor = isLightMode ? AppColorsLight.wishTaskColor : AppColorsDark.wishTaskColor;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.cardMargin),
      elevation: AppDimens.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
      ),
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => _navigateToEditTask(context, task),
        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
        child: Padding(
          // Adjusted vertical padding using AppDimens constant with multiplier
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.listItemPadding,
            vertical: AppDimens.cardInternalVerticalPadding * 0.9, // Adjusted multiplier for fine-tuning
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Task Completion Marker (Interactive Circle) ---
              GestureDetector(
                onTap: () => _toggleComplete(context, task.id),
                child: Container(
                  width: AppDimens.iconSize,
                  height: AppDimens.iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted
                        ? colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.5),
                      width: 2.0,
                    ),
                  ),
                  child: task.isCompleted
                      ? Icon(
                    Icons.check,
                    color: colorScheme.onPrimary,
                    size: AppDimens.iconSize * 0.7,
                  )
                      : null,
                ),
              ),
              SizedBox(width: AppDimens.screenPadding),
              // Spacing between checkbox and title

              // --- Task Details (Title, Due Time, Priority Tag, Wish Task Info) ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: textTheme.titleLarge?.copyWith(
                        color: task.isCompleted
                            ? colorScheme.onSurface.withOpacity(0.6)
                            : colorScheme.onSurface,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Vertical spacing after title/dates and before tags/footer
                    if (task.dueDateTime != null ||
                        (task.isWishTask && task.wishTaskDeadline != null))
                      const SizedBox(height: AppDimens.smallGap) // Used smallGap
                    else
                      const SizedBox(height: AppDimens.smallGap), // Used smallGap

                    if (task.dueDateTime != null)
                      Text(
                        'Due: ${_formatDateTime(task.dueDateTime!)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    // Wish Task Deadline
                    if (task.isWishTask && task.wishTaskDeadline != null)
                      Text(
                        'Deadline: ${_formatDateTime(task.wishTaskDeadline!)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: wishTaskTagColor.withOpacity(0.8), // Using wishTaskTagColor
                        ),
                      ),
                    // Grouping tags in a Wrap widget for horizontal layout
                    if (task.priority != null && task.priority!.isNotEmpty ||
                        task.isWishTask)
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimens.mediumGap), // Used mediumGap
                        child: Wrap(
                          spacing: AppDimens.tagSpacing, // Used tagSpacing
                          runSpacing: AppDimens.tagRunSpacing, // Used tagRunSpacing
                          children: [
                            // Priority Tag
                            if (task.priority != null &&
                                task.priority!.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.cardBorderRadius / 2,
                                  ),
                                  color: colorScheme.primary.withOpacity(0.1),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.tagHorizontalPadding, // Used tagHorizontalPadding
                                  vertical: AppDimens.tagVerticalPadding, // Used tagVerticalPadding
                                ),
                                child: Text(
                                  task.priority!.toUpperCase(),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            // Wish Task Tag
                            if (task.isWishTask)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.cardBorderRadius / 2,
                                  ),
                                  color: wishTaskTagColor.withOpacity(0.1), // Using wishTaskTagColor
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.tagHorizontalPadding, // Used tagHorizontalPadding
                                  vertical: AppDimens.tagVerticalPadding, // Used tagVerticalPadding
                                ),
                                child: Text(
                                  'WISH TASK',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: wishTaskTagColor, // Using wishTaskTagColor
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Horizontal spacing before the delete button
              SizedBox(width: AppDimens.screenPadding),

              // Delete Icon Button
              IconButton(
                icon: Icon(Icons.delete_outline, color: colorScheme.error),
                onPressed: () => _deleteTask(context, task.id),
                tooltip: 'Delete Task',
              ),
            ],
          ),
        ),
      ),
    );
  }
}