// import 'package:cheesecakefactory/splash_screen.dart';
// import 'package:cheesecakefactory/task.dart';
import 'package:cheesecakefactory/toastTest.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'profile.dart';
// import 'NavigationBar.dart' as customNavBar;

// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    // Request the permission
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();
  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon'); // Make sure 'app_icon' exists

  // For iOS or other platforms, you can add initialization settings here
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id', // Unique channel ID
    'Your Channel Name', // Channel name visible to the user
    channelDescription: 'Channel description', // Channel description
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Task Reminder', // Notification Title
    'You have a task to complete!', // Notification Body
    platformChannelSpecifics,
    payload: 'task_payload', // Optional payload
  );
}

// void main() {
//   runApp(const MyApp());
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 30, 156, 28)),
        useMaterial3: true,
      ),
      // home: const customNavBar.NavigationBar(), // Set the home to NavigationBar
      home: TaskManagerHomePage(),
    );
  }
}
