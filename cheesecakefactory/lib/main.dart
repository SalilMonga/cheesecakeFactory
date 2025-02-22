import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
 SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/water_pk.png'),
              ),
              const SizedBox(height: 20),
              itemProfile('Name', 'Cheesecake Factory', CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', '0123456789', CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Address', 'CSUN, Los Angeles', CupertinoIcons.location),
              const SizedBox(height: 10),
              itemProfile('Email', 'you@gmail.com', CupertinoIcons.mail),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: GestureDetector(
            onTap: () {
              // Add your settings functionality here
              print('Settings tapped');
            },
            child: Icon(
              Icons.settings,
              size: 30,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    ),
  );
}


  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.blue.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
} 
