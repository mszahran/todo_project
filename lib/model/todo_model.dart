// model/todo_model.dart
import 'dart:convert';

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

  // Fungsi untuk mengonversi JSON string menjadi objek Todo
  factory Todo.fromJson(String source) {
    final Map<String, dynamic> data = json.decode(source);
    return Todo(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      tasks: (data['tasks'] as List<dynamic>)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList(),
    );
  }

  // Fungsi untuk mengonversi objek Todo menjadi JSON string
  String toJson() {
    return json.encode({
      'id': id,
      'title': title,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    });
  }
}
