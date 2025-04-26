import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${userProvider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => userProvider.refreshUserData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (user == null) {
      return const Center(child: Text('No user data available'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Username', user.username),
                    _buildInfoRow('Email', user.email),
                    _buildInfoRow(
                      'Joined',
                      user.createdAt?.toString().split(' ')[0] ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Profile'),
                      onTap: () {
                        // TODO: Implement edit profile
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Change Password'),
                      onTap: () {
                        // TODO: Implement change password
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
