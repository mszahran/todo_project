// model/todo_model.dart
import 'task_model.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final List<Task> tasks;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.tasks,
  });
}
