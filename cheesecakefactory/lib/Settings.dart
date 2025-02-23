import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _soundsEnabled = false;
  bool _hapticsEnabled = false;
  String _selectedTheme = 'Red';
  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      await player.play(AssetSource('assets/fan.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> _stopSound() async {
    try {
      await player.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
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
            title: Text('Sounds'),
            value: _soundsEnabled,
            onChanged: (bool value) async {
              setState(() {
                _soundsEnabled = value;
              });
              if (value) {
                await _playSound();
              } else {
                await _stopSound();
              }
            },
          ),
          SwitchListTile(
            title: Text('Haptics'),
            value: _hapticsEnabled,
            onChanged: (bool value) {
              setState(() {
                _hapticsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
