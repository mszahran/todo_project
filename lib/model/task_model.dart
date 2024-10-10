// model/task_model.dart
class Task {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
  });
}
