import 'package:flutter/material.dart';
import 'package:to_do/models/task.dart'; // Import the Task model
import 'package:to_do/utils/app_themes.dart'; // For AppDimens and theme colors

/// A reusable widget to display a single task.
/// It shows the task's title, completion status, and provides callbacks for interactions.
class TaskCard extends StatelessWidget {
  final Task task; // The Task object to display
  final VoidCallback? onToggleComplete; // Callback when the completion status is toggled
  final VoidCallback? onTap; // Callback when the card itself is tapped (e.g., for details)

  const TaskCard({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.cardMargin), // Consistent bottom margin between cards
      elevation: AppDimens.cardElevation, // Consistent card elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius), // Consistent rounded corners
      ),
      color: colorScheme.surface, // Use theme's surface color for the card background
      child: InkWell( // Use InkWell for visual tap feedback on the entire card
        onTap: onTap, // Call the provided onTap callback
        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius), // Match card border radius
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.listItemPadding, // Consistent horizontal padding
            vertical: AppDimens.cardInternalVerticalPadding, // NEW: Use distinct vertical padding for card content
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the top
            children: [
              // --- Task Completion Marker (Interactive Circle) ---
              GestureDetector(
                onTap: onToggleComplete, // Toggle completion on tap
                child: Container(
                  width: AppDimens.iconSize, // Consistent size for the marker
                  height: AppDimens.iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Make it a perfect circle
                    color: task.isCompleted ? colorScheme.primary : Colors.transparent, // Blue if complete, transparent otherwise
                    border: Border.all(
                      color: task.isCompleted ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5), // Border color based on completion
                      width: 2.0, // Thicker border for better visibility
                    ),
                  ),
                  child: task.isCompleted
                      ? Icon(Icons.check, color: colorScheme.onPrimary, size: AppDimens.iconSize * 0.7) // White checkmark if completed
                      : null, // No icon if not completed
                ),
              ),
              SizedBox(width: AppDimens.screenPadding), // Spacing between checkbox and title

              // --- Task Details (Title, Due Time, Priority Tag) ---
              Expanded( // Takes up the remaining horizontal space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      task.title,
                      style: textTheme.titleLarge?.copyWith(
                        color: task.isCompleted ? colorScheme.onSurface.withOpacity(0.6) : colorScheme.onSurface, // Subdued color if completed
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none, // Strikethrough if complete
                      ),
                      maxLines: 2, // Limit title to 2 lines for compactness
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                    ),
                    if (task.dueDateTime != null) // Show due date if available
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimens.cardMargin / 4), // Small top padding for date
                        child: Text(
                          // Format date and time
                          'Due: ${task.dueDateTime!.toLocal().toString().split(' ')[0]} ${task.dueDateTime!.toLocal().hour}:${task.dueDateTime!.toLocal().minute.toString().padLeft(2, '0')}',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)), // Subdued grey text
                        ),
                      ),
                    // Add a small spacer if there's both a due date and a priority tag
                    if (task.dueDateTime != null && task.priority != null && task.priority!.isNotEmpty)
                      SizedBox(height: AppDimens.cardMargin / 2), // Slightly smaller gap

                    // --- Priority Tag ---
                    if (task.priority != null && task.priority!.isNotEmpty) // Show priority tag only if it exists and is not empty
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius / 2), // Rounded corners for the tag
                          color: colorScheme.primary.withOpacity(0.1), // Light primary color background for tag
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.cardMargin, vertical: AppDimens.cardMargin / 2),
                        child: Text(
                          task.priority!.toUpperCase(), // Display priority in uppercase
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary, // Primary color text for tag
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Optional: More actions (e.g., edit icon)
              // IconButton(
              //   icon: Icon(Icons.edit, color: colorScheme.onSurface.withOpacity(0.7)),
              //   onPressed: () {
              //     // Handle edit action
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
