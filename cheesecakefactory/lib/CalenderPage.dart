import 'package:flutter/material.dart';

class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calender'),
        backgroundColor: const Color.fromARGB(198, 130, 209, 202),
      ),
      body: const Center(
        child: Text('Welcome to the Calender Page!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
      useMaterial3: true,
    ),
    home: const CalenderPage(),
  ));
}
