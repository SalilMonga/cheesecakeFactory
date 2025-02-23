import 'package:cheesecakefactory/task_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';

import 'component/task.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NewCalendarPage(),
  ));
}

class NewCalendarPage extends StatefulWidget {
  const NewCalendarPage({super.key});

  @override
  State<NewCalendarPage> createState() => _NewCalendarPageState();
}

class _NewCalendarPageState extends State<NewCalendarPage> {
  DateTime today = DateTime.now();
  // final TextEditingController _taskController = TextEditingController();
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
    final TextEditingController taskNameController = TextEditingController();
    String selectedPriority = 'High';
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // so the sheet can expand above the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          // Adjust padding so content is visible above keyboard
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              ListTile(
                // A close icon on the left and a check icon on the right
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    final name = taskNameController.text.trim();
                    if (name.isNotEmpty) {
                      final dateToUse = selectedDate ?? today;
                      final dateString =
                          DateFormat('yyyy-MM-dd').format(dateToUse);
                      final newTask = Task(
                        name: name,
                        priority: selectedPriority.toLowerCase(),
                        timeline: dateString,
                        completed: false,
                      );
                      await TaskDatabase.instance.addTask(newTask);

                      // await _refreshTasks(); // Refresh the task list!
                      if (taskNameController.text.isNotEmpty) {
                        setState(() {
                          tasks[dateToUse] = (tasks[dateToUse] ?? [])
                            ..add(name);
                          // ..add(taskNameController.text);
                          print("state set  $tasks");
                        });
                        Navigator.of(context).pop(); // Close dialog
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a task name.')),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: taskNameController,
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                        hintText: 'Enter task name',
                        suffixIcon: IconButton(
                          icon: const Icon(
                              Icons.mic), // Replace with any icon you want
                          onPressed: () {
                            _startListening(
                                taskNameController); // Call your function here
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'High', child: Text('High')),
                        DropdownMenuItem(
                            value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'No date chosen'
                                : DateFormat('yyyy-MM-dd')
                                    .format(selectedDate!),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: DateTime(now.year - 2),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       backgroundColor:
    //           Colors.white, // This line ensures the background is white
    //       title: const Text("Add Task"),
    //       content: Row(
    //         children: [
    //           Expanded(
    //             child: TextField(
    //               controller: _taskController,
    //               decoration: const InputDecoration(hintText: "Enter task"),
    //             ),
    //           ),
    //           IconButton(
    //             icon: const Icon(Icons.mic, color: Colors.blue),
    //             onPressed: _startListening,
    //           ),
    //         ],
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close dialog
    //           },
    //           child: const Text("Cancel"),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             if (_taskController.text.isNotEmpty) {
    //               setState(() {
    //                 tasks[today] = (tasks[today] ?? [])
    //                   ..add(_taskController.text);
    //                 _taskController.clear();
    //               });
    //               Navigator.of(context).pop(); // Close dialog
    //             }
    //           },
    //           child: const Text("Add"),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void _startListening(TextEditingController controller) async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
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
      body: Stack(
        children: [
          content(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 30.0),
              child: FloatingActionButton(
                onPressed: _addTask,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addTask,
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
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
