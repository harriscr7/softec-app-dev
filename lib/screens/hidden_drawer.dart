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
          colorLineSelected: Colors.red,
          name: "Home Page",
          baseStyle: const TextStyle(color: Colors.white, fontSize: 18),
          selectedStyle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: Colors.red,
          name: "Profile Page",
          baseStyle: const TextStyle(color: Colors.white, fontSize: 18),
          selectedStyle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const ProfileScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: Colors.red,
          name: "Settings Page",
          baseStyle: const TextStyle(color: Colors.white, fontSize: 18),
          selectedStyle: const TextStyle(
            color: Colors.blueAccent,
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
      enableShadowItensMenu: true,
      curveAnimation: Curves.decelerate,
      backgroundColorMenu:
          AppColors.secondary, // Make menu background transparent
      screens: pages,
      initPositionSelected: 0,
    );
  }
}
