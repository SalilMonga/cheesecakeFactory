import 'package:cheesecakefactory/main.dart';
import 'package:flutter/material.dart';

class TaskManagerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showNotification();
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}
