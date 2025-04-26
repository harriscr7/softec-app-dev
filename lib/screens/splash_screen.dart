import 'package:flutter/material.dart';
import 'package:softec_project/screens/auth_wrapper.dart';
import 'package:softec_project/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a 3-second delay before navigating to the next screen
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to AuthWrapperScreen after 3 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthWrapper(),
        ), // Replace with your actual AuthWrapperScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // This takes all available space and centers the logo
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/sp_screen_gt.png',
                width: 173.91,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // Background image stays at the bottom
          Image.asset(
            'assets/sp_screen_bg.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
