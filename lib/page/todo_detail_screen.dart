import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Load model
import '../model/todo_model.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  // Menerima todo sebagai parameter
  TodoDetailScreen(this.todo);

  @override
  Widget build(BuildContext context) {
    // Format date untuk tampilan due date
    String formattedDate = DateFormat('dd-MMMM-yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo Details',
          style: TextStyle(
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              todo.description,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_box_outlined,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Tasks (${todo.tasks.length}):',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todo.tasks.length,
                itemBuilder: (ctx, index) {
                  final task = todo.tasks[index];
                  return Card(
                    elevation: 2,
                    color: Color(0xFFE2EBFA),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                task.name,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.description,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              Text(
                                'Due: ${DateFormat('dd-MMM-yyyy').format(task.dueDate)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.edit_calendar_sharp,
                  size: 14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Created Date:',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              formattedDate, // Ganti dengan due date jika ada
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
