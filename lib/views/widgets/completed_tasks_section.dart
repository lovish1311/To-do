import 'package:flutter/material.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/views/widgets/task_card.dart';

/// A collapsible section to display completed tasks.
/// It shows a header with a count and an arrow, and expands to reveal the list of tasks.
class CompletedTasksSection extends StatefulWidget {
  final List<Task> completedTasks; // List of completed tasks to display
  final ValueChanged<String> onToggleComplete; // Callback to toggle task completion
  final ValueChanged<Task> onTapTask; // NEW: Callback when a task card is tapped

  const CompletedTasksSection({
    super.key,
    required this.completedTasks,
    required this.onToggleComplete,
    required this.onTapTask, // Initialize new callback
  });

  @override
  State<CompletedTasksSection> createState() => _CompletedTasksSectionState();
}

class _CompletedTasksSectionState extends State<CompletedTasksSection> {
  bool _isExpanded = false; // State to control expansion

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (widget.completedTasks.isEmpty && !_isExpanded) {
      return const SizedBox.shrink(); // Hide if no completed tasks and not expanded
    }

    return Column(
      children: [
        // Header for the completed tasks section
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle expansion state
            });
          },
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding,
              vertical: AppDimens.cardMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed Tasks (${widget.completedTasks.length})',
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
        // Display completed tasks only when expanded
        if (_isExpanded)
          ListView.builder(
            shrinkWrap: true, // Important for nested ListViews
            physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
            itemCount: widget.completedTasks.length,
            itemBuilder: (context, index) {
              final task = widget.completedTasks[index];
              return TaskCard(
                task: task,
                onToggleComplete: () => widget.onToggleComplete(task.id),
                onTap: () => widget.onTapTask(task), // Pass task to new callback
              );
            },
          ),
      ],
    );
  }
}
