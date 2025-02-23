import 'package:flutter/material.dart';
import 'package:cheesecakefactory/archive/task.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to TaskScreen after 3 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/cat.gif'), // Cat GIF animation
      ),
    );
  }

  // class WelcomeScreen extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Welcome!")),
  //     body: Center(
  //       child: Text(
  //         "🎉 Welcome to the App! 🎉",
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }
// }
}
