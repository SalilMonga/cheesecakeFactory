// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() => runApp(const TaskApp());

// class TaskApp extends StatelessWidget {
//   const TaskApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: TaskButton(),
//     );
//   }
// }

// class TaskButton extends StatefulWidget {
//   const TaskButton({super.key});

//   @override
//   _TaskButtonState createState() => _TaskButtonState();
// }

// class _TaskButtonState extends State<TaskButton> {
//   List<String> tasks = []; // Only store task descriptions
//   final TextEditingController _controller = TextEditingController();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isInputVisible = false; // To control input visibility

//   void _addTask() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         tasks.add(_controller.text); // Add task to the list
//       });
//       _controller.clear(); // Clear the text input field
//       setState(() {
//         _isInputVisible = false; // Hide input field after adding the task
//       });
//     }
//   }

//   void _startListening() async {
//     bool available = await _speech.initialize();
//     if (available) {
//       setState(() {
//         _isListening = true;
//       });
//       _speech.listen(onResult: (result) {
//         setState(() {
//           _controller.text = result.recognizedWords;
//         });
//       });
//     } else {
//       // Handle the case where speech recognition is not available
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Speech recognition not available")),
//       );
//     }
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() {
//       _isListening = false;
//     });
//   }

//   void _cancelInput() {
//     setState(() {
//       _isInputVisible = false; // Hide input field
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Task Manager')),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: tasks.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(child: Text(tasks[index])),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//           if (_isInputVisible)
//             Center(
//               child: Container(
//                 width: 350, // Make the container wider
//                 height: 400, // Make the container taller (2x bigger)
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           'Create a Task!',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.close, color: Colors.red),
//                             onPressed: _cancelInput,
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                         // This will push the mic, text box, and send button to the bottom
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     _isListening ? Icons.mic_off : Icons.mic,
//                                     color: Colors.blue,
//                                   ),
//                                   onPressed: _isListening
//                                       ? _stopListening
//                                       : _startListening,
//                                 ),
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _controller,
//                                     decoration: const InputDecoration(
//                                       hintText:
//                                           'Type your task here or speak...',
//                                     ),
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.send,
//                                       color: Colors.blue),
//                                   onPressed: _addTask,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: _isInputVisible
//           ? null // Hide the FAB when input is visible
//           : FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _isInputVisible =
//                       !_isInputVisible; // Toggle the visibility of input
//                 });
//               },
//               child: const Icon(Icons.add),
//               backgroundColor: Colors.blue,
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'task.dart';
import 'task_database.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _controller = TextEditingController();
  final TaskDatabase _taskDatabase = TaskDatabase.instance;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final tasks = await _taskDatabase.fetchTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask(String text) async {
    final task = Task(text: text);
    await _taskDatabase.addTask(task);
    _controller.clear();
    _fetchTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _taskDatabase.deleteTask(id);
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addTask(_controller.text);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.text),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(task.id!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
