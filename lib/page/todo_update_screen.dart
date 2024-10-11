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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String editedTitle;
  late String editedDescription;

  String editedTaskName = '';
  String editedTaskDescription = '';
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    editedTitle = widget.todo.title;
    editedDescription = widget.todo.description;

    // Inisialisasi TextEditingController dengan nilai awal
    _titleController = TextEditingController(text: editedTitle);
    _descriptionController = TextEditingController(text: editedDescription);
  }

  void _addTask() {
    if (editedTaskName.isNotEmpty &&
        editedTaskDescription.isNotEmpty &&
        dueDate != null) {
      final newTask = Task(
        id: DateTime.now().toString(),
        name: editedTaskName,
        description: editedTaskDescription,
        dueDate: dueDate!,
      );

      setState(() {
        widget.todo.tasks.add(newTask);

        // Reset input fields setelah menambahkan task
        editedTaskName = '';
        editedTaskDescription = '';
        dueDate = null;
      });

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

  void _updateTask(int index, String taskName, String taskDescription, DateTime? dueDate) {
    if (taskName.isNotEmpty && taskDescription.isNotEmpty) {
      setState(() {
        // Memperbarui task di dalam list
        widget.todo.tasks[index] = widget.todo.tasks[index].copyWith(
          name: taskName,
          description: taskDescription,
          dueDate: dueDate ?? widget.todo.tasks[index].dueDate,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task updated successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid task name and description.'),
        ),
      );
    }
  }

  // Fungsi untuk menampilkan dialog tambah task
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Gunakan StatefulBuilder untuk memperbarui nilai di dalam dialog
            return AlertDialog(
              title: Text(
                'Add New Task',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8), // Sedikit membulatkan sudut dialog
              ),
              content: Builder(
                builder: (context) {
                  var width = MediaQuery.of(context).size.width;

                  return SingleChildScrollView(
                    // Memastikan konten bisa di-scroll
                    child: Container(
                      width: width * 0.9, // Responsif terhadap lebar layar
                      child: Column(
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
                            onChanged: (value) {
                              editedTaskName =
                                  value; // Menyimpan deskripsi task
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFE2EBFA),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Task Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              editedTaskDescription =
                                  value; // Menyimpan deskripsi task
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFE2EBFA),
                            ),
                            maxLines: 5,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Due Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: dueDate != null
                                  ? DateFormat('dd-MMMM-yyyy').format(dueDate!)
                                  : 'Select a date',
                              filled: true,
                              fillColor: Color(0xFFE2EBFA),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE2EBFA)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE2EBFA)),
                              ),
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
                                  dueDate = selectedDate; // Update the due date
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addTask();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      color: Color(0xFF0038FB),
                      fontFamily: 'Quicksand',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE2EBFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFFFB8600),
                      fontFamily: 'Quicksand',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAECE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editTaskDialog(BuildContext context, int index) {
    TextEditingController _taskNameController = TextEditingController(
      text: widget.todo.tasks[index].name, // Pre-fill dengan nama task saat ini
    );
    TextEditingController _taskDescriptionController = TextEditingController(
      text: widget.todo.tasks[index].description, // Pre-fill dengan deskripsi task
    );
    DateTime? dueDate = widget.todo.tasks[index].dueDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Gunakan StatefulBuilder untuk memperbarui dialog
            return AlertDialog(
              title: Text(
                'Edit Task',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content: Builder(
                builder: (context) {
                  var width = MediaQuery.of(context).size.width;

                  return SingleChildScrollView(
                    child: Container(
                      width: width * 0.9, // Responsif terhadap lebar layar
                      child: Column(
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
                            controller: _taskNameController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFE2EBFA),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Task Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                          TextField(
                            controller: _taskDescriptionController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE2EBFA),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFE2EBFA),
                            ),
                            maxLines: 5,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Due Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: dueDate != null
                                  ? DateFormat('dd-MMMM-yyyy').format(dueDate!)
                                  : 'Select a date',
                              filled: true,
                              fillColor: Color(0xFFE2EBFA),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFE2EBFA)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFE2EBFA)),
                              ),
                            ),
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: dueDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                setStateDialog(() {
                                  dueDate = selectedDate;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _updateTask(
                      index,
                      _taskNameController.text,
                      _taskDescriptionController.text,
                      dueDate,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Update Task',
                    style: TextStyle(
                      color: Color(0xFF0038FB),
                      fontFamily: 'Quicksand',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE2EBFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFFFB8600),
                      fontFamily: 'Quicksand',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAECE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
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
              controller: _titleController, // Gunakan controller
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
              controller: _descriptionController, // Gunakan controller
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
                          PopupMenuButton<String>(
                            iconSize: 16,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editTaskDialog(context, index);
                              } else if (value == 'delete') {
                                setState(() {
                                  widget.todo.tasks
                                      .removeAt(index); // Menghapus task
                                });
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
              label: Text('Save To-Do',
                  style: TextStyle(color: Color(0xFF0038FB))),
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
