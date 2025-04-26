import 'package:flutter/material.dart';
import 'package:softec_project/theme/theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image
                      Image.asset(
                        'assets/fg_pass_screen_bg.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),

                      // Forgot Password text
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          textAlign: TextAlign.start,
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Instruction text
                      const Text(
                        "Enter your email address below and we'll send you an email with instructions on how to change your password",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 30),

                      // Email field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Recover Password button
                      Center(
                        child: Container(
                          width: 210,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TextButton(
                            onPressed: () {
                              final email = emailController.text.trim();
                              if (email.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Reset instructions sent to $email',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Recover Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
