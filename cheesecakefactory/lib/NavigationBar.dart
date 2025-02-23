import 'package:cheesecakefactory/CalenderPage.dart';
import 'package:cheesecakefactory/FocusPage.dart';
import 'package:cheesecakefactory/component/task_list_page.dart';
import 'package:cheesecakefactory/component/task_list_test.dart';
import 'package:cheesecakefactory/component/welcome_page_animation.dart';
import 'package:cheesecakefactory/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0; // Track selected tab index
  bool _showWelcomeOverlay = true;

  final List<Widget> _pages = [
    // MyHomePage(title: 'Home'),
    const TaskListPageTest(),
    const NewCalendarPage(),
    const FocusPage(),
    const ProfileScreen(),
    // const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _hideWelcomeOverlay() {
    setState(() {
      _showWelcomeOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex], // Display the selected page
          if (_showWelcomeOverlay)
            WelcomePage(
              firstName: 'User',
              onAnimationComplete: _hideWelcomeOverlay,
            ),
        ],
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        color: Colors.black, // Default icon color
        //activeColor: Colors.green, // Color when selected
        tabBackgroundColor: const Color.fromARGB(
            255, 231, 235, 225), // Background of selected tab
        gap: 8,
        selectedIndex: _selectedIndex, // Track the selected index
        onTabChange: _onItemTapped,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            iconActiveColor: Colors.green,
          ),
          GButton(
            icon: Icons.dashboard_sharp,
            text: 'Calendar',
            iconActiveColor: Color.fromARGB(198, 130, 209, 202),
          ),
          GButton(
            icon: Icons.album,
            text: 'Noises',
            iconActiveColor: Colors.blueGrey,
          ),
          GButton(
            icon: Icons.account_circle,
            text: 'Profile',
            iconActiveColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
