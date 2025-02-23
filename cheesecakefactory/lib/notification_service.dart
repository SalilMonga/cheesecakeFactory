import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}



// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     // Initialize time zones
//     tz.initializeTimeZones();

//     // Android Initialization
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // iOS Initialization
//     const DarwinInitializationSettings iosInitSettings =
//         DarwinInitializationSettings();

//     // Setup Initialization Settings
//     final InitializationSettings initSettings = InitializationSettings(
//       android: androidInitSettings,
//       iOS: iosInitSettings,
//     );

//     await _notificationsPlugin.initialize(initSettings);
//   }

//   Future<void> showNotification(int pendingTasks) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'task_reminder_channel',
//       'Task Reminders',
//       channelDescription: 'Reminders to complete your tasks',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     await _notificationsPlugin.show(
//       0,
//       "Task Reminder 📝",
//       "You have $pendingTasks tasks to complete!",
//       notificationDetails,
//     );
//   }

//   Future<void> scheduleNotification(int hours, int pendingTasks) async {
//     await _notificationsPlugin.zonedSchedule(
//       1,
//       "Don't forget your tasks! ⏳",
//       "You still have $pendingTasks tasks left to complete.",
//       tz.TZDateTime.now(tz.local).add(Duration(hours: hours)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_reminder_channel',
//           'Task Reminders',
//           channelDescription: 'Scheduled task reminders',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
// }
