import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/screens/hidden_drawer.dart';
import 'package:softec_project/screens/login_screen.dart' show LoginScreen;
import '../providers/user_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Handle error state
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        // Handle authenticated state
        if (snapshot.hasData) {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );

          // Load user data if not already loaded
          if (!userProvider.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              userProvider.loadUserData(snapshot.data!.uid);
            });
          }

          return Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              if (userProvider.isLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userProvider.error != null) {
                return Scaffold(
                  body: Center(
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
                  ),
                );
              }

              return const HiddenDrawer();
            },
          );
        }

        // Handle unauthenticated state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<UserProvider>(context, listen: false).clearUserData();
        });

        return const LoginScreen();
      },
    );
  }
}
