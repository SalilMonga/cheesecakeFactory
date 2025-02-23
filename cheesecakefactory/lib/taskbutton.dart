import 'package:flutter/material.dart';
import 'component/task.dart';
import 'task_db.dart';
import 'task_database.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _controller = TextEditingController();
  final TaskDatabase _taskDatabase = TaskDatabase.instance;
  List<TaskDB> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final tasks = await _taskDatabase.fetchTasks();
    setState(() {
      _tasks = tasks.cast<TaskDB>();
    });
  }

  Future<void> _addTask(String text) async {
    final task = TaskDB(text: text);
    await _taskDatabase.addTask(task as Task);
    _controller.clear();
    _fetchTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _taskDatabase.deleteTask(id);
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addTask(_controller.text);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.text),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(task.id!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
