import 'package:cheesecakefactory/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cheesecakefactory/task.dart';
import 'package:cheesecakefactory/notification_service.dart'; // Import notification service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
