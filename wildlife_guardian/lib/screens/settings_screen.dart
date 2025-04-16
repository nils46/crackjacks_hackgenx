import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationTrackingEnabled = true;
  double _updateFrequency = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Application Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive alerts about wildlife sightings'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark themes'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Location Tracking'),
            subtitle: const Text('Allow the app to track your location'),
            value: _locationTrackingEnabled,
            onChanged: (value) {
              setState(() {
                _locationTrackingEnabled = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Update Frequency (minutes)'),
                Slider(
                  value: _updateFrequency,
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label: _updateFrequency.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _updateFrequency = value;
                    });
                  },
                ),
                Text('Current: ${_updateFrequency.round()} minutes'),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('About Wildlife Guardian'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              // TODO: Show about dialog
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.privacy_tip_outlined),
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.gavel_outlined),
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement reset to defaults
              },
              child: const Text('Reset to Defaults'),
            ),
          ),
        ],
      ),
    );
  }
} 