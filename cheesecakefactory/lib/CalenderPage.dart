import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime today = DateTime.now();
  final TextEditingController _taskController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();

  // Store tasks for each date
  Map<DateTime, List<String>> tasks = {};

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // Show dialog to add a task
  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // This line ensures the background is white
          title: const Text("Add Task"),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(hintText: "Enter task"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic, color: Colors.blue),
                onPressed: _startListening,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    tasks[today] = (tasks[today] ?? [])..add(_taskController.text);
                    _taskController.clear();
                  });
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _taskController.text = result.recognizedWords;
          });
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Monthly Calendar"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: content(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Text(
          "Selected Day = ${today.toString().split(" ")[0]}",
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        TableCalendar(
          locale: "en_US",
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.black),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            weekendTextStyle: TextStyle(color: Colors.red),
            defaultTextStyle: TextStyle(color: Colors.black),
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, today),
          focusedDay: today,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 12, 31),
          onDaySelected: _onDaySelected,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Tasks:",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks[today]?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[today]![index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Page'),
      ),
      body: const Center(
        child: Text('This is the Calendar Page'),
      ),
    );
  }
}
