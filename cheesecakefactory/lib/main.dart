import 'package:cheesecakefactory/archive/task.dart';
import 'package:cheesecakefactory/task_database.dart';
import 'package:cheesecakefactory/taskbutton.dart';
import 'package:cheesecakefactory/login_page.dart';
import 'package:cheesecakefactory/signup_page.dart';
// import 'package:cheesecakefactory/splash_screen.dart';
// import 'package:cheesecakefactory/task.dart';
import 'package:cheesecakefactory/toastTest.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'profile.dart';
// import 'NavigationBar.dart' as customNavBar;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  WidgetsFlutterBinding.ensureInitialized();

  // For testing: reset (delete) the existing database.
  await TaskDatabase.instance.resetDatabase();
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
