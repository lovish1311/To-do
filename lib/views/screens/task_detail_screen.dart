import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/task.dart'; // Ensure your Task model is correctly defined
import 'package:to_do/viewmodels/task_view_model.dart'; // Ensure TaskViewModel is available
import 'package:to_do/utils/app_themes.dart'; // For AppDimens and theme colors

/// A screen for adding new tasks or viewing/editing existing task details.
/// This screen uses a Scaffold but avoids the built-in AppBar, opting for a custom header.
class TaskDetailScreen extends StatefulWidget {
  // Optional: Pass an existing task to edit. If null, it's a new task.
  final Task? task;

  const TaskDetailScreen({super.key, this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Controllers for text input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State variables for other task properties
  DateTime? _selectedDueDateTime;
  String? _selectedPriority;
  List<TextEditingController> _subtaskControllers = [];
  bool _isWishTask = false;
  DateTime? _selectedWishTaskDeadline;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // If an existing task is passed, pre-fill the fields for editing
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDueDateTime = widget.task!.dueDateTime;
      _selectedPriority = widget.task!.priority;
      _isWishTask = widget.task!.isWishTask;
      _selectedWishTaskDeadline = widget.task!.wishTaskDeadline;

      // Populate subtask controllers
      if (widget.task!.subtasks.isNotEmpty) {
        _subtaskControllers = widget.task!.subtasks
            .map((subtask) => TextEditingController(text: subtask))
            .toList();
      }
    } else {
      // Add one empty subtask controller for new tasks by default
      _subtaskControllers.add(TextEditingController());
    }
  }

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Handles picking a date and time for due date or wish task deadline.
  Future<void> _pickDateTime(bool isDueDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (isDueDate ? _selectedDueDateTime : _selectedWishTaskDeadline) ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Allow past dates for existing tasks
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 years into the future
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            (isDueDate ? _selectedDueDateTime : _selectedWishTaskDeadline) ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isDueDate) {
            _selectedDueDateTime = combinedDateTime;
          } else {
            _selectedWishTaskDeadline = combinedDateTime;
          }
        });
      }
    }
  }

  /// Adds a new subtask input field.
  void _addSubtaskField() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  /// Removes a subtask input field at a given index.
  void _removeSubtaskField(int index) {
    setState(() {
      _subtaskControllers[index].dispose(); // Dispose controller to prevent memory leaks
      _subtaskControllers.removeAt(index);
    });
  }

  /// Handles saving the task (add or update).
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

      final List<String> subtasks = _subtaskControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty) // Only save non-empty subtasks
          .toList();

      if (widget.task == null) {
        // Add new task
        await taskViewModel.addTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          taskListId: 'default_list_id', // Placeholder for now, refine later
          dueDateTime: _selectedDueDateTime,
          priority: _selectedPriority,
          subtasks: subtasks,
          isWishTask: _isWishTask,
          wishTaskDeadline: _isWishTask ? _selectedWishTaskDeadline : null,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "${_titleController.text}" added!')),
        );
      } else {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          dueDateTime: _selectedDueDateTime,
          priority: _selectedPriority,
          subtasks: subtasks,
          isWishTask: _isWishTask,
          wishTaskDeadline: _isWishTask ? _selectedWishTaskDeadline : null,
        );
        await taskViewModel.updateTask(updatedTask);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "${_titleController.text}" updated!')),
        );
      }
      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows content to resize when keyboard appears
      backgroundColor: colorScheme.background,
      body: SafeArea( // Ensures content is not obscured by system UI (notch, status bar)
        child: SingleChildScrollView( // Allows content to scroll if it overflows vertically
          padding: const EdgeInsets.all(AppDimens.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
              children: [
                // --- Custom Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
                      onPressed: () => Navigator.of(context).pop(), // Go back button
                    ),
                    Text(
                      widget.task == null ? 'New Task' : 'Edit Task',
                      style: textTheme.headlineMedium?.copyWith(color: colorScheme.onBackground),
                    ),
                    // Placeholder to balance the row if needed, or another action button
                    IconButton(
                      icon: Icon(Icons.check, color: colorScheme.primary),
                      onPressed: _saveTask,
                      tooltip: 'Save Task',
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.screenPadding * 1.5), // Spacing after header

                // --- Task Title Input ---
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'e.g., Buy groceries',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimens.screenPadding),

                // --- Task Description Input ---
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'e.g., Milk, eggs, bread',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  maxLines: 3,
                ),
                SizedBox(height: AppDimens.screenPadding),

                // --- Due Date & Time Picker ---
                ListTile(
                  title: Text(
                    _selectedDueDateTime == null
                        ? 'Set Due Date & Time (Optional)'
                        : 'Due: ${_selectedDueDateTime!.toLocal().toString().split('.')[0]}', // Format date/time
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  ),
                  trailing: _selectedDueDateTime != null
                      ? IconButton(
                    icon: Icon(Icons.clear, color: colorScheme.error),
                    onPressed: () {
                      setState(() {
                        _selectedDueDateTime = null;
                      });
                    },
                  )
                      : null,
                  onTap: () => _pickDateTime(true),
                  tileColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                  ),
                ),
                SizedBox(height: AppDimens.screenPadding),

                // --- Priority Dropdown ---
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Priority (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  items: <String>['Low', 'Medium', 'High']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  },
                ),
                SizedBox(height: AppDimens.screenPadding),

                // --- Subtasks Section ---
                Text(
                  'Subtasks',
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.onBackground),
                ),
                SizedBox(height: AppDimens.cardMargin),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                  itemCount: _subtaskControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.cardMargin / 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _subtaskControllers[index],
                              decoration: InputDecoration(
                                hintText: 'Subtask ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                                ),
                                filled: true,
                                fillColor: colorScheme.surface,
                                hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                              ),
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                            ),
                          ),
                          if (_subtaskControllers.length > 1 || index == 0) // Allow removing all but first, or if more than one
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
                              onPressed: () => _removeSubtaskField(index),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addSubtaskField,
                    icon: Icon(Icons.add, color: colorScheme.primary),
                    label: Text('Add Subtask', style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary)),
                  ),
                ),
                SizedBox(height: AppDimens.screenPadding),

                // --- Is Wish Task Switch ---
                SwitchListTile(
                  title: Text(
                    'Is this a Wish Task?',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  ),
                  value: _isWishTask,
                  onChanged: (bool value) {
                    setState(() {
                      _isWishTask = value;
                      if (!value) {
                        _selectedWishTaskDeadline = null; // Clear deadline if not a wish task
                      }
                    });
                  },
                  tileColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                  ),
                ),
                SizedBox(height: AppDimens.screenPadding),

                // --- Wish Task Deadline Picker (Conditional) ---
                if (_isWishTask)
                  ListTile(
                    title: Text(
                      _selectedWishTaskDeadline == null
                          ? 'Set Wish Task Deadline (Optional)'
                          : 'Deadline: ${_selectedWishTaskDeadline!.toLocal().toString().split('.')[0]}',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                    ),
                    trailing: _selectedWishTaskDeadline != null
                        ? IconButton(
                      icon: Icon(Icons.clear, color: colorScheme.error),
                      onPressed: () {
                        setState(() {
                          _selectedWishTaskDeadline = null;
                        });
                      },
                    )
                        : null,
                    onTap: () => _pickDateTime(false),
                    tileColor: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                    ),
                  ),
                if (_isWishTask) SizedBox(height: AppDimens.screenPadding),

                // --- Save Button ---
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: Icon(Icons.save, color: colorScheme.onPrimary),
                    label: Text(
                      widget.task == null ? 'Add Task' : 'Update Task',
                      style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.screenPadding * 2, vertical: AppDimens.screenPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
                      ),
                      elevation: AppDimens.cardElevation,
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.screenPadding), // Extra space at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
