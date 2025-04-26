import 'package:flutter/material.dart';
import 'package:softec_project/screens/auth_wrapper.dart';
import 'package:softec_project/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:softec_project/theme/theme.dart';

class AccConfirmationScreen extends StatelessWidget {
  const AccConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 40, // Subtract padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success Image
                Image.asset('assets/cs_screen_bg.png', width: 150, height: 150),
                const SizedBox(height: 30),

                // Verification Successful Text
                SizedBox(
                  width: 224,
                  child: const Text(
                    textAlign: TextAlign.center,
                    'Verification Successful',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'You now have full access to our system',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 40),

                // Let's Combat Button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthWrapper(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Let's GO!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
