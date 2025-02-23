import 'package:cheesecakefactory/archive/task.dart';
import 'package:cheesecakefactory/task_database.dart';
import 'package:cheesecakefactory/taskbutton.dart';
import 'package:cheesecakefactory/login_page.dart';
import 'package:cheesecakefactory/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'profile.dart';
import 'NavigationBar.dart' as customNavBar;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // For testing: reset (delete) the existing database.
  await TaskDatabase.instance.resetDatabase();

  runApp(const MyApp());
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
