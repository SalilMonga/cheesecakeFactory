import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum GroupMode { priority, date }

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

Future<List<Task>> loadTasks() async {
  String jsonString = await rootBundle.loadString('assets/tasks.json');
  List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((task) => Task.fromJson(task)).toList();
}
