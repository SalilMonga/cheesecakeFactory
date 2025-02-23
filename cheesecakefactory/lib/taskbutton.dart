import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(TaskApp());

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskButton(),
    );
  }
}

class TaskButton extends StatefulWidget {
  const TaskButton({super.key});

  @override
  _TaskButtonState createState() => _TaskButtonState();
}

class _TaskButtonState extends State<TaskButton> {
  List<Map<String, dynamic>> tasks = []; // Store both task and ID
  TextEditingController _controller = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInputVisible = false; // To control input visibility
  late Database _database;

  // Initialize the database
  Future<void> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');
    
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT)",
      );
    });

    _loadTasks();
  }

  // Load tasks from the database
  Future<void> _loadTasks() async {
    final List<Map<String, dynamic>> maps = await _database.query('tasks');
    setState(() {
      tasks = maps;
    });
  }

  // Add task to the database
  Future<void> _addTaskToDatabase(String task) async {
    await _database.insert(
      'tasks',
      {'task': task},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadTasks(); // Refresh tasks after adding a new one
  }

  // Delete task from the database
  Future<void> _deleteTaskFromDatabase(int id) async {
    await _database.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [id],
    );
    _loadTasks(); // Refresh tasks after deletion
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        tasks.add({'task': _controller.text});
      });
      _addTaskToDatabase(_controller.text);
      _controller.clear();  // Clear the text input field
      setState(() {
        _isInputVisible = false; // Hide input field after adding the task
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      int taskIdToDelete = tasks[index]['id']; // Get the ID of the task to delete
      tasks.removeAt(index); // Remove from list
      _deleteTaskFromDatabase(taskIdToDelete); // Delete from database using the task ID
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      });
    } else {
      // Handle the case where speech recognition is not available
      print("Speech recognition not available.");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _cancelInput() {
    setState(() {
      _isInputVisible = false; // Hide input field
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Initialize the database when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(tasks[index]['task'])),
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isInputVisible)
            Center(
              child: Container(
                width: 350, // Make the container wider
                height: 400, // Make the container taller (2x bigger)
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Create a Task!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: _cancelInput,
                          ),
                        ],
                      ),
                      Expanded( // This will push the mic, text box, and send button to the bottom
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _isListening ? Icons.mic_off : Icons.mic,
                                    color: Colors.blue,
                                  ),
                                  onPressed: _isListening ? _stopListening : _startListening,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      hintText: 'Type your task here or speak...',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send, color: Colors.blue),
                                  onPressed: _addTask,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _isInputVisible
          ? null // Hide the FAB when input is visible
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isInputVisible = !_isInputVisible; // Toggle the visibility of input
                });
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
    );
  }
}
