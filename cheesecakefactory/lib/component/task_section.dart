import 'package:flutter/material.dart';
import 'task.dart';
import 'task_tile.dart';
import 'task_list_test.dart';

class TaskSection extends StatefulWidget {
  final String sectionTitle;
  final List<Task> tasks;
  final GroupMode groupMode;
  final Function(Task) onToggleTask;
  final Set<int> pendingCompletion;

  const TaskSection({
    super.key,
    required this.sectionTitle,
    required this.tasks,
    required this.groupMode,
    required this.onToggleTask,
    required this.pendingCompletion,
  });

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  bool _isExpanded = false;
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.sectionTitle.toLowerCase() == 'high' ||
        widget.sectionTitle.toLowerCase() == 'today';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) return const SizedBox();

    final headingStyle = widget.sectionTitle.toLowerCase() == 'completed'
        ? TextStyle(
            fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[600])
        : const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey(widget.sectionTitle),
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          '${widget.sectionTitle} (${widget.tasks.length})',
          style: headingStyle,
        ),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        // // Automatically expand High priority or Today section
        // initiallyExpanded: widget.sectionTitle.toLowerCase() == 'high' ||
        //     widget.sectionTitle.toLowerCase() == 'today',
        children: widget.tasks.map((task) {
          return TaskTile(
            task: task,
            sectionTitle: widget.sectionTitle,
            groupMode: widget.groupMode,
            onToggle: () => widget.onToggleTask(task),
            pendingCompletion: widget.pendingCompletion,
          );
        }).toList(),
      ),
    );
  }
}
