import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/models/task_list.dart'; // Our TaskList blueprint
import 'package:to_do/utils/constants.dart'; // Our app-wide constants (like box names)

/// Manages saving and loading TaskList data using Hive, our local database.
/// This service acts like a helpful librarian for your task lists.
class TaskListService {
  // This is where we keep a direct link to our 'task_lists' box (a storage container).
  late final Box<TaskList> _taskListBox;

  /// When the TaskListService is created, it grabs the 'task_lists' box.
  /// We assume this box is already open because we set it up in main.dart.
  TaskListService() {
    _taskListBox = Hive.box<TaskList>(AppConstants.taskListBox);
  }

  // --- Actions our librarian (TaskListService) can do with task lists ---

  /// Adds a brand new task list to our storage.
  /// If something goes wrong, it'll print a message.
  Future<void> createTaskList(TaskList taskList) async {
    try {
      // It uses the task list's unique ID as its "key" to store it.
      // Think of it like putting a new book on a shelf with a specific call number.
      await _taskListBox.put(taskList.id, taskList);
      print('✅ TaskList created: ${taskList.name}');
    } catch (e) {
      print('❌ Error creating TaskList ${taskList.name}: $e');
    }
  }

  /// Gets ALL the task lists we have saved.
  /// Returns them as a list.
  List<TaskList> readTaskLists() {
    // Just pulls out all the values (task lists) from the box.
    return _taskListBox.values.toList();
  }

  /// Finds a specific task list using its unique ID.
  /// Returns the task list if found, otherwise nothing (null).
  TaskList? getTaskListById(String id) {
    // Looks for a book with a specific call number.
    return _taskListBox.get(id);
  }

  /// Updates an existing task list.
  /// If something goes wrong, it'll print a message.
  Future<void> updateTaskList(TaskList taskList) async {
    try {
      // It finds the task list by its ID and replaces it with the updated version.
      // If a book with that call number exists, it replaces it; otherwise, it puts a new one.
      await _taskListBox.put(taskList.id, taskList);
      print('⬆️ TaskList updated: ${taskList.name}');
    } catch (e) {
      print('❌ Error updating TaskList ${taskList.name}: $e');
    }
  }

  /// Deletes a task list using its unique ID.
  /// If something goes wrong, it'll print a message.
  Future<void> deleteTaskList(String id) async {
    try {
      // Removes the book with that specific call number from the shelf.
      await _taskListBox.delete(id);
      print('🗑️ TaskList deleted with ID: $id');
    } catch (e) {
      print('❌ Error deleting TaskList with ID $id: $e');
    }
  }

  /// This is like a special alert system for our task list storage.
  /// If anything changes in the 'task_lists' box (a new list is added,
  /// one is deleted, or updated), this system will "ring a bell".
  /// Our app's display (UI) can "listen" for this bell and update itself
  /// automatically to show the latest task lists without you having to refresh!
  ValueListenable<Box<TaskList>> get taskListBoxListenable => _taskListBox.listenable();
}
