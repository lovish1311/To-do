import 'package:flutter/material.dart';
import 'package:to_do/models/task.dart'; // Import the Task model
import 'package:to_do/services/task_service.dart'; // Import the TaskService
import 'package:uuid/uuid.dart'; // For generating unique IDs

/// TaskViewModel manages the state and business logic for individual Task objects.
/// It interacts with the TaskService to persist data and notifies its listeners (UI widgets)
/// about changes, triggering UI rebuilds.
class TaskViewModel extends ChangeNotifier {
  // Instance of TaskService to interact with the Hive database for Tasks.
  final TaskService _taskService;

  // Private list to hold Task objects. This is the "state" managed by the ViewModel.
  // This list will typically contain tasks filtered for a specific TaskList,
  // or all tasks if we choose to display them globally.
  List<Task> _tasks = [];

  // Public getter to expose the list of Tasks to the UI.
  List<Task> get tasks => _tasks;

  // Uuid instance for generating unique IDs for new tasks.
  final Uuid _uuid = const Uuid();

  /// Constructor for TaskViewModel.
  /// It requires an instance of TaskService (dependency injection).
  TaskViewModel(this._taskService) {
    // When the ViewModel is created, we'll start listening to the entire
    // tasks box for any changes. Filtering for a specific task list will
    // be done in the _fetchTasks method.
    _taskService.tasksBoxListenable('').addListener(_fetchTasks);
    // Initially fetch all tasks (or tasks for a default list if one exists)
    // When no task list is active, this will fetch all tasks.
    // We will refine this later when navigating between TaskLists.
    _fetchTasks();
  }

  /// Fetches tasks from the service and updates the ViewModel's state.
  /// Currently, this fetches all tasks. We'll adjust it to filter by taskListId
  /// when we implement navigation from TaskListsScreen to TaskDetailsScreen.
  void _fetchTasks() {
    // For now, we're assuming a "global" view of all tasks if no specific taskListId is provided.
    // When we navigate from a TaskList, this method will be adapted to take a taskListId.
    _tasks = _taskService.readTasks(''); // Pass an empty string for now, to read all tasks.
    notifyListeners(); // Notify all listening widgets that the data has changed.
    print('ViewModel: Fetched ${_tasks.length} tasks.'); // For debugging
  }

  /// Adds a new task.
  Future<void> addTask({
    required String title,
    String? description,
    required String taskListId, // The ID of the TaskList this task belongs to
    DateTime? dueDateTime,
    String? priority,
    List<String> subtasks = const [],
    bool isWishTask = false,
    DateTime? wishTaskDeadline,
  }) async {
    try { // Encapsulated in try-catch as per requirement
      final newTask = Task(
        id: _uuid.v4(),
        title: title,
        description: description,
        isCompleted: false, // Default new tasks to not completed
        createdAt: DateTime.now(),
        taskListId: taskListId,
        dueDateTime: dueDateTime,
        isRecurring: false, // Default new tasks to not recurring
        recurrencePattern: null,
        priority: priority,
        subtasks: subtasks,
        isWishTask: isWishTask,
        wishTaskDeadline: wishTaskDeadline,
        wishTaskCompletionStatus: null, // Default
      );
      await _taskService.createTask(newTask);
      // UI update handled by the listenable automatically
      print('ViewModel: Attempted to add task: $title');
    } catch (e) {
      print('ViewModel: Error adding task: $e');
      // Optionally show a user-friendly message or log to a crash reporting tool
    }
  }

  /// Toggles the completion status of a task.
  Future<void> toggleTaskCompletion(String taskId) async {
    try { // Encapsulated in try-catch as per requirement
      final taskToUpdate = _tasks.firstWhere((task) => task.id == taskId);
      taskToUpdate.isCompleted = !taskToUpdate.isCompleted; // Flip the status
      await _taskService.updateTask(taskToUpdate);
      print('ViewModel: Toggled completion for task ID: $taskId to ${taskToUpdate.isCompleted}');
    } catch (e) {
      print('ViewModel: Error toggling task completion for ID $taskId: $e');
      // Optionally show a user-friendly message
    }
  }

  /// Updates an existing task.
  Future<void> updateTask(Task updatedTask) async {
    try { // Encapsulated in try-catch as per requirement
      // The updatedTask object already contains the new values.
      await _taskService.updateTask(updatedTask);
      print('ViewModel: Attempted to update task: ${updatedTask.title}');
    } catch (e) {
      print('ViewModel: Error updating task ${updatedTask.title}: $e');
      // Optionally show a user-friendly message
    }
  }

  /// Deletes a task.
  Future<void> deleteTask(String taskId) async {
    try { // Encapsulated in try-catch as per requirement
      await _taskService.deleteTask(taskId);
      print('ViewModel: Attempted to delete task with ID: $taskId');
    } catch (e) {
      print('ViewModel: Error deleting task with ID $taskId: $e');
      // Optionally show a user-friendly message
    }
  }

  /// Cleans up resources when the ViewModel is no longer needed.
  @override
  void dispose() {
    // Remove the listener to _taskService's box updates to prevent memory leaks.
    // The `listenable()` method requires a `taskListId` parameter for the specific listener,
    // so we call it with the same parameter as in the constructor.
    _taskService.tasksBoxListenable('').removeListener(_fetchTasks);
    super.dispose();
    print('ViewModel: TaskViewModel disposed.');
  }
}
