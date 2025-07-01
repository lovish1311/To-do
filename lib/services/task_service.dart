import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/models/task.dart'; // Import the Task model
import 'package:to_do/utils/constants.dart'; // Import constants for box names

/// Manages saving and loading Task data using Hive, our local database.
/// This service handles the direct interaction with the Hive box for Task objects.
class TaskService {
  // This is where we keep a direct link to our 'tasks' box.
  late final Box<Task> _taskBox;

  /// Constructor for TaskService.
  /// It assumes the 'tasks' box is already open, as configured in main.dart.
  TaskService() {
    // Ensure the box is opened with the correct Task type.
    _taskBox = Hive.box<Task>(AppConstants.taskBox);
  }

  /// Adds a new task to the storage.
  Future<void> createTask(Task task) async {
    try {
      // Use the task's unique ID as its key for storage.
      await _taskBox.put(task.id, task);
      print('✅ Task created: ${task.title}');
    } catch (e) {
      print('❌ Error creating Task ${task.title}: $e');
      // In a real app, you might log this error or show a user-friendly message.
    }
  }

  /// Reads tasks from the storage.
  /// If [taskListId] is empty, it returns all tasks.
  /// Otherwise, it filters tasks by the specified taskListId.
  List<Task> readTasks(String taskListId) {
    if (taskListId.isEmpty) {
      // Return all tasks if no specific taskListId is provided.
      return _taskBox.values.toList();
    } else {
      // Filter tasks by taskListId.
      return _taskBox.values.where((task) => task.taskListId == taskListId).toList();
    }
  }

  /// Finds a specific task by its unique ID.
  /// Returns the task if found, otherwise null.
  Task? getTaskById(String id) {
    return _taskBox.get(id);
  }

  /// Updates an existing task in the storage.
  Future<void> updateTask(Task task) async {
    try {
      // Update the task in the box using its ID as the key.
      await _taskBox.put(task.id, task);
      print('⬆️ Task updated: ${task.title}');
    } catch (e) {
      print('❌ Error updating Task ${task.title}: $e');
    }
  }

  /// Deletes a task from the storage using its unique ID.
  Future<void> deleteTask(String id) async {
    try {
      await _taskBox.delete(id);
      print('🗑️ Task deleted with ID: $id');
    } catch (e) {
      print('❌ Error deleting Task with ID $id: $e');
    }
  }

  /// Provides a ValueListenable for the entire Task box.
  /// This allows ViewModels to listen for real-time changes in the underlying data.
  /// The empty string parameter is a placeholder for potential future filtering,
  /// but for now, it returns a listener for all tasks in the box.
  ValueListenable<Box<Task>> tasksBoxListenable(String taskListId) {
    return _taskBox.listenable();
  }
}
