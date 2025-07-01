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

  // Private list to hold ALL Task objects fetched from the service.
  List<Task> _tasks = [];

  // Public getter to expose ALL tasks (active and completed) to the UI.
  List<Task> get tasks => _tasks;

  // NEW: Getter for active (incomplete) tasks.
  List<Task> get activeTasks => _tasks.where((task) => !task.isCompleted).toList();

  // NEW: Getter for completed tasks, sorted by completion date or creation date.
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList()
    ..sort((a, b) => (b.dueDateTime ?? b.createdAt).compareTo(a.dueDateTime ?? a.createdAt)); // Sort by due date or creation date

  // Uuid instance for generating unique IDs for new tasks.
  final Uuid _uuid = const Uuid();

  /// Constructor for TaskViewModel.
  /// It requires an instance of TaskService (dependency injection).
  TaskViewModel(this._taskService) {
    // When the ViewModel is created, we'll start listening to the entire
    // tasks box for any changes.
    _taskService.tasksBoxListenable('').addListener(_fetchTasks);
    // Initially fetch all tasks.
    _fetchTasks();
  }

  /// Fetches tasks from the service and updates the ViewModel's state.
  /// This now fetches ALL tasks, and the getters filter them.
  void _fetchTasks() {
    _tasks = _taskService.readTasks(''); // Read all tasks
    notifyListeners(); // Notify all listening widgets that the data has changed.
    print('ViewModel: Fetched ${_tasks.length} tasks (Active: ${activeTasks.length}, Completed: ${completedTasks.length}).'); // For debugging
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
    try {
      final newTask = Task(
        id: _uuid.v4(),
        title: title,
        description: description,
        isCompleted: false, // Default new tasks to not completed
        createdAt: DateTime.now(),
        taskListId: taskListId,
        dueDateTime: dueDateTime,
        isRecurring: false,
        recurrencePattern: null,
        priority: priority,
        subtasks: subtasks,
        isWishTask: isWishTask,
        wishTaskDeadline: wishTaskDeadline,
        wishTaskCompletionStatus: null,
      );
      await _taskService.createTask(newTask);
      print('ViewModel: Attempted to add task: $title');
    } catch (e) {
      print('ViewModel: Error adding task: $e');
    }
  }

  /// Toggles the completion status of a task.
  /// This method now only updates the task, it does NOT delete it.
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final taskToUpdate = _tasks.firstWhere((task) => task.id == taskId);
      taskToUpdate.isCompleted = !taskToUpdate.isCompleted; // Flip the status
      await _taskService.updateTask(taskToUpdate); // Update the task in storage
      print('ViewModel: Toggled completion for task ID: $taskId to ${taskToUpdate.isCompleted}');
    } catch (e) {
      print('ViewModel: Error toggling task completion for ID $taskId: $e');
    }
  }

  /// Updates an existing task.
  Future<void> updateTask(Task updatedTask) async {
    try {
      await _taskService.updateTask(updatedTask);
      print('ViewModel: Attempted to update task: ${updatedTask.title}');
    } catch (e) {
      print('ViewModel: Error updating task ${updatedTask.title}: $e');
    }
  }

  /// Deletes a task. (This method is kept for explicit deletion, but not used on completion toggle anymore)
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      print('ViewModel: Attempted to delete task with ID: $taskId');
    } catch (e) {
      print('ViewModel: Error deleting task with ID $taskId: $e');
    }
  }

  /// Cleans up resources when the ViewModel is no longer needed.
  @override
  void dispose() {
    _taskService.tasksBoxListenable('').removeListener(_fetchTasks);
    super.dispose();
    print('ViewModel: TaskViewModel disposed.');
  }
}
