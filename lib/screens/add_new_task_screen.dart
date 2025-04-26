import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String _category = 'General';
  bool _isRecurring = false;

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
        dueDate: _dueDate,
        category: _category,
        isRecurring: _isRecurring,
        createdAt: DateTime.now(),
      );

      try {
        final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
        if (uid == null) {
          throw 'User not authenticated';
        }
        await Provider.of<TaskProvider>(
          context,
          listen: false,
        ).addTask(newTask, uid);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveTask),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(
                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _dueDate = date);
                  }
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'General', child: Text('General')),
                  DropdownMenuItem(value: 'Work', child: Text('Work')),
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                ],
                onChanged: (value) => setState(() => _category = value!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Recurring Task'),
                value: _isRecurring,
                onChanged: (value) => setState(() => _isRecurring = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
