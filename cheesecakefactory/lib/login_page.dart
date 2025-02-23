import 'package:cheesecakefactory/component/primary_button.dart';
import 'package:cheesecakefactory/component/task_list_page.dart';
import 'package:cheesecakefactory/component/text_field.dart';
import 'package:cheesecakefactory/security_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final storedUsername = await _storage.read(key: 'username');
      final storedPassword = await _storage.read(key: 'password');
      final storedSalt = await _storage.read(key: 'salt');

      if (storedSalt != null &&
          storedUsername == _usernameController.text.trim()) {
        final hashedPassword =
            hashPassword(_passwordController.text.trim(), storedSalt);

        if (storedPassword == hashedPassword) {
          // Navigate to TaskListPage using named route
          Navigator.pushReplacementNamed(context, '/tasklist');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
    FocusScope.of(context).unfocus(); // Hide keyboard
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background to white
        elevation: 0, // Remove shadow
        flexibleSpace: Center(
          child: Image.asset(
            'assets/cheesecake.png', // Make sure the path is correct
            height: 100, // Adjust height as needed
            width: 100, // Adjust width as needed
            fit: BoxFit.contain, // Ensure the logo fits properly
          ),
        ),
      ),
      body: Center( // Center the content vertically
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure the column is as small as needed
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                      showSuffixIcon: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryButton(
                          text: 'Sign Up',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        ),
                        PrimaryButton(
                          text: 'Login',
                          onPressed: _validateAndLogin,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
