import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class task {
  String title;
  bool isCompleted;

  task(this.title, {this.isCompleted = false});
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<task> tasks = [
    task("Complete project tasks"),
    task("Write report"),
    task("Fix website bugs"),
    task("Set goals"),
  ];

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  void completeTask(int index) {
    setState(() {
      tasks[index].isCompleted = true;
    });

    // Trigger confetti
    _confettiController.play();

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🎉 Task Completed! Well done! 🎉"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List")),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: tasks[index].isCompleted ? 0.5 : 1.0,
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: tasks[index].isCompleted
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.radio_button_unchecked,
                            color: Colors.grey),
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(
                        decoration: tasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: tasks[index].isCompleted
                          ? null
                          : () => completeTask(index),
                      child: Text("Complete"),
                    ),
                  ),
                ),
              );
            },
          ),

          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // Shoot upwards
              emissionFrequency: 0.05, // Confetti frequency
              numberOfParticles: 10, // Number of confetti particles
              gravity: 0.2, // Slow fall
              colors: [Colors.blue, Colors.red, Colors.yellow, Colors.green],
            ),
          ),
        ],
      ),
    );
  }
}
