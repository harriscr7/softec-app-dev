import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/screens/acc_confirmation_screen.dart';
import 'package:softec_project/screens/auth_wrapper.dart';
import 'package:softec_project/screens/login_screen.dart';
import 'package:softec_project/theme/theme.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // FocusNodes for text fields
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await authProvider.signUp(email, password, username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccConfirmationScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(27, 0, 0, 0),
                    child: Image.asset(
                      'assets/sg_screen_bg.png', // Use your same image asset
                      width: 323,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Hi, kindly fill in the form to proceed combat',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 30),

                        // Username field
                        TextField(
                          controller: usernameController,
                          focusNode: _usernameFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Username',
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

                        // Email field
                        TextField(
                          controller: emailController,
                          focusNode: _emailFocusNode,
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
                          focusNode: _passwordFocusNode,
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
                        const SizedBox(height: 30),

                        // Sign Up button
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
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login prompt with smooth transition
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(fontSize: 12),
                              ),
                              GestureDetector(
                                onTap:
                                    () => Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (_, __, ___) => const LoginScreen(),
                                        transitionsBuilder: (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(
                                                -1.0,
                                                0.0,
                                              ), // Comes from left
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeOutQuart,
                                              ),
                                            ),
                                            child: child,
                                          );
                                        },
                                        transitionDuration: const Duration(
                                          milliseconds: 350,
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  "Login",
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
            ],
          ),
        ),
      ),
    );
  }
}
