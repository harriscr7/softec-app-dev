import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/providers/user_provider.dart';
import 'package:softec_project/screens/add_new_task_screen.dart';
import 'package:softec_project/screens/chat_screen.dart';
import 'package:softec_project/screens/task_builder.dart';
import 'package:softec_project/theme/theme.dart';
import 'package:softec_project/providers/task_provider.dart';
import 'package:softec_project/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final String randomAvatarUrl = 'https://i.pravatar.cc/300';

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (uid != null) {
        Provider.of<TaskProvider>(context, listen: false).fetchTasks(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      SimpleHiddenDrawerController.of(context).toggle();
                    },
                  ),
                  const Text("Home"),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: NetworkImage(randomAvatarUrl),
                    radius: 24,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavButton(0, 'Tasks', theme),
                  _buildNavButton(1, 'Calendar', theme),
                  _buildNavButton(2, 'Analytics', theme),
                ],
              ),
            ),
            Expanded(child: _buildSelectedScreen()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildNavButton(int index, String title, ThemeData theme) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return buildTasksList(context);
      case 1:
        return _buildCalendarView();
      case 2:
        return _buildAnalyticsView();
      default:
        return buildTasksList(context);
    }
  }

  Widget _buildCalendarView() {
    return const Center(
      child: Text('Calendar View Coming Soon', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildAnalyticsView() {
    return const Center(
      child: Text('Analytics View Coming Soon', style: TextStyle(fontSize: 16)),
    );
  }
}
