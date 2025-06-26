import 'package:flutter/material.dart';
import 'package:to_do/models/task_list.dart'; // Import TaskList model
import 'package:to_do/utils/app_themes.dart'; // Import AppDimens and theme-related constants

/// A reusable widget to display a single task list item.
/// It includes the task list's name, creation date, and action buttons (edit/delete).
class TaskListItem extends StatelessWidget {
  final TaskList taskList; // The TaskList object to display
  final VoidCallback onEdit; // Callback for when the edit button is pressed
  final VoidCallback onDelete; // Callback for when the delete button is pressed
  final VoidCallback onTap; // Callback for when the entire list item is tapped

  const TaskListItem({
    super.key,
    required this.taskList,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme for styling
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.cardMargin), // Use themed margin
      elevation: AppDimens.cardElevation, // Use themed elevation
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius)), // Use themed border radius
      color: theme.cardColor, // Use themed card color
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.listItemPadding,
            vertical: AppDimens.listItemVerticalPadding), // Use themed padding
        title: Text(
          taskList.name,
          style: textTheme.titleLarge?.copyWith(color: theme.listTileTheme.textColor), // Use themed text style
        ),
        subtitle: Text(
          'Created: ${taskList.createdAt.toLocal().toString().split(' ')[0]}',
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)), // Use themed text style
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Keep the row compact
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: colorScheme.primary), // Use themed primary color for icon
              onPressed: onEdit, // Call the provided onEdit callback
            ),
            IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error), // Use themed error color for icon
              onPressed: onDelete, // Call the provided onDelete callback
            ),
          ],
        ),
        onTap: onTap, // Call the provided onTap callback
      ),
    );
  }
}
