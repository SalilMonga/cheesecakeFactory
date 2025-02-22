import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for each editable field
  TextEditingController _nameController = TextEditingController(text: 'Cheesecake Factory');
  TextEditingController _phoneController = TextEditingController(text: '0123456789');
  TextEditingController _addressController = TextEditingController(text: 'CSUN, Los Angeles');
  TextEditingController _emailController = TextEditingController(text: 'you@gmail.com');

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
                // Editable Profile Fields
                itemProfile('Name', _nameController, CupertinoIcons.person),
                const SizedBox(height: 10),
                itemProfile('Phone', _phoneController, CupertinoIcons.phone),
                const SizedBox(height: 10),
                itemProfile('Address', _addressController, CupertinoIcons.location),
                const SizedBox(height: 10),
                itemProfile('Email', _emailController, CupertinoIcons.mail),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle saving logic here, e.g., display saved data
                      print('Name: ${_nameController.text}');
                      print('Phone: ${_phoneController.text}');
                      print('Address: ${_addressController.text}');
                      print('Email: ${_emailController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Save Profile'),
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

  Widget itemProfile(String title, TextEditingController controller, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.blue.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
        subtitle: TextField(
          controller: controller, // Bind the text field to the controller
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter your $title',
          ),
        ),
      ),
    );
  }
}
