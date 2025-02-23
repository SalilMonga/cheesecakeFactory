import 'package:flutter/material.dart';
import 'NavigationBar.dart' as customNavBar;
import 'notification_service.dart'; // Import the notification service
import 'CustomTheme.dart' as customTheme;
import 'NavigationBar.dart' as customNavBar;

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
      home: HomePage(), 
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customNavBar.NavigationBar(),
            Text('Hello, Flutter!'),
          ],
        ),
      ),
    );
  }
}
