import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/providers/task_provider.dart';
import 'package:softec_project/providers/auth_provider.dart';
import 'package:softec_project/screens/task_details.dart';

Widget buildTasksList(BuildContext context) {
  return Consumer<TaskProvider>(
    builder: (context, taskProvider, child) {
      final tasks = taskProvider.tasks;
      final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;

      if (uid == null) return const SizedBox.shrink();
      if (tasks.isEmpty) {
        return const Center(
          child: Text(
            'No tasks yet. Add a new task to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children:
                tasks.map((task) {
                  return Dismissible(
                    key: Key(task.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                'Are you sure you want to delete this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    onDismissed: (direction) async {
                      try {
                        await taskProvider.deleteTask(task.id, uid);
                        if (context.mounted) {
                          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Task deleted successfully'),
                          //     backgroundColor: Colors.green,
                          //     behavior: SnackBarBehavior.floating,
                          //   ),
                          // );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //       'Failed to delete task: ${e.toString()}',
                          //     ),
                          //     backgroundColor: Colors.red,
                          //     behavior: SnackBarBehavior.floating,
                          //   ),
                          // );
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetails(task: task),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (task.isRecurring)
                                    const Icon(
                                      Icons.repeat,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),
                              if (task.description != null &&
                                  task.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    task.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(task.dueDate),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.category,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    task.category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              if (task.moodTag != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.emoji_emotions,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.moodTag!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
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
                }).toList(),
          ),
        ),
      );
    },
  );
}
