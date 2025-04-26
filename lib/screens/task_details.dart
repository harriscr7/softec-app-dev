import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/models/task_model.dart';
import 'package:softec_project/providers/task_provider.dart';
import 'package:softec_project/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatefulWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late String _category;
  bool _isLoading = false; // ADD THIS

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _dueDate = widget.task.dueDate;
    _category = widget.task.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    if (_isLoading) return; // Prevent multiple updates

    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    if (uid == null) return;

    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      category: _category,
      isCompleted: widget.task.isCompleted,
      createdAt: widget.task.createdAt,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<TaskProvider>(
        context,
        listen: false,
      ).updateTask(updatedTask, uid);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after a short delay
      await Future.delayed(const Duration(milliseconds: 5000));
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update task: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          _isLoading
              ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
              : IconButton(
                icon: const Icon(Icons.save),
                onPressed: _updateTask,
              ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_dueDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'General', child: Text('General')),
                DropdownMenuItem(value: 'Work', child: Text('Work')),
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
