import 'package:flutter/material.dart';
import 'task.dart';
import 'task_tile.dart';

class TaskSection extends StatelessWidget {
  final String sectionTitle;
  final List<Task> tasks;
  final GroupMode groupMode;
  final Function(Task) onToggleTask;

  const TaskSection({
    Key? key,
    required this.sectionTitle,
    required this.tasks,
    required this.groupMode,
    required this.onToggleTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox();

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          '$sectionTitle (${tasks.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Automatically expand High priority or Today section
        initiallyExpanded: sectionTitle.toLowerCase() == 'high' ||
            sectionTitle.toLowerCase() == 'today',
        children: tasks.map((task) {
          return TaskTile(
            task: task,
            sectionTitle: sectionTitle,
            groupMode: groupMode,
            onToggle: () => onToggleTask(task),
          );
        }).toList(),
      ),
    );
  }
}
