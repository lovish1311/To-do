import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/models/task.dart'; // Our Task blueprint
import 'package:to_do/utils/constants.dart'; // Our app-wide constants (like box names)

/// Manages saving and loading individual Task data using Hive, our local database.
/// This service is like a specialized librarian for all your specific tasks.
class TaskService {
  // This is where we keep a direct link to our 'tasks' box (a storage container for all tasks).
  late final Box<Task> _taskBox;

  /// When the TaskService is created, it grabs the 'tasks' box.
  /// We assume this box is already open because we set it up in main.dart.
  TaskService() {
    // We are opening a box of type Task.
    _taskBox = Hive.box<Task>(AppConstants.taskBox);
  }

  // --- Actions our librarian (TaskService) can do with individual tasks ---

  /// Adds a brand new task to our storage.
  /// If something goes wrong, it'll print a message.
  Future<void> createTask(Task task) async {
    try {
      // It uses the task's unique ID as its "key" to store it.
      // Each task gets its own spot on the shelf, identified by its ID.
      await _taskBox.put(task.id, task);
      print('✅ Task created: ${task.title} for TaskList ID: ${task.taskListId}');
    } catch (e) {
      print('❌ Error creating Task ${task.title}: $e');
    }
  }

  /// Gets ALL the tasks for a specific task list.
  /// Returns them as a list.
  /// We filter the tasks based on the taskListId they belong to.
  List<Task> readTasks(String taskListId) {
    // Pulls out all values from the task box and then filters them
    // to only include tasks that belong to the specified taskListId.
    return _taskBox.values.where((task) => task.taskListId == taskListId).toList();
  }

  /// Finds a specific task using its unique ID.
  /// Returns the task if found, otherwise nothing (null).
  Task? getTaskById(String id) {
    // Looks for a specific task by its unique ID.
    return _taskBox.get(id);
  }

  /// Updates an existing task.
  /// If something goes wrong, it'll print a message.
  Future<void> updateTask(Task task) async {
    try {
      // It finds the task by its ID and replaces it with the updated version.
      await _taskBox.put(task.id, task);
      print('⬆️ Task updated: ${task.title}');
    } catch (e) {
      print('❌ Error updating Task ${task.title}: $e');
    }
  }

  /// Deletes a task using its unique ID.
  /// If something goes wrong, it'll print a message.
  Future<void> deleteTask(String id) async {
    try {
      // Removes the task with that specific ID from the storage.
      await _taskBox.delete(id);
      print('🗑️ Task deleted with ID: $id');
    } catch (e) {
      print('❌ Error deleting Task with ID $id: $e');
    }
  }

  /// This provides a special alert system specifically for tasks within a given task list.
  /// If any task (belonging to the specified taskListId) is added, deleted, or updated,
  /// this system will "ring a bell".
  /// Our app's display (UI) can "listen" for this bell and update itself
  /// automatically to show the latest tasks for that specific list.
  ValueListenable<Box<Task>> tasksBoxListenable(String taskListId) {
    // We return a listenable for the entire Box<Task> and expect the ViewModel
    // to filter based on taskListId, similar to how readTasks works.
    // Hive's listenable doesn't directly support filtering by field.
    return _taskBox.listenable();
  }
}
