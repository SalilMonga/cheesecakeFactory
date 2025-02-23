// import 'package:cheesecakefactory/splash_screen.dart';
import 'package:cheesecakefactory/archive/task.dart';
import 'package:cheesecakefactory/taskbutton.dart';
import 'package:cheesecakefactory/login_page.dart';
import 'package:cheesecakefactory/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'profile.dart';
import 'NavigationBar.dart' as customNavBar;

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 30, 156, 28)),
        useMaterial3: true,
      ),
      // home: const customNavBar.NavigationBar(), // Set the home to NavigationBar
      // home: TaskPage(),
      // home: const customNavBar.NavigationBar(), // Set the home to NavigationBar
      // home: const LoginPage()
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/tasklist': (context) => const customNavBar.NavigationBar(),
        // '/home': (context) => const HomePage(),
      },
      // home: Settings(),
    );
  }
}
