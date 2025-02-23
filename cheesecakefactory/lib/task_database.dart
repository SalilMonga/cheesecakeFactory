import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'task.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filePath'; // String interpolation
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the tasks table
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT
      )
    ''');
    print('Database created with tasks table');
  }

  // Insert a task into the database
  Future<int> addTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    print('Task added: ${task.toMap()}');
    return id;
  }

  // Fetch all tasks from the database
  Future<List<Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    final tasks = result.map((e) => Task.fromMap(e)).toList();
    print('Tasks fetched: $tasks');
    return tasks;
  }

  // Delete a task from the database
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    final result = await db.delete(
      'tasks',
      where:
          'id = ?', // String interpolation not necessary here as 'id' is already a string.
      whereArgs: [id],
    );
    print('Task deleted with id: $id');
    return result;
  }
}
