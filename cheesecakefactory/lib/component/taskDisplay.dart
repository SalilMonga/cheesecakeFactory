import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Define a Task model to represent each task item.
class Task {
  final int id;
  final String name;
  final String priority;
  final String timeline;
  bool completed;

  Task({
    required this.id,
    required this.name,
    required this.priority,
    required this.timeline,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      priority: json['priority'],
      timeline: json['timeline'],
      completed: json['completed'],
    );
  }
}

// Function to load tasks from the JSON file in assets.
Future<List<Task>> loadTasks() async {
  String jsonString = await rootBundle.loadString('assets/tasks.json');
  List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((task) => Task.fromJson(task)).toList();
}

class TaskDisplayPage extends StatelessWidget {
  const TaskDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      home: TaskListPage(),
    );
  }
}

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = loadTasks();
  }

  // Toggle the completed state of a task.
  void toggleTask(Task task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  // Return a color based on the task priority.
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Task> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.completed,
                      onChanged: (bool? value) {
                        toggleTask(task);
                      },
                    ),
                    title: Text(
                      task.name,
                      style: TextStyle(
                        fontWeight: task.priority.toLowerCase() == 'high'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _getPriorityColor(task.priority),
                      ),
                    ),
                    subtitle: Text('Due: ${task.timeline}'),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading tasks: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
