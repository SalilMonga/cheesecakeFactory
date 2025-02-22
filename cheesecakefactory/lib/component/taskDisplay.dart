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

enum GroupMode { priority, date }

GroupMode _currentGroupMode = GroupMode.priority;

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

  Map<String, List<Task>> _groupTasksByDateRange(List<Task> tasks) {
    final Map<String, List<Task>> grouped = {
      'Today': [],
      'This Week': [],
      'This Month': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOfToday = today.add(const Duration(days: 1));
    final endOfWeek = today.add(const Duration(days: 7));
    final endOfMonth =
        DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));

    for (var task in tasks) {
      // Parse the task.timeline to a DateTime (assuming "2025-03-01" format)
      final taskDate = DateTime.tryParse(task.timeline);
      if (taskDate == null) continue;

      if (taskDate.isBefore(endOfToday)) {
        grouped['Today']!.add(task);
      } else if (taskDate.isBefore(endOfWeek)) {
        grouped['This Week']!.add(task);
      } else if (taskDate.isBefore(endOfMonth)) {
        grouped['This Month']!.add(task);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _currentGroupMode = _currentGroupMode == GroupMode.priority
                    ? GroupMode.date
                    : GroupMode.priority;
              });
            },
          ),
        ],
      ),
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

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          '$priorityLabel Priority (${tasks.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: priorityLabel.toLowerCase() == 'high',
        children: tasks.map((task) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            horizontalTitleGap: 2.0,
            minVerticalPadding: 0.0,
            leading: Checkbox(
              //if we need more control over spacing
              // visualDensity:
              //     const VisualDensity(horizontal: 2.0, vertical: -4.0),
              checkColor: Colors.white,
              value: task.completed,
              onChanged: (_) => toggleTask(task),
              activeColor: Colors.grey[350],
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
                      ? Colors.red[400]
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
          );
        }).toList(),
      ),
    );
  }
}
