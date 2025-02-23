
import 'package:cheesecakefactory/FocusPage.dart';
import 'package:cheesecakefactory/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'CalenderPage.dart';
import 'HomePage.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0; // Track selected tab index

  final List<Widget> _pages = [
    MyHomePage(title: 'Home'),
    CalenderPage(),
    FocusPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        color: Colors.black, // Default icon color
        //activeColor: Colors.green, // Color when selected
        tabBackgroundColor: const Color.fromARGB(255, 231, 235, 225), // Background of selected tab
        gap: 8,
        selectedIndex: _selectedIndex, // Track the selected index
        onTabChange: _onItemTapped,
        tabs: const [
          GButton(
            icon: Icons.home,
            text : 'Home',
            iconActiveColor: Colors.green,
          ),
          GButton(
            icon: Icons.dashboard_sharp,
            text: 'Calendar',
            iconActiveColor: Color.fromARGB(198, 130, 209, 202),
          ),
          GButton(
            icon: Icons.album,
            text: 'Focus',
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


/*import 'package:cheesecakefactory/FocusPage.dart';
import 'package:cheesecakefactory/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//import 'HomePage.dart';
import 'CalenderPage.dart';

class NavigationBar extends StatefulWidget {
  final Function(int) onTabChange; // Callback function for tab changes
  const NavigationBar({super.key, required this.onTabChange});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0; // Track selected tab index

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: Colors.white,
      color: Colors.black, // Default icon color
      activeColor: Colors.green, // Color when selected
      tabBackgroundColor: const Color.fromARGB(255, 231, 235, 225), // Background of selected tab
      gap: 8,
      selectedIndex: _selectedIndex, // Track the selected index
      onTabChange: (index) {
        setState(() {
          _selectedIndex = index; // Update selected index
        });
        widget.onTabChange(index); // Notify parent widget
      },
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'Home',
            onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Hii',)),
            );*/
            },          
        ),
        GButton(
          icon: Icons.dashboard_sharp,
          text: 'Calendar',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const CalenderPage()),
            );
            },
        ),
        GButton(
          icon: Icons.album,
          text: 'Focus',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FocusPage()),
            );
            },
        ),
        GButton(
          icon: Icons.account_circle,
          text: 'Profile',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
            },
        ),
      ],
    );
  }
}*/