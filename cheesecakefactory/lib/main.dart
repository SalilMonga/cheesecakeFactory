// import 'package:cheesecakefactory/splash_screen.dart';
import 'package:cheesecakefactory/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'profile.dart';
import 'NavigationBar.dart' as customNavBar;
import 'notification_service.dart'; // Import the notification service

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  notificationService.init();
  runApp(MyApp(notificationService: notificationService)); // Pass the service to MyApp
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({Key? key, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 30, 156, 28),
        ),
        useMaterial3: true,
      ),
      home: const customNavBar.NavigationBar(), // Set the home to NavigationBar
      // home: TaskScreen(),
    );
  }
}
