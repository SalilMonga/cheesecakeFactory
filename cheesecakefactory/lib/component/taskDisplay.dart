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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskListPage(),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

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

  // Group tasks by priority (high, medium, low).
  Map<String, List<Task>> _groupTasksByPriority(List<Task> tasks) {
    final Map<String, List<Task>> grouped = {
      'High': [],
      'Medium': [],
      'Low': [],
    };

    for (var task in tasks) {
      final priority = task.priority.toLowerCase();
      if (priority == 'high') {
        grouped['High']!.add(task);
      } else if (priority == 'medium') {
        grouped['Medium']!.add(task);
      } else {
        grouped['Low']!.add(task);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurred
            return Center(
              child: Text('Error loading tasks: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            final groupedTasks = _groupTasksByPriority(tasks);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (optional)
                  // Text(
                  //   'My Tasks',
                  //   style: Theme.of(context).textTheme.headline5,
                  // ),
                  // const SizedBox(height: 16),

                  // Build a section for each priority group
                  _buildPrioritySection(
                    context,
                    priorityLabel: 'High',
                    tasks: groupedTasks['High']!,
                  ),
                  const SizedBox(height: 16),
                  _buildPrioritySection(
                    context,
                    priorityLabel: 'Medium',
                    tasks: groupedTasks['Medium']!,
                  ),
                  const SizedBox(height: 16),
                  _buildPrioritySection(
                    context,
                    priorityLabel: 'Low',
                    tasks: groupedTasks['Low']!,
                  ),
                ],
              ),
            );
          }
          // If there's no data and no error, show an empty container
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPrioritySection(
    BuildContext context, {
    required String priorityLabel,
    required List<Task> tasks,
  }) {
    // If there are no tasks in this priority, don't render a section at all.
    if (tasks.isEmpty) {
      return const SizedBox();
    }

    return ExpansionTile(
      title: Text(
        '$priorityLabel Priority (${tasks.length})',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: tasks.map((task) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            leading: Checkbox(
              shape: const CircleBorder(),
              value: task.completed,
              onChanged: (_) => toggleTask(task),
            ),
            title: Text(
              task.name,
              style: TextStyle(
                  decoration:
                      task.completed ? TextDecoration.lineThrough : null,
                  fontWeight: priorityLabel.toLowerCase() == 'high'
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: priorityLabel.toLowerCase() == 'high'
                      ? Colors.red[200]
                      : priorityLabel.toLowerCase() == 'medium'
                          ? Colors.purple[200]
                          : Colors.blue[200]),
            ),
            subtitle: task.timeline.isNotEmpty
                ? Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        task.timeline,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
