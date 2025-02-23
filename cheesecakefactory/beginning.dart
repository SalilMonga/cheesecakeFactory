// import 'package:flutter/material.dart';
// import 'package:gif/gif.dart';

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Flutter GIF Splash Screen',
// //       home: const SplashScreen(),
// //     );
// //   }
// // }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late GifController _gifController;

//   @override
//   void initState() {
//     super.initState();
//     _gifController = GifController(vsync: this);

//     // Navigate to the Welcome Screen after 3 seconds
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => WelcomeScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _gifController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Gif(
//           controller: _gifController,
//           autostart: Autostart.loop,
//           image: const AssetImage('assets/cat.gif'), // Using cat.gif
//         ),
//       ),
//     );
//   }
// }

// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome!")),
//       body: Center(
//         child: Text(
//           "🎉 Welcome to the App! 🎉",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
