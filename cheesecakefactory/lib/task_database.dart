import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'component/task.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filePath';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Public method to delete the database for testing purposes.
  Future<void> resetDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks.db';
    // Delete the database file.
    await deleteDatabase(path);
    print('Database deleted for testing');
    // Optionally, you could also reinitialize the DB:
    _database = null;
  }

  // Create the tasks table with the full schema.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        priority TEXT NOT NULL,
        timeline TEXT NOT NULL,
        completed INTEGER NOT NULL
      )
    ''');
    print('Database created with tasks table');
    // Populate default tasks from JSON file.
    try {
      final jsonString = await rootBundle.loadString('assets/tasks.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      for (var jsonTask in jsonList) {
        // Create a Task from JSON. Adjust the keys if needed.
        final task = Task(
          name: jsonTask['name'],
          priority: jsonTask['priority'],
          timeline: jsonTask['timeline'],
          completed: jsonTask['completed'],
        );
        await db.insert('tasks', task.toMap());
      }
      print('Default tasks populated from JSON.');
    } catch (e) {
      print('Error populating default tasks: $e');
    }
  }

  // Insert a task into the database.
  Future<int> addTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    print('Task added: ${task.toMap()}');
    return id;
  }

  // Fetch all tasks from the database.
  Future<List<Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    final tasks = result.map((e) => Task.fromMap(e)).toList();
    print('Tasks fetched: $tasks');
    return tasks;
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    final result = await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    print('Task updated: ${task.toMap()}');
    return result;
  }

  // Delete a task from the database.
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    final result = await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Task deleted with id: $id');
    return result;
  }
}
