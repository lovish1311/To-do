import 'package:flutter/material.dart';
import 'package:to_do/models/task.dart'; // Import the Task model
import 'package:to_do/utils/app_themes.dart'; // For AppDimens and theme colors

/// A reusable widget to display a single Task item.
/// It features a completion marker, task title, due time, and priority tag.
class TaskCard extends StatelessWidget {
  final Task task; // The Task object to display
  final VoidCallback onToggleComplete; // Callback for when the completion marker is tapped
  final VoidCallback onTap; // Callback for when the entire card is tapped

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector( // GestureDetector for the whole card tap
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius), // Use theme radius
          color: colorScheme.surface, // Use theme surface color
        ),
        padding: const EdgeInsets.symmetric(vertical: AppDimens.listItemVerticalPadding, horizontal: AppDimens.listItemPadding),
        margin: const EdgeInsets.only(bottom: AppDimens.cardMargin * 2, left: AppDimens.screenPadding, right: AppDimens.screenPadding),
        width: double.infinity, // Take full width
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the top
          children: [
            // --- Completion Marker (Circle) ---
            GestureDetector(
              onTap: onToggleComplete, // Toggle complete status on tap
              child: Container(
                margin: const EdgeInsets.only(right: AppDimens.listItemPadding / 2),
                width: AppDimens.iconSize, // Consistent icon size
                height: AppDimens.iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Make it a circle
                  color: task.isCompleted ? colorScheme.primary : colorScheme.surface, // Filled blue if complete, else black
                  border: Border.all(
                    color: task.isCompleted ? colorScheme.primary : colorScheme.onSurface, // Blue border if complete, else black
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: task.isCompleted
                      ? Icon(Icons.check, color: colorScheme.onPrimary, size: AppDimens.iconSize * 0.7) // White checkmark if complete
                      : Container( // Unfilled state - black outer circle, white inner
                    width: AppDimens.iconSize - 6, // Smaller inner circle
                    height: AppDimens.iconSize - 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.background, // Inner white circle for unfilled
                    ),
                  ),
                ),
              ),
            ),
            // --- Task Details (Title, Due Time, Priority) ---
            Expanded( // Takes remaining horizontal space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: AppDimens.cardMargin / 2),
                    child: Text(
                      task.title,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface, // Text color
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none, // Strikethrough if complete
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (task.dueDateTime != null) // Only show if due date exists
                    Text(
                      'Due: ${task.dueDateTime!.toLocal().toString().split(' ')[0]} ${task.dueDateTime!.toLocal().hour}:${task.dueDateTime!.toLocal().minute.toString().padLeft(2, '0')}',
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)), // Grey text
                    ),
                  SizedBox(height: AppDimens.cardMargin), // Spacing between text and priority tag
                  // --- Priority Tag ---
                  if (task.priority != null) // Only show if priority exists
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius / 2),
                        color: colorScheme.primary, // Themed blue background
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.cardMargin, vertical: AppDimens.cardMargin / 2),
                      child: Text(
                        task.priority!.toUpperCase(), // Display priority in uppercase
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onPrimary), // White text on primary
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
