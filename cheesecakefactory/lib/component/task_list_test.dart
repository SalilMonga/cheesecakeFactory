import 'package:cheesecakefactory/main.dart';
import 'package:cheesecakefactory/task_database.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_section.dart';
import 'package:confetti/confetti.dart';

class TaskListPageTest extends StatefulWidget {
  const TaskListPageTest({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

enum GroupMode { priority, date }

class _TaskListPageState extends State<TaskListPageTest> {
  late Future<List<Task>> futureTasks;
  final ScrollController _scrollController = ScrollController();
  GroupMode _currentGroupMode = GroupMode.priority;
  final Set<int> _pendingCompletion = {};
  late ConfettiController _confettiController;
  double _scrollPosition = 0.0;
  get floatingActionButton => null;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    // Load tasks from the database instead of a JSON file.
    futureTasks = TaskDatabase.instance.fetchTasks();
  }

  // Toggle the completed state of a task.
  Future<void> toggleTask(Task task) async {
    if (_scrollController.hasClients) {
      _scrollPosition = _scrollController.position.pixels;
    }
    if (!task.completed && !_pendingCompletion.contains(task.id)) {
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 Task Completed! Well done! 🎉"),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        task.completed = true;
        // Since task.id is nullable, use a null check.
        if (task.id != null) _pendingCompletion.add(task.id!);
      });
      showNotification();
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          if (task.id != null) _pendingCompletion.remove(task.id);
        });
      });
      await TaskDatabase.instance.updateTask(task);
    } else {
      setState(() {
        task.completed = false;
      });
    }
    await _refreshTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollPosition);
      }
    });
  }

  Future<void> _refreshTasks() async {
    setState(() {
      futureTasks = TaskDatabase.instance.fetchTasks();
    });
  }

  Future<void> _showAddTaskDialog() async {
    final TextEditingController taskNameController = TextEditingController();
    String selectedPriority = 'High';
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // so the sheet can expand above the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          // Adjust padding so content is visible above keyboard
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              ListTile(
                // A close icon on the left and a check icon on the right
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    final name = taskNameController.text.trim();
                    if (name.isNotEmpty) {
                      final today = DateTime.now();
                      final dateToUse = selectedDate ?? today;
                      final dateString =
                          DateFormat('yyyy-MM-dd').format(dateToUse);
                      final newTask = Task(
                        name: name,
                        priority: selectedPriority.toLowerCase(),
                        timeline: dateString,
                        completed: false,
                      );
                      await TaskDatabase.instance.addTask(newTask);
                      await _refreshTasks(); // Refresh the task list!
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a task name.')),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: taskNameController,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                        hintText: 'Enter task name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'High', child: Text('High')),
                        DropdownMenuItem(
                            value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'No date chosen'
                                : DateFormat('yyyy-MM-dd')
                                    .format(selectedDate!),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: DateTime(now.year - 2),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
      body: Stack(
        children: [
          FutureBuilder<List<Task>>(
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
                    .where((t) =>
                        !t.completed ||
                        (t.id != null && _pendingCompletion.contains(t.id!)))
                    .toList();
                final completedTasks = tasks.where((t) => t.completed).toList();
                final groupedIncomplete =
                    _currentGroupMode == GroupMode.priority
                        ? _groupTasksByPriority(incompleteTasks)
                        : _groupTasksByDateRange(incompleteTasks);
                final List<String> groupOrder =
                    _currentGroupMode == GroupMode.priority
                        ? ['High', 'Medium', 'Low']
                        : ['Today', 'This Week', 'This Month'];

                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                      top: 2.0, left: 16.0, right: 16.0, bottom: 16.0),
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 30.0),
              child: FloatingActionButton(
                onPressed: _showAddTaskDialog,
                child: const Icon(Icons.add),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
