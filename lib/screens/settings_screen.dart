import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/local_notifications_service.dart';
import '../services/noti_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    // Initialize notifications when the screen loads
    LocalNotification.init();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            SimpleHiddenDrawerController.of(
              context,
            ).toggle(); // 🔥 open/close drawer
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(context, 'Appearance', [
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle dark/light theme'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ]),
          _buildSection(context, 'Notifications', [
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _pushNotificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _pushNotificationsEnabled = value;
                });
                if (value) {
                  NotificationService().showNotification(
                    id: 1,
                    title: 'Test Title',
                    body: 'Test Notification',
                  );
                } else {
                  // Cancel all notifications when disabled
                  await LocalNotification.cancelAll();
                }
              },
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive email notifications'),
              value: false, // TODO: Implement email notification settings
              onChanged: (value) {
                // TODO: Implement email notification toggle
              },
            ),
          ]),
          _buildSection(context, 'About', [
            ListTile(
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              title: const Text('Terms of Service'),
              onTap: () {
                // TODO: Navigate to terms of service
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: children),
        ),
      ],
    );
  }
}
