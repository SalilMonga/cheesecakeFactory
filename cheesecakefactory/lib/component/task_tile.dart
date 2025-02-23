import 'package:flutter/material.dart';
import 'task.dart';
import 'task_list_test.dart';

// TextStyle getTaskTextStyle(Task task, String sectionTitle, GroupMode mode) {
//   if (mode == GroupMode.priority) {
//     return TextStyle(
//       decoration: task.completed ? TextDecoration.lineThrough : null,
//       fontWeight: sectionTitle.toLowerCase() == 'high'
//           ? FontWeight.bold
//           : FontWeight.normal,
//       color: sectionTitle.toLowerCase() == 'high'
//           ? Colors.red[400]
//           : sectionTitle.toLowerCase() == 'medium'
//               ? Colors.purple[200]
//               : Colors.blue[200],
//     );
//   } else {
//     return TextStyle(
//       decoration: task.completed ? TextDecoration.lineThrough : null,
//       fontWeight: sectionTitle.toLowerCase() == 'today'
//           ? FontWeight.bold
//           : FontWeight.normal,
//       color: sectionTitle.toLowerCase() == 'today'
//           ? Colors.green[400]
//           : sectionTitle.toLowerCase() == 'this week'
//               ? Colors.orange[400]
//               : Colors.blueGrey,
//     );
//   }
// }

TextStyle getTaskTextStyle(
    Task task, String sectionTitle, GroupMode mode, bool isPending) {
  // Apply strike-through if the task is completed or pending.
  final bool strike = task.completed || isPending;
  if (mode == GroupMode.priority) {
    return TextStyle(
      decoration: strike ? TextDecoration.lineThrough : null,
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
    return TextStyle(
      decoration: strike ? TextDecoration.lineThrough : null,
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

class TaskTile extends StatelessWidget {
  final Task task;
  final String sectionTitle;
  final GroupMode groupMode;
  final VoidCallback onToggle;
  final Set<int> pendingCompletion;

  const TaskTile({
    Key? key,
    required this.task,
    required this.sectionTitle,
    required this.groupMode,
    required this.onToggle,
    required this.pendingCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      horizontalTitleGap: 2.0,
      minVerticalPadding: 0.0,
      leading: Checkbox(
        checkColor: Colors.white,
        value: task.completed,
        onChanged: (_) => onToggle(),
        activeColor: Colors.grey[400],
      ),
      title: AnimatedDefaultTextStyle(
        style: getTaskTextStyle(
            task, sectionTitle, groupMode, pendingCompletion.contains(task.id)),
        duration: const Duration(milliseconds: 500), // adjust to your liking
        child: Text(task.name),
      ),
      subtitle: task.timeline.isNotEmpty
          ? Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  task.timeline,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            )
          : null,
    );
  }
}
