// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      isCompleted: fields[3] as bool,
      createdAt: fields[4] as DateTime,
      taskListId: fields[5] as String,
      dueDateTime: fields[6] as DateTime?,
      isRecurring: fields[7] as bool,
      recurrencePattern: fields[8] as String?,
      priority: fields[9] as String?,
      subtasks: (fields[10] as List).cast<String>(),
      isWishTask: fields[11] as bool,
      wishTaskDeadline: fields[12] as DateTime?,
      wishTaskCompletionStatus: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.taskListId)
      ..writeByte(6)
      ..write(obj.dueDateTime)
      ..writeByte(7)
      ..write(obj.isRecurring)
      ..writeByte(8)
      ..write(obj.recurrencePattern)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.subtasks)
      ..writeByte(11)
      ..write(obj.isWishTask)
      ..writeByte(12)
      ..write(obj.wishTaskDeadline)
      ..writeByte(13)
      ..write(obj.wishTaskCompletionStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
