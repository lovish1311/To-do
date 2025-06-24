import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider to access the ViewModel
import 'package:to_do/models/task_list.dart'; // Import TaskList model
import 'package:to_do/viewmodels/task_list_view_model.dart'; // Import our ViewModel

/// TaskListsScreen displays a list of task lists and allows for their management.
/// It consumes the TaskListViewModel to react to data changes and trigger operations.
class TaskListsScreen extends StatefulWidget {
  const TaskListsScreen({super.key});

  @override
  State<TaskListsScreen> createState() => _TaskListsScreenState();
}

class _TaskListsScreenState extends State<TaskListsScreen> {
  @override
  void initState() {
    super.initState();
    // In MVVM with Provider and a service that listens to Hive,
    // the ViewModel already fetches data on creation and listens for changes.
    // So, no explicit data fetching is needed in initState here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Task Lists',
          style: TextStyle(color: Colors.white), // Ensures text is visible on colored AppBar
        ),
        backgroundColor: Colors.blue, // Theme color for the AppBar
        foregroundColor: Colors.white, // Color for icons and text on the AppBar
      ),
      body: Consumer<TaskListViewModel>(
        // The Consumer widget listens to TaskListViewModel.
        // When taskListViewModel.notifyListeners() is called, this builder rebuilds.
        builder: (context, taskListViewModel, child) {
          // Check if there are no task lists.
          if (taskListViewModel.taskLists.isEmpty) {
            return const Center(
              child: Text(
                'No task lists yet. Add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // If task lists exist, display them in a scrollable list.
          return ListView.builder(
            itemCount: taskListViewModel.taskLists.length,
            itemBuilder: (context, index) {
              final taskList = taskListViewModel.taskLists[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 4.0, // Adds a shadow below the card
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    taskList.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    // Format the creation date to show only the date part.
                    'Created: ${taskList.createdAt.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Keep Row as small as possible
                    children: [
                      // Edit button for the task list
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: Implement navigation to TaskListFormDialog for editing.
                          // This will be done in the next WBS item (3.2).
                          _showEditTaskListDialog(context, taskListViewModel, taskList);
                          print('Edit ${taskList.name} button pressed.');
                        },
                      ),
                      // Delete button for the task list
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show a confirmation dialog before deleting to prevent accidental deletion.
                          _showDeleteConfirmationDialog(context, taskListViewModel, taskList);
                          print('Delete ${taskList.name} button pressed.');
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Implement navigation to a screen showing individual tasks within this list.
                    // This will be a later feature.
                    print('Tapped on ${taskList.name}');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to add a new task list when the FAB is pressed.
          _showAddTaskListDialog(context);
          print('Add new TaskList Floating Action Button pressed.');
        },
        tooltip: 'Add Task List', // Text shown on long press
        child: const Icon(Icons.add), // Plus icon
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a task list.
  /// This prevents accidental data loss.
  void _showDeleteConfirmationDialog(
      BuildContext context, TaskListViewModel viewModel, TaskList taskList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${taskList.name}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                viewModel.deleteTaskList(taskList.id); // Call ViewModel to delete
                Navigator.of(context).pop(); // Dismiss dialog after deletion
                // Show a brief message (SnackBar) to confirm deletion.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${taskList.name}" deleted.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog to add a new task list.
  /// This dialog contains a text field for the user to enter the task list name.
  void _showAddTaskListDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Task List'),
          content: TextField(
            controller: controller,
            autofocus: true, // Automatically focus the text field
            decoration: const InputDecoration(hintText: 'Enter task list name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  // Access the ViewModel using Provider and call addTaskList.
                  // listen: false because we are only calling a method, not listening to state changes here.
                  Provider.of<TaskListViewModel>(context, listen: false)
                      .addTaskList(controller.text);
                  Navigator.of(context).pop(); // Dismiss dialog
                  // Show a brief message (SnackBar) to confirm addition.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task list "${controller.text}" added.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog to edit an existing task list.
  /// This dialog prepopulates the text field with the current task list name.
  void _showEditTaskListDialog(
      BuildContext context, TaskListViewModel viewModel, TaskList taskList) {
    TextEditingController controller = TextEditingController(text: taskList.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task List'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'New task list name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (controller.text.isNotEmpty && controller.text != taskList.name) {
                  // Only update if the name has actually changed
                  viewModel.updateTaskList(taskList.id, controller.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task list updated to "${controller.text}".')),
                  );
                } else {
                  Navigator.of(context).pop(); // Dismiss if no change or empty
                }
              },
            ),
          ],
        );
      },
    );
  }
}
