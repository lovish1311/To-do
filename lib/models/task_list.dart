import 'package:hive/hive.dart';


part 'task_list.g.dart';
@HiveType(typeId: 0)
class   TaskList extends HiveObject { // Extend HiveObject for convenience with Hive operations
  /// HiveField annotations map class fields to Hive database fields.
  /// The integer ID must be unique within this class.
  @HiveField(0)
  String id; // Unique identifier for the task list

  @HiveField(1)
  String name; // Name of the task list (e.g., "Work", "Personal")

  @HiveField(2)
  DateTime createdAt; // Timestamp when the task list was created

  /// Constructor for the TaskList model.
  TaskList({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// Override toString for better debugging and printing.
  @override
  String toString() {
    return 'TaskList(id: $id, name: $name, createdAt: $createdAt)';
  }

}
