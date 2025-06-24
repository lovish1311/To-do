import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider to use ChangeNotifier
import 'package:to_do/models/task_list.dart'; // Import the TaskList model
import 'package:to_do/services/task_list_service.dart'; // Import the TaskListService
import 'package:uuid/uuid.dart'; // For generating unique IDs

/// TaskListViewModel manages the state and business logic for TaskList objects.
/// It extends ChangeNotifier to notify its listeners (UI widgets) about changes,
/// triggering UI rebuilds when data updates.
class TaskListViewModel extends ChangeNotifier {
  // Instance of TaskListService to interact with the Hive database.
  final TaskListService _taskListService;

  // Private list to hold TaskList objects. This is the "state" managed by the ViewModel.
  // When this list changes, the UI listening to this ViewModel will update.
  List<TaskList> _taskLists = [];

  // Public getter to expose the list of TaskLists to the UI.
  // The UI will use this to display the current task lists.
  List<TaskList> get taskLists => _taskLists;

  // Uuid instance for generating unique IDs for new task lists.
  // Using UUID ensures globally unique identifiers for our task lists.
  final Uuid _uuid = const Uuid();

  /// Constructor for TaskListViewModel.
  /// It requires an instance of TaskListService (dependency injection).
  TaskListViewModel(this._taskListService) {
    // Immediately fetch existing task lists when the ViewModel is created.
    _fetchTaskLists();
    // Listen for changes in the Hive box via the service.
    // When the underlying data in Hive changes (e.g., another part of the app
    // modifies a task list, or if the user performs an action), this listener
    // will trigger _fetchTaskLists, ensuring our ViewModel's state is always
    // in sync with the database.
    _taskListService.taskListBoxListenable.addListener(_fetchTaskLists);
  }

  /// Fetches all task lists from the service and updates the ViewModel's state.
  /// This method is called internally and also serves as the listener for Hive changes.
  void _fetchTaskLists() {
    _taskLists = _taskListService.readTaskLists();
    // Notify all listening widgets (Consumers) that the data has changed.
    // This prompts them to rebuild and display the updated list of task lists.
    notifyListeners();
    print('ViewModel: Fetched ${_taskLists.length} task lists.'); // For debugging
  }

  /// Adds a new task list.
  /// This method is called from the UI (e.g., when the user submits a new task list name).
  Future<void> addTaskList(String name) async {
    // Create a new TaskList object with a unique ID and current timestamp.
    final newTaskList = TaskList(
      id: _uuid.v4(), // Generate a unique UUID (version 4)
      name: name,
      createdAt: DateTime.now(),
    );
    // Use the TaskListService to persist the new task list to Hive.
    await _taskListService.createTaskList(newTaskList);
    // After the service operation completes, the Hive box's listenable will
    // automatically trigger the _fetchTaskLists method, which in turn calls
    // notifyListeners(). This means the UI will update without explicit
    // notifyListeners() calls directly after each CRUD operation here,
    // ensuring data consistency.
    print('ViewModel: Attempted to add task list: $name'); // For debugging
  }

  /// Updates an existing task list.
  /// This method is called from the UI (e.g., when the user edits a task list name).
  Future<void> updateTaskList(String id, String newName) async {
    // Find the task list in the current list by its ID.
    // .firstWhere will throw an error if no matching ID is found,
    // robust apps might use .firstWhereOrNull or handle the case.
    final taskListToUpdate = _taskLists.firstWhere((list) => list.id == id);
    taskListToUpdate.name = newName; // Update the name property of the found object.
    // Use the TaskListService to update the task list in Hive.
    await _taskListService.updateTaskList(taskListToUpdate);
    // UI update handled by the listenable.
    print('ViewModel: Attempted to update task list ID: $id to $newName'); // For debugging
  }

  /// Deletes a task list.
  /// This method is called from the UI (e.g., when the user clicks a delete button).
  Future<void> deleteTaskList(String id) async {
    // Use the TaskListService to delete the task list from Hive by its ID.
    await _taskListService.deleteTaskList(id);
    // UI update handled by the listenable.
    print('ViewModel: Attempted to delete task list with ID: $id'); // For debugging
  }

  /// Cleans up resources when the ViewModel is no longer needed.
  /// This is critical to prevent memory leaks, especially with listeners.
  /// When a ViewModel is removed from the widget tree (e.g., navigating away
  /// from a screen that uses it, and no other part of the app is holding a reference),
  /// its dispose method is called.
  @override
  void dispose() {
    // Remove the listener to _taskListService's box updates.
    // If not removed, the ViewModel might still try to update after being disposed,
    // leading to errors and memory leaks.
    _taskListService.taskListBoxListenable.removeListener(_fetchTaskLists);
    super.dispose(); // Always call super.dispose()
    print('ViewModel: TaskListViewModel disposed.'); // For debugging
  }
}
