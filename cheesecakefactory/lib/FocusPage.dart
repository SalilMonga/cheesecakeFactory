import 'package:flutter/material.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
      ),
      body: const Center(
        child: Text('Welcome to the Focus Page!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 12, 57, 189)),
      useMaterial3: true,
    ),
    home: const FocusPage(),
  ));
}
