import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/models/task_model.dart';
import 'package:softec_project/providers/task_provider.dart';
import 'package:softec_project/providers/auth_provider.dart';

class TaskDetails extends StatefulWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late TextEditingController _titleController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _dueDate = widget.task.dueDate;
    _dueTime = TimeOfDay.fromDateTime(widget.task.dueDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (picked != null && picked != _dueTime) {
      setState(() => _dueTime = picked);
    }
  }

  Future<void> _updateTask() async {
    if (_isLoading) return;

    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    if (uid == null) return;

    final updatedDueDateTime = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _dueTime.hour,
      _dueTime.minute,
    );

    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      dueDate: updatedDueDateTime,
      category: widget.task.category,
      isCompleted: widget.task.isCompleted,
      isRecurring: widget.task.isRecurring,
      createdAt: widget.task.createdAt,
    );

    setState(() => _isLoading = true);

    try {
      await Provider.of<TaskProvider>(
        context,
        listen: false,
      ).updateTask(updatedTask, uid);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          _isLoading
              ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : IconButton(
                icon: const Icon(Icons.save),
                onPressed: _updateTask,
              ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today, color: primaryColor),
                    label: Text(
                      DateFormat('MMM dd, yyyy').format(_dueDate),
                      style: TextStyle(color: primaryColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: primaryColor.withOpacity(0.1),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: Icon(Icons.access_time, color: primaryColor),
                    label: Text(
                      _dueTime.format(context),
                      style: TextStyle(color: primaryColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: primaryColor.withOpacity(0.1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
