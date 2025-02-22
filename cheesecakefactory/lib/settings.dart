import 'package:flutter/material.dart';

class settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<settings> {
  bool _soundsAndHaptics = false;
  String _selectedTheme = 'Red';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your onPressed code here!
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Themes'),
            subtitle: Text('Choose a theme color'),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: ['Red', 'Green', 'Blue'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
            ),
          ),
          SwitchListTile(
            title: Text('Sounds & Haptics'),
            value: _soundsAndHaptics,
            onChanged: (bool value) {
              setState(() {
                _soundsAndHaptics = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
