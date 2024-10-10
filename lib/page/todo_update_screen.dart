import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/task_model.dart';
import '../model/todo_model.dart';

class TodoUpdateScreen extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onSave;

  TodoUpdateScreen(this.todo, this.onSave);

  @override
  _TodoUpdateScreenState createState() => _TodoUpdateScreenState();
}

class _TodoUpdateScreenState extends State<TodoUpdateScreen> {
  late String editedTitle;
  late String editedDescription;
  DateTime? editedDueDate;

  @override
  void initState() {
    super.initState();
    editedTitle = widget.todo.title;
    editedDescription = widget.todo.description;
  }

  // Fungsi untuk menampilkan dialog tambah task
  void _showAddTaskDialog() {
    final TextEditingController taskNameController = TextEditingController();
    final TextEditingController taskDescriptionController = TextEditingController();
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Task Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ),
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              TextField(
                controller: taskDescriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await _selectDueDate();
                  if (selectedDate != null) {
                    setState(() {
                      dueDate = selectedDate;
                    });
                  }
                },
                child: Text('Select Due Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (taskNameController.text.isNotEmpty &&
                    taskDescriptionController.text.isNotEmpty &&
                    dueDate != null) {
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    name: taskNameController.text,
                    description: taskDescriptionController.text,
                    dueDate: dueDate!,
                  );

                  setState(() {
                    widget.todo.tasks.add(newTask);
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text('Add Task'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memilih due date menggunakan date picker
  Future<DateTime?> _selectDueDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  void _saveTodo() {
    // Buat objek Todo baru dengan nilai yang diperbarui
    final updatedTodo = Todo(
      id: widget.todo.id,
      title: editedTitle,
      description: editedDescription,
      tasks: widget.todo.tasks, // Tetap menggunakan task yang sudah ada
    );

    widget.onSave(updatedTodo); // Memanggil fungsi untuk menyimpan perubahan
    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'To-Do Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
            TextField(
              controller: TextEditingController(text: editedTitle),
              onChanged: (value) {
                setState(() {
                  editedTitle = value;
                });
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2EBFA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2EBFA)),
                ),
                filled: true,
                fillColor: Color(0xFFE2EBFA),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'To-Do Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
            TextField(
              controller: TextEditingController(text: editedDescription),
              onChanged: (value) {
                setState(() {
                  editedDescription = value;
                });
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2EBFA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2EBFA)),
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
                  child: Icon(Icons.add_outlined, color: Color(0xFF0038FB)),
                  onPressed: _showAddTaskDialog,
                ),
              ],
            ),
            // Menampilkan daftar task yang ditambahkan
            Expanded(
              child: ListView.builder(
                itemCount: widget.todo.tasks.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: Color(0xFFE2EBFA),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.todo.tasks[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.todo.tasks.removeAt(index); // Menghapus task
                              });
                            },
                            child: Text(
                              'X',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Quicksand',
                                color: Colors.red, // Tombol hapus warna merah
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
                              widget.todo.tasks[index].description,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.calendar_month_outlined),
                              Text(
                                'Due: ${DateFormat('dd-MM-yyyy').format(widget.todo.tasks[index].dueDate)}',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                            ],
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
              icon: Icon(Icons.add_outlined, color: Color(0xFF0038FB)),
              label: Text('Save To-Do', style: TextStyle(color: Color(0xFF0038FB))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE2EBFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _saveTodo,
            ),
          ],
        ),
      ),
    );
  }
}
