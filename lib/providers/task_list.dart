import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/models/task_model.dart';
import 'package:softec_project/providers/mood_provider.dart';
import 'package:softec_project/providers/mood_tracker.dart';
import 'package:intl/intl.dart';

class MoodAwareTaskList extends StatelessWidget {
  final List<Task> allTasks;

  const MoodAwareTaskList({super.key, required this.allTasks});

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final filteredTasks = moodProvider.filterTasksByMood(allTasks);
    final tasksToShow = filteredTasks.isNotEmpty ? filteredTasks : allTasks;

    return Column(
      children: [
        MoodTracker(),
        Expanded(
          child: ListView.builder(
            itemCount: tasksToShow.length,
            itemBuilder: (ctx, index) => TaskItem(tasksToShow[index]),
          ),
        ),
      ],
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: task.description != null ? Text(task.description!) : null,
      trailing: Text(DateFormat('MMM dd').format(task.dueDate)),
    );
  }
}
