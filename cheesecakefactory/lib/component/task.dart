// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

// // enum GroupMode { priority, date }

// class Task {
//   final int id;
//   final String name;
//   final String priority;
//   final String timeline;
//   bool completed;

//   Task({
//     required this.id,
//     required this.name,
//     required this.priority,
//     required this.timeline,
//     required this.completed,
//   });

//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['id'],
//       name: json['name'],
//       priority: json['priority'],
//       timeline: json['timeline'],
//       completed: json['completed'],
//     );
//   }
// }

// Future<List<Task>> loadTasks() async {
//   String jsonString = await rootBundle.loadString('assets/tasks.json');
//   List<dynamic> jsonResponse = json.decode(jsonString);
//   return jsonResponse.map((task) => Task.fromJson(task)).toList();
// }
class Task {
  final int? id;
  final String name;
  final String priority;
  final String timeline;
  bool completed;

  Task({
    this.id,
    required this.name,
    required this.priority,
    required this.timeline,
    this.completed = false,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        name: json['name'],
        priority: json['priority'],
        timeline: json['timeline'],
        completed: json['completed'] == 1, // assuming stored as integer 1/0
      );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'priority': priority,
      'timeline': timeline,
      'completed': completed ? 1 : 0,
    };
  }
}
