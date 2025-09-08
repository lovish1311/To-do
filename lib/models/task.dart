import 'package:hive/hive.dart';

// Generates task.g.dart
part 'task.g.dart';

/// @HiveType annotation tells Hive to generate an adapter for this class.
/// typeId must be unique across all HiveTypes in your project.
@HiveType(typeId: 1) // Using typeId 1 for Task (TaskList used typeId 0)
class Task extends HiveObject {
  /// @HiveField annotations mark the fields to be persisted by Hive.
  /// fieldId must be unique within this class.

  @HiveField(0)
  final String id; // CHANGED: Unique identifier for the task, now final (immutable)

  @HiveField(1)
  String title; // Main description of the task

  @HiveField(2)
  String? description; // Optional detailed description, nullable

  @HiveField(3)
  bool isCompleted; // Whether the task is completed or not

  @HiveField(4)
  final DateTime createdAt; // CHANGED: Timestamp when the task was created, now final (immutable)

  @HiveField(5)
  final String taskListId; // CHANGED: ID of the TaskList this task belongs to, now final (immutable)

  @HiveField(6)
  DateTime? dueDateTime; // Optional general due date and time for scheduling

  @HiveField(7)
  bool isRecurring; // Flag to indicate if the task is recurring

  @HiveField(8)
  String? recurrencePattern; // Stores the recurrence pattern (e.g., "DAILY", "WEEKLY", custom string)

  @HiveField(9)
  String? priority; // Priority of the task, now nullable (e.g., 'low', 'medium', 'high', or null)

  @HiveField(10)
  List<String> subtasks; // A list of subtask descriptions

  @HiveField(11) // New field ID for wish task flag
  bool isWishTask; // True if this task is a special 'Wish Task'

  @HiveField(12) // New field ID for wish task deadline
  DateTime? wishTaskDeadline; // The "upto when" deadline specifically for Wish Tasks

  @HiveField(13) // New field ID for wish task specific completion status
  String? wishTaskCompletionStatus; // Stores specific status for wish tasks: 'delayed_regret', 'completed_wish', etc.

  // Constructor for the Task class
  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    required this.taskListId,
    this.dueDateTime,
    this.isRecurring = false,
    this.recurrencePattern,
    this.priority,
    this.subtasks = const [],
    this.isWishTask = false,
    this.wishTaskDeadline,
    this.wishTaskCompletionStatus,
  });

  /// Creates a new [Task] instance with updated values.
  /// This is a common pattern for immutable classes to allow "modifications"
  /// by creating a new instance with desired changes.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? taskListId,
    DateTime? dueDateTime,
    bool? isRecurring,
    String? recurrencePattern,
    String? priority,
    List<String>? subtasks,
    bool? isWishTask,
    DateTime? wishTaskDeadline,
    String? wishTaskCompletionStatus,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      taskListId: taskListId ?? this.taskListId,
      dueDateTime: dueDateTime,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      priority: priority ?? this.priority,
      subtasks: subtasks ?? this.subtasks,
      isWishTask: isWishTask ?? this.isWishTask,
      wishTaskDeadline: wishTaskDeadline,
      wishTaskCompletionStatus: wishTaskCompletionStatus ?? this.wishTaskCompletionStatus,
    );
  }
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      taskListId: json['taskListId'] as String,
      dueDateTime: json['dueDateTime'] != null ? DateTime.parse(json['dueDateTime'] as String) : null,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] as String?,
      priority: json['priority'] as String?,
      subtasks: (json['subtasks'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isWishTask: json['isWishTask'] as bool? ?? false,
      wishTaskDeadline: json['wishTaskDeadline'] != null ? DateTime.parse(json['wishTaskDeadline'] as String) : null,
      wishTaskCompletionStatus: json['wishTaskCompletionStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'taskListId': taskListId,
      'dueDateTime': dueDateTime?.toIso8601String(),
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
      'priority': priority,
      'subtasks': subtasks,
      'isWishTask': isWishTask,
      'wishTaskDeadline': wishTaskDeadline?.toIso8601String(),
      'wishTaskCompletionStatus': wishTaskCompletionStatus,
    };
  }


  // Optional: A toString method for easy debugging
  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted, '
        'createdAt: $createdAt, taskListId: $taskListId, '
        'dueDateTime: $dueDateTime, isRecurring: $isRecurring, '
        'recurrencePattern: $recurrencePattern, '
        'priority: $priority, subtasks: $subtasks, '
        'isWishTask: $isWishTask, wishTaskDeadline: $wishTaskDeadline, '
        'wishTaskCompletionStatus: $wishTaskCompletionStatus)';
  }
}
