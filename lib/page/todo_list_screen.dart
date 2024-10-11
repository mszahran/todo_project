import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Load model
import '../model/todo_model.dart';
import '../model/task_model.dart';

// Load page
import './todo_add_screen.dart';
import './todo_update_screen.dart';
import './todo_detail_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Memuat todo dari SharedPreferences saat aplikasi dimulai
  }

  // Fungsi untuk memuat todos dari SharedPreferences
  Future<void> _loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoListString = prefs.getStringList('todos') ?? [];

    // Decode setiap JSON string menjadi object Todo
    List<Todo> _loadedTodos = todoListString.map((todoJson) {
      Map<String, dynamic> todoMap = jsonDecode(todoJson);
      return Todo(
        id: todoMap['id'],
        title: todoMap['title'],
        description: todoMap['description'],
        tasks: (todoMap['tasks'] as List).map((taskJson) {
          Map<String, dynamic> taskMap = taskJson;
          return Task(
            id: taskMap['id'],
            name: taskMap['name'],
            description: taskMap['description'],
            dueDate: DateTime.parse(taskMap['dueDate']),
          );
        }).toList(),
      );
    }).toList();

    setState(() {
      _todos.addAll(_loadedTodos); // Menambahkan semua todos yang sudah dimuat
    });
  }

  // Fungsi untuk menyimpan todo yang diperbarui ke SharedPreferences
  Future<void> _updateTodoInPreferences(Todo todo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todos = prefs.getStringList('todos') ?? [];

    // Hapus todo lama dari daftar
    todos.removeWhere((item) => Todo.fromJson(item).id == todo.id);

    // Tambahkan todo yang telah diperbarui
    todos.add(todo.toJson()); // Menggunakan todo.toJson()

    // Simpan kembali daftar todo yang diperbarui
    await prefs.setStringList('todos', todos);
  }

  // Fungsi untuk menghapus todo dari SharedPreferences
  Future<void> _deleteTodoFromPreferences(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingTodos = prefs.getStringList('todos') ?? [];

    // Hapus todo berdasarkan ID
    existingTodos.removeWhere((todoJson) {
      Map<String, dynamic> todoMap = jsonDecode(todoJson);
      return todoMap['id'] == id;
    });

    // Simpan kembali daftar todo yang diperbarui
    await prefs.setStringList('todos', existingTodos);
  }

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  void _deleteTodo(String id) async {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id); // Hapus dari daftar tampilan
    });
    await _deleteTodoFromPreferences(id); // Hapus dari SharedPreferences
  }

  void _navigateToAddTodo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TodoAddScreen(_addTodo),
      ),
    );
  }

  void _navigateToEditTodo(Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TodoUpdateScreen(
          todo,
          (updatedTodo) {
            setState(() {
              // Update list todo dengan todo yang telah diedit
              int index = _todos.indexWhere((t) => t.id == updatedTodo.id);
              if (index != -1) {
                _todos[index] = updatedTodo;
              }
            });
            _updateTodoInPreferences(
                updatedTodo); // Simpan perubahan ke SharedPreferences jika diperlukan
          },
        ),
      ),
    );
  }

  void _navigateToDetail(Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TodoDetailScreen(todo),
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
        child: _todos.isEmpty
            ? Center(
                child:
                    Text("No todos available.")) // Tampilkan pesan jika kosong
            : ListView.builder(
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
                      onTap: () => _navigateToDetail(_todos[index]),
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
                                  if (value == 'edit') {
                                    _navigateToEditTodo(_todos[
                                        index]); // Navigasi ke halaman edit
                                  } else if (value == 'delete') {
                                    _deleteTodo(_todos[index]
                                        .id); // Hapus berdasarkan ID
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
                          Divider(),
                          Text(
                            _todos[index].description.length > 220
                                ? '${_todos[index].description.substring(0, 220)}.....' // Batasi hingga 50 karakter dan tambahkan '...'
                                : _todos[index].description,
                            // Jika kurang dari 50 karakter, tampilkan apa adanya
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.edit_calendar_outlined,
                                    size: 14,
                                  ),
                                  Text(
                                    ' $formattedDate',
                                    // Ganti dengan due date jika ada
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'Quicksand',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.check_box_outlined,
                                    size: 14,
                                  ),
                                  Text(
                                    ' ${_todos[index].tasks.length} task(s)',
                                    // Menampilkan jumlah task
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontFamily: 'Quicksand',
                                    ),
                                  ),
                                ],
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
