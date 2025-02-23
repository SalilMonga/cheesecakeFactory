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
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosInitSettings =
//         DarwinInitializationSettings();

//     final InitializationSettings initSettings = InitializationSettings(
//       android: androidInitSettings,
//       iOS: iosInitSettings,
//     );

//     await _notificationsPlugin.initialize(initSettings);
//   }

//   Future<void> showNotification(
//       int id, String title, String body, int pendingTasks) async {
//     if (pendingTasks <= 0) {
//       await cancelAllNotifications();
//       print("Showing notification on app start");
//       return;
//     }
//     // added
//     else {
//       print("Showing notification on app start");
//     }

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
//       id,
//       title,
//       body,
//       notificationDetails,
//     );
//   }

//   Future<void> scheduleNotification(int hours) async {
//     await _notificationsPlugin.zonedSchedule(
//       1,
//       "⏳ Haven't Checked In?",
//       "Come back and complete your tasks! We miss you. ❤️",
//       tz.TZDateTime.now(tz.local).add(Duration(hours: hours)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_reminder_channel',
//           'Task Reminders',
//           channelDescription: 'Scheduled reminders to return to the app.',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await _notificationsPlugin.cancelAll();
//   }
// }
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification(int pendingTasks) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_reminder_channel',
      'Task Reminders',
      channelDescription: 'Reminders to complete your tasks',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      "Task Reminder 📝",
      "You have $pendingTasks tasks to complete!",
      notificationDetails,
    );
  }

  Future<void> scheduleNotification(int hours, int pendingTasks) async {
    await _notificationsPlugin.zonedSchedule(
      1,
      "Don't forget your tasks! ⏳",
      "You still have $pendingTasks tasks left to complete.",
      tz.TZDateTime.now(tz.local).add(Duration(hours: hours)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminder_channel',
          'Task Reminders',
          channelDescription: 'Scheduled task reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
