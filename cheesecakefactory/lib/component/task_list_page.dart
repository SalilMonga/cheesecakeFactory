import 'package:flutter/material.dart';
import 'task.dart';
import 'task_section.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<List<Task>> futureTasks;
  GroupMode _currentGroupMode = GroupMode.priority;
  final Set<int> _pendingCompletion = {};

  @override
  void initState() {
    super.initState();
    futureTasks = loadTasks();
  }

  // Toggle the completed state of a task.
  void toggleTask(Task task) {
    if (!task.completed && !_pendingCompletion.contains(task.id)) {
      // Mark task as pending so we can animate the strike-through.
      setState(() {
        task.completed = true;
        _pendingCompletion.add(task.id);
      });
      // Wait for the animation duration before marking it complete.
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _pendingCompletion.remove(task.id);
        });
      });
    } else {
      // When toggling back (or uncompleting), update immediately.
      setState(() {
        task.completed = false;
      });
    }
  }

  // Group tasks by priority.
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

  // Group tasks by date range.
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
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.priority_high,
              color: _currentGroupMode == GroupMode.priority
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _currentGroupMode = GroupMode.priority;
              });
            },
            tooltip: 'Group by Priority',
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: _currentGroupMode == GroupMode.date
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _currentGroupMode = GroupMode.date;
              });
            },
            tooltip: 'Group by Date',
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading tasks: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            final incompleteTasks = tasks
                .where((t) => !t.completed || _pendingCompletion.contains(t.id))
                .toList();
            final completedTasks = tasks.where((t) => t.completed).toList();
            final groupedIncomplete = _currentGroupMode == GroupMode.priority
                ? _groupTasksByPriority(incompleteTasks)
                : _groupTasksByDateRange(incompleteTasks);
            // final groupedTasks = _currentGroupMode == GroupMode.priority
            //     ? _groupTasksByPriority(tasks)
            //     : _groupTasksByDateRange(tasks);
            final List<String> groupOrder =
                _currentGroupMode == GroupMode.priority
                    ? ['High', 'Medium', 'Low']
                    : ['Today', 'This Week', 'This Month'];

            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 2.0,
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...groupOrder.map((groupKey) {
                    return Column(
                      children: [
                        TaskSection(
                          sectionTitle: groupKey,
                          tasks: groupedIncomplete[groupKey]!,
                          groupMode: _currentGroupMode,
                          onToggleTask: toggleTask,
                          pendingCompletion: _pendingCompletion,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                  if (completedTasks.isNotEmpty) ...[
                    const Divider(),
                    TaskSection(
                      sectionTitle: 'Completed',
                      tasks: completedTasks,
                      groupMode: _currentGroupMode,
                      onToggleTask: toggleTask,
                      pendingCompletion: _pendingCompletion,
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
