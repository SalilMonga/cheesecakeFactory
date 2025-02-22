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

// Enum to toggle between grouping modes.
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

  // Group tasks by date range (Today, This Week, This Month).
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
        title: const Text('Tasks Lists'),
        actions: [
          // Toggle button to switch between grouping modes.
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
            // Choose the grouping method based on the current mode.
            final groupedTasks = _currentGroupMode == GroupMode.priority
                ? _groupTasksByPriority(tasks)
                : _groupTasksByDateRange(tasks);

            // Define the order in which groups should appear.
            final List<String> groupOrder =
                _currentGroupMode == GroupMode.priority
                    ? ['High', 'Medium', 'Low']
                    : ['Today', 'This Week', 'This Month'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupOrder.map((groupKey) {
                  return Column(
                    children: [
                      _buildSection(
                        context,
                        sectionTitle: groupKey,
                        tasks: groupedTasks[groupKey]!,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            );
          }
          // If there's no data and no error, show an empty container.
          return const SizedBox();
        },
      ),
    );
  }

  TextStyle getTaskTextStyle(Task task, String sectionTitle, GroupMode mode) {
    // Apply different styles based on the grouping mode and section title.
    if (mode == GroupMode.priority) {
      return TextStyle(
        decoration: task.completed ? TextDecoration.lineThrough : null,
        fontWeight: sectionTitle.toLowerCase() == 'high'
            ? FontWeight.bold
            : FontWeight.normal,
        color: sectionTitle.toLowerCase() == 'high'
            ? Colors.red[400]
            : sectionTitle.toLowerCase() == 'medium'
                ? Colors.purple[200]
                : Colors.blue[200],
      );
    } else {
      // For date grouping, customize colors as desired.
      return TextStyle(
        decoration: task.completed ? TextDecoration.lineThrough : null,
        fontWeight: sectionTitle.toLowerCase() == 'today'
            ? FontWeight.bold
            : FontWeight.normal,
        color: sectionTitle.toLowerCase() == 'today'
            ? Colors.green[400]
            : sectionTitle.toLowerCase() == 'this week'
                ? Colors.orange[400]
                : Colors.blueGrey,
      );
    }
  }

  // Generic section builder that works for both grouping modes.
  Widget _buildSection(
    BuildContext context, {
    required String sectionTitle,
    required List<Task> tasks,
  }) {
    if (tasks.isEmpty) return const SizedBox();

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          '$sectionTitle (${tasks.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Expand High priority or Today by default.
        initiallyExpanded: sectionTitle.toLowerCase() == 'high' ||
            sectionTitle.toLowerCase() == 'today',
        children: tasks.map((task) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            horizontalTitleGap: 2.0,
            minVerticalPadding: 0.0,
            leading: Checkbox(
              checkColor: Colors.white,
              value: task.completed,
              onChanged: (_) => toggleTask(task),
              activeColor: Colors.grey[350],
            ),
            title: Text(
              task.name,
              style: getTaskTextStyle(task, sectionTitle, _currentGroupMode),
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
