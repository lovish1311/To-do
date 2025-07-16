// test/viewmodels/task_view_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/services/task_service.dart';
import 'package:to_do/viewmodels/task_view_model.dart';
import 'package:uuid/uuid.dart';

/// 1) A Mockito mock for your TaskService
class MockTaskService extends Mock implements TaskService {}

void main() {
  late TaskViewModel viewModel;
  late MockTaskService mockService;
  late Task sampleTask;

  setUp(() {
    // 2) Create the mock service…
    mockService = MockTaskService();

    // 3) And a sample Task
    sampleTask = Task(
      id: const Uuid().v4(),flutter test test/viewmodels/task_view_model_test.dart

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

    // 4) Stub out the service methods:
    //    - readTasks returns our single sampleTask
    //    - updateTask does nothing async
    when(mockService.readTasks(any)).thenReturn([sampleTask]);
    when(mockService.updateTask(any<Task>())).thenAnswer((_) async {});

    // 5) Finally, instantiate the VM under test
    viewModel = TaskViewModel(mockService);
  });

  test('toggleTaskCompletion flips isCompleted and calls updateTask once', () async {
    // Act: flip completion
    await viewModel.toggleTaskCompletion(sampleTask.id);

    // 1️⃣ In‑memory state should have flipped
    final inMemory = viewModel.tasks.firstWhere((t) => t.id == sampleTask.id);
    expect(inMemory.isCompleted, isTrue);

    // 2️⃣ Verify updateTask was invoked exactly once with any Task
    verify(mockService.updateTask(any<Task>())).called(1);

    // 3️⃣ Capture that argument and inspect it directly
    final capturedArgs = verify(mockService.updateTask(captureAny<Task>())).captured;
    expect(capturedArgs, isNotEmpty, reason: 'Expected updateTask to be called');

    final updatedTask = capturedArgs.single as Task;
    expect(updatedTask.id, sampleTask.id);
    expect(updatedTask.isCompleted, isTrue);
  });
}
