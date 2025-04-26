import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/providers/task_provider.dart';
import 'package:softec_project/providers/mood_provider.dart';
import 'package:softec_project/providers/task_list.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return MoodAwareTaskList(allTasks: taskProvider.tasks);
        },
      ),
    );
  }
}
