import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/providers/user_provider.dart';
import 'package:softec_project/screens/add_new_task_screen.dart';
import 'package:softec_project/screens/task_screen.dart';
import 'package:softec_project/theme/theme.dart';
import 'package:softec_project/providers/task_provider.dart';
import 'package:softec_project/providers/auth_provider.dart';
import 'package:softec_project/screens/task_builder.dart';
import 'package:softec_project/screens/calendar_screen.dart';
import 'package:softec_project/screens/mood_screen.dart';
import 'package:softec_project/screens/reminders_screen.dart';
import 'package:softec_project/screens/summaries_screen.dart';
import 'package:softec_project/screens/goal_planner_screen.dart'; // Add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String randomAvatarUrl = 'https://i.pravatar.cc/300';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (uid != null) {
        Provider.of<TaskProvider>(context, listen: false).fetchTasks(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      SimpleHiddenDrawerController.of(context).toggle();
                    },
                  ),
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: NetworkImage(randomAvatarUrl),
                    radius: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Tasks Container
                    _buildDashboardCard(
                      context,
                      title: "Tasks",
                      description: "Manage your daily tasks and to-do items",
                      icon: Icons.task,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    // Schedule Container
                    _buildDashboardCard(
                      context,
                      title: "Schedule",
                      description: "View and manage your calendar schedule",
                      icon: Icons.calendar_today,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 16),

                    // Mood Container
                    _buildDashboardCard(
                      context,
                      title: "Mood",
                      description: "Track your daily mood and emotional trends",
                      icon: Icons.mood,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 16),

                    // Reminders Container
                    _buildDashboardCard(
                      context,
                      title: "Reminders",
                      description: "Set and manage your important reminders",
                      icon: Icons.notifications,
                      color: Colors.purple,
                    ),

                    const SizedBox(height: 16),

                    // Summaries Container
                    _buildDashboardCard(
                      context,
                      title: "Summaries",
                      description: "View your task summaries and insights",
                      icon: Icons.summarize,
                      color: Colors.teal,
                    ),

                    const SizedBox(height: 16),

                    // Goal Planner Container (New)
                    _buildDashboardCard(
                      context,
                      title: "Goal Planner",
                      description: "Break down big goals into actionable steps",
                      icon: Icons.checklist_rtl,
                      color: Colors.indigo,
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

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        switch (title.toLowerCase()) {
          case 'tasks':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskScreen()),
            );
            break;
          case 'schedule':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            );
            break;
          case 'mood':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodScreen()),
            );
            break;
          case 'reminders':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RemindersScreen()),
            );
            break;
          case 'summaries':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SummariesScreen()),
            );
            break;
          case 'goal planner': // New case
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GoalPlannerScreen(),
              ),
            );
            break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.8),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
