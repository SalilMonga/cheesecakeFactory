import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
      backgroundColor: Colors.black,
      color: Colors.white, // Default icon color
      activeColor: Colors.blue, // Color when selected
      tabBackgroundColor: Colors.grey.shade800, // Background of selected tab
      gap: 8,
      selectedIndex: _selectedIndex, // Track the selected index
      onTabChange: (index) {
        setState(() {
          _selectedIndex = index; // Update selected index
        });
        widget.onTabChange(index); // Notify parent widget
      },
      tabs: const [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.dashboard_sharp,
          text: 'Calendar',
        ),
        GButton(
          icon: Icons.album,
          text: 'Focus',
        ),
        GButton(
          icon: Icons.account_circle,
          text: 'Profile',
        ),
      ],
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: Colors.black,
      color: Colors.white,
      activeColor: Colors.white,
      tabBackgroundColor: Colors.grey,
      gap: 8,
      tabs: const [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.dashboard_sharp,
          text: 'Calander',
        ),
        GButton(
          icon: Icons.album,
          text: 'Focus',
        ),
        GButton(
          icon: Icons.account_circle,
          text: 'Profile',
        ),
      ],
    );
  }
}*/
