// import 'package:cheesecakefactory/splash_screen.dart';
import 'package:cheesecakefactory/archive/task.dart';
import 'package:cheesecakefactory/task_database.dart';
import 'package:cheesecakefactory/taskbutton.dart';
import 'package:cheesecakefactory/login_page.dart';
import 'package:cheesecakefactory/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'profile.dart';
import 'NavigationBar.dart' as customNavBar;
// import 'notification_service.dart'; // Import the notification service

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
  // For testing: reset (delete) the existing database.
  await TaskDatabase.instance.resetDatabase();
  runApp(const MyApp());
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
    'Yay! You completed a task', // Notification Title
    'Hurray! You are so getting close to getting everything accomplished.', // Notification Body
    platformChannelSpecifics,
    payload: 'task_payload', // Optional payload
  );
}

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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/tasklist': (context) => const customNavBar.NavigationBar(),
        // '/home': (context) => const HomePage(),
      },
    );
  }
}
