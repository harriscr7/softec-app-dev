import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/screens/forgot_password_screen.dart';
import 'package:softec_project/screens/signup_screen.dart';
import 'package:softec_project/services/notification_send_service.dart';
import 'package:softec_project/theme/theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submit() async {
    sendTestNotification();
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();

    // try {
    //   await authProvider.login(email, password);
    // } catch (e) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text(e.toString())));
    // }
  }

  @override
  void dispose() {
    // Dispose the FocusNodes when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image at the top (323 width)
                Image.asset(
                  'assets/lg_screen_bg.png',
                  width: 323,
                  fit: BoxFit.fitWidth,
                ),

                // Container with form fields
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Hi, kindly login to continue.',
                        style: TextStyle(fontSize: 12),
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

                      const SizedBox(height: 20),

                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (_, __, ___) => ForgotPasswordScreen(),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(
                                          1.0,
                                          0.0,
                                        ), // Comes from right
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve:
                                              Curves
                                                  .easeOutQuart, // Smoother curve
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ), // Slightly longer for smoothness
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Login button
                      Center(
                        child: Container(
                          width: 210,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TextButton(
                            onPressed: _submit,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign up prompt
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(fontSize: 12),
                            ),
                            GestureDetector(
                              // Replace the existing GestureDetector onTap with this:
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (_, __, ___) => const SignUpScreen(),
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(
                                              1.0,
                                              0.0,
                                            ), // Comes from right
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve:
                                                  Curves
                                                      .easeOutQuart, // Smoother curve
                                            ),
                                          ),
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(
                                        milliseconds: 500,
                                      ), // Slightly longer for smoothness
                                    ),
                                  ),
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
