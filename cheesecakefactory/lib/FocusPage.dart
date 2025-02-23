import 'package:flutter/material.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Text('Welcome to the Focus Page!'),
      ),
    );
  }
}