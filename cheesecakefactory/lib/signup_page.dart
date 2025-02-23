import 'package:cheesecakefactory/component/primary_button.dart';
import 'package:cheesecakefactory/component/text_field.dart';
import 'package:cheesecakefactory/security_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final salt = generateSalt();
      final hashedPassword =
          hashPassword(_passwordController.text.trim(), salt);
      await _storage.write(
          key: 'username', value: _usernameController.text.trim());
      await _storage.write(key: 'password', value: hashedPassword);
      await _storage.write(key: 'salt', value: salt);
      await _storage.write(key: 'email', value: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up successful! Please log in.')),
      );

      Navigator.pop(context); // Navigate back to the login page
    }
    FocusScope.of(context).unfocus(); // Hide keyboard
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight - MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    helperText: "Don't use special characters",
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
                    helperText: 'Minimum 8 characters',
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
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Enter your password again',
                    helperText: 'Minimum 8 characters',
                    obscureText: true,
                    showSuffixIcon: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: _signUp,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to login page
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.grey, // Grey color for the text
                            decoration:
                                TextDecoration.underline, // Underline the text
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
