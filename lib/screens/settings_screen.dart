import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            SimpleHiddenDrawerController.of(context)
                .toggle(); // 🔥 open/close drawer
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Appearance',
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark/light theme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ],
          ),
          _buildSection(
            context,
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: true, // TODO: Implement notification settings
                onChanged: (value) {
                  // TODO: Implement notification toggle
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
            ],
          ),
          _buildSection(
            context,
            'About',
            [
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
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
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
