import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:softec_project/screens/home_screen.dart';
import 'package:softec_project/screens/profile_screen.dart';
import 'package:softec_project/screens/settings_screen.dart';
import 'package:softec_project/theme/theme.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> pages = [];
  final String randomAvatarUrl =
      'https://i.pravatar.cc/300'; // Random avatar service

  @override
  void initState() {
    super.initState();

    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: AppColors.primary,
          name: "Home Page",
          baseStyle: const TextStyle(color: Colors.black, fontSize: 18),
          selectedStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: AppColors.primary,
          name: "Profile Page",
          baseStyle: const TextStyle(color: Colors.black, fontSize: 18),
          selectedStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const ProfileScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: AppColors.primary,
          name: "Settings Page",
          baseStyle: const TextStyle(color: Colors.black, fontSize: 18),
          selectedStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SettingsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      disableAppBarDefault: true,
      curveAnimation: Curves.decelerate,
      backgroundColorMenu:
          AppColors.secondary, // Make menu background transparent
      screens: pages,
      initPositionSelected: 0,
    );
  }
}
