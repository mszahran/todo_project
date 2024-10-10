import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Load model
import '../model/todo_model.dart';
// Load page
import './todo_add_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) =>
          todo.title == id); // Update logika penghapusan jika diperlukan
    });
  }

  void _navigateToAddTodo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TodoAddScreen(_addTodo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          style: TextStyle(
            fontFamily: 'Quicksand',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Color(0xFF0038FB),
            ),
            onPressed: _navigateToAddTodo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (ctx, index) {
            String formattedDate = DateFormat('dd-MMMM-yyyy')
                .format(DateTime.now()); // Update jika ada due date

            return Card(
              color: Color(0xFFE2EBFA),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _todos[index].title,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteTodo(_todos[index].title); // Sesuaikan ID
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_outline),
                                title: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    Text(
                      _todos[index].description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    Divider(),
                    // Menambahkan tampilan jumlah task
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: $formattedDate',
                          // Ganti dengan due date jika ada
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        Text(
                          'Tasks: ${_todos[index].tasks.length} task(s)',
                          // Menampilkan jumlah task
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
