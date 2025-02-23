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

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController =
      TextEditingController(text: 'Cheesecake Factory');
  final TextEditingController _phoneController =
      TextEditingController(text: '0123456789');
  final TextEditingController _addressController =
      TextEditingController(text: 'CSUN, Los Angeles');
  final TextEditingController _emailController =
      TextEditingController(text: 'you@gmail.com');

  final Map<String, bool> _isEditing = {
    'Name': false,
    'Phone': false,
    'Address': false,
    'Email': false,
  };

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/water_pk.png'),
                  ),
                  const SizedBox(height: 20),
                  _itemProfile('Name', _nameController, CupertinoIcons.person),
                  const SizedBox(height: 10),
                  _itemProfile('Phone', _phoneController, CupertinoIcons.phone),
                  const SizedBox(height: 10),
                  _itemProfile('Address', _addressController, CupertinoIcons.location),
                  const SizedBox(height: 10),
                  _itemProfile('Email', _emailController, CupertinoIcons.mail),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _animationController.forward(from: 0);
                print('Settings tapped');
              },
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemProfile(
      String title, TextEditingController controller, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.blue.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData),
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              if (_isEditing[title]!) {
                _isEditing[title] = false;
                _showSnackBar(context, '$title saved');
                _saveData(title, controller.text);
              } else {
                _isEditing[title] = true;
              }
            });
          },
          icon: Icon(
            _isEditing[title]! ? Icons.check : Icons.edit,
            color: Colors.grey,
          ),
        ),
        tileColor: Colors.white,
        subtitle: _isEditing[title]!
            ? TextField(
                controller: controller,
                autofocus: true,
                cursorRadius: const Radius.circular(8.0),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              )
            : Text(
                controller.text,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 203, 231, 234),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(message, style: const TextStyle(color: Colors.black)),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _saveData(String title, String value) {
    print('Saving $title: $value');
  }
}
