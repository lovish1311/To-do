// test/viewmodels/task_view_model_test.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/services/task_service.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:uuid/uuid.dart';

/// A simple in‑memory fake of TaskService for null‑safe testing.
class FakeTaskService implements TaskService {
  List<Task> _store = [];
  late Task lastUpdated;

  // Required by TaskViewModel constructor for listenable
  final ValueNotifier<Box<Task>?> _boxListenable = ValueNotifier(null);

  @override
  List<Task> readTasks(String listId) => List.unmodifiable(_store);

  @override
  Future<void> updateTask(Task task) async {
    lastUpdated = task;
    _store = _store.map((t) => t.id == task.id ? task : t).toList();
  }

  @override
  Future<void> createTask(Task task) async => _store.add(task);

  @override
  Future<void> deleteTask(String id) async =>
      _store.removeWhere((t) => t.id == id);

  @override
  Task? getTaskById(String id) {
    // Return the task or null
    try {
      return _store.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  ValueListenable<Box<Task>> tasksBoxListenable(String taskListId) {
    // We only need addListener()/removeListener(), the value itself is unused
    return _boxListenable as ValueListenable<Box<Task>>;
  }
}

void main() {
  late TaskViewModel viewModel;
  late FakeTaskService fakeService;
  late Task sampleTask;

  setUp(() {
    // 1) Instantiate fake service and sample task
    fakeService = FakeTaskService();
    sampleTask = Task(
      id: const Uuid().v4(),
      title: 'Sample Task',
      description: null,
      isCompleted: false,
      createdAt: DateTime.now(),
      taskListId: 'test-list',
      dueDateTime: null,
      isRecurring: false,
      recurrencePattern: null,
      priority: null,
      subtasks: const [],
      isWishTask: false,
      wishTaskDeadline: null,
      wishTaskCompletionStatus: null,
    );

    // 2) Seed the fake store
    fakeService._store = [sampleTask];

    // 3) Create the ViewModel
    viewModel = TaskViewModel(fakeService);
  });

  test('toggleTaskCompletion flips isCompleted and updates via service', () async {
    // Act
    await viewModel.toggleTaskCompletion(sampleTask.id);

    // In‑memory model
    final inMemory = viewModel.tasks.firstWhere((t) => t.id == sampleTask.id);
    expect(inMemory.isCompleted, isTrue);

    // Service recorded update
    expect(fakeService.lastUpdated.id, sampleTask.id);
    expect(fakeService.lastUpdated.isCompleted, isTrue);
  });
}
