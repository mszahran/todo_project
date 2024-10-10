import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
// Load model
import '../model/todo_model.dart';
import '../model/task_model.dart';

class TodoAddScreen extends StatefulWidget {
  final Function(Todo todo) addTodo;

  TodoAddScreen(this.addTodo);

  @override
  _TodoAddScreenState createState() => _TodoAddScreenState();
}

class _TodoAddScreenState extends State<TodoAddScreen> {
  String title = '';
  String description = '';
  List<Task> tasks = [];
  String taskName = '';
  String taskDescription = '';
  DateTime? dueDate;

  void _addTask() {
    if (taskName.isNotEmpty && taskDescription.isNotEmpty && dueDate != null) {
      final newTask = Task(
        id: DateTime.now().toString(),
        name: taskName,
        description: taskDescription,
        dueDate: dueDate!,
      );

      setState(() {
        tasks.add(newTask); // Menambahkan task ke dalam daftar
      });

      // Reset input fields setelah menambahkan task
      taskName = '';
      taskDescription = '';
      dueDate = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter task name, description, and due date.'),
        ),
      );
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          title: Text(
            'Add Task',
            style: TextStyle(
              fontFamily: 'Quicksand',
            ),
          ),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                height: height - 500,
                width: width - 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          'Task Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        taskName = value; // Menyimpan nama task
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey, // Ubah warna label di sini
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(
                                0xFFE2EBFA), // Ubah warna border saat fokus
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(
                                0xFFE2EBFA), // Ubah warna border saat fokus
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFE2EBFA),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          'Task Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        taskDescription = value; // Menyimpan deskripsi task
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey, // Ubah warna label di sini
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(
                                0xFFE2EBFA), // Ubah warna border saat fokus
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(
                                0xFFE2EBFA), // Ubah warna border saat fokus
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFE2EBFA),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          'Due Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey, // Change label color here
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(
                                0xFFE2EBFA), // Change border color when focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(
                                0xFFE2EBFA), // Change border color when enabled
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFE2EBFA),
                        hintText: dueDate != null
                            ? DateFormat('dd-MMMM-yyyy').format(
                                dueDate!) // Format and display selected date
                            : 'Select a date',
                      ),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: dueDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dueDate =
                                selectedDate; // Store the selected due date
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTask(); // Panggil fungsi untuk menambahkan task
                Navigator.of(ctx).pop(); // Menutup dialog
              },
              child: Text(
                'Add Task',
                style: TextStyle(
                  color: Color(0xFF0038FB),
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Menutup dialog tanpa menambah task
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF0038FB),
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitTodo() async {
    if (title.isNotEmpty && description.isNotEmpty && tasks.isNotEmpty) {
      final newTodo = Todo(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        tasks: tasks,
      );

      // Simpan Todo ke shared preferences
      await _saveTodoToPreferences(newTodo);

      widget.addTodo(newTodo);
      // Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please enter title, description, and add at least one task.'),
        ),
      );
    }
  }

  Future<void> _saveTodoToPreferences(Todo todo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar todo yang sudah ada, jika ada
    List<String>? existingTodos = prefs.getStringList('todos') ?? [];

    // Simpan todo baru sebagai JSON string
    // existingTodos.add(todoToJson(todo)); // Mengubah todo menjadi JSON string

    // Simpan kembali daftar todo yang sudah diperbarui
    await prefs.setStringList('todos', existingTodos);
  }

  // Fungsi untuk mengubah Todo menjadi string JSON
  String todoToJson(Todo todo) {
    return '{"id": "${todo.id}", "title": "${todo.title}", "description": "${todo.description}", "tasks": ${tasksToJson(todo.tasks)}}';
  }

  // Fungsi untuk mengubah daftar task menjadi string JSON
  String tasksToJson(List<Task> tasks) {
    return '[${tasks.map((task) => '{"id": "${task.id}", "name": "${task.name}", "description": "${task.description}", "dueDate": "${task.dueDate.toIso8601String()}"}').join(',')}]';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To-Do',
          style: TextStyle(
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  'To-Do Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ),
            ),
            TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey, // Ubah warna label di sini
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE2EBFA), // Ubah warna border saat fokus
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE2EBFA), // Ubah warna border saat fokus
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFE2EBFA),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  'To-Do Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ),
            ),
            TextField(
              onChanged: (value) {
                description = value;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey, // Ubah warna label di sini
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE2EBFA), // Ubah warna border saat fokus
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE2EBFA), // Ubah warna border saat fokus
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFE2EBFA),
              ),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Task',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
                TextButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: Icon(
                    Icons.add_outlined,
                    color: Color(0xFF0038FB),
                  ),
                  onPressed:
                      _showAddTaskDialog, // Menampilkan dialog untuk menambah task
                ),
              ],
            ),
            SizedBox(height: 20),
            // Menampilkan daftar task yang ditambahkan
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tasks[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tasks.removeAt(
                                    index); // Menghapus task berdasarkan index
                              });
                            },
                            child: Text(
                              'X',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Quicksand',
                                color: Colors
                                    .red, // Menambahkan warna merah untuk memperjelas tombol hapus
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              tasks[index].description,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                          Divider(),
                          Text(
                            'Due: ${DateFormat('dd-MM-yyyy').format(tasks[index].dueDate)}',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(
                Icons.add_outlined,
                color: Color(0xFF0038FB),
              ),
              //icon data for elevated button
              label: Text(
                'Save To-Do',
                style: TextStyle(
                  color: Color(0xFF0038FB),
                ),
              ),
              //label text
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE2EBFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _submitTodo, // Mengirimkan Todo
            ),
          ],
        ),
      ),
    );
  }
}
