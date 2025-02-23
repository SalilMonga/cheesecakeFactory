// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'notifications.dart'; // Import your notifications.dart file

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> requestNotificationPermission() async {
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await requestNotificationPermission();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');
//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromARGB(255, 30, 156, 28)),
//       useMaterial3: true,
//       home: TaskManagerHomePage(), // Replace with your actual home page widget
//     );
//   }
// }

// class TaskManagerHomePage extends StatelessWidget {
//   // Placeholder, replace with your actual home page
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Task Manager")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             NotificationService().showNotification(
//                 3); // Example: Show notification with 3 pending tasks
//             // You can also call NotificationService().scheduleNotification() here
//           },
//           child: Text("Show Notification"),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'NotificationService.dart'; // Import your notifications.dart file

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 30, 156, 28)),
      useMaterial3: true,
      home: TaskManagerHomePage(), // Replace with your actual home page widget
    );
  }
}

class TaskManagerHomePage extends StatelessWidget {
  // Placeholder, replace with your actual home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotificationService().showNotification(
                3); // Example: Show notification with 3 pending tasks
            // You can also call NotificationService().scheduleNotification() here
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}
