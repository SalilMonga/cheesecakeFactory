import 'package:flutter/material.dart';

class FullScreenGifScreen extends StatelessWidget {
  const FullScreenGifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 177, 177),
      body: GestureDetector(
        // Tapping anywhere dismisses the GIF screen.
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Image.asset(
            'assets/cat.gif',
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
