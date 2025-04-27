import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/screens/scan_task_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late stt.SpeechToText _speech;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';
  bool _initializationComplete = false;
  bool _autoSubmitPending = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetState();
  }

  void _resetState() {
    if (_isListening) {
      _speech.stop();
    }
    _titleController.clear();
    setState(() {
      _isListening = false;
      _lastWords = '';
      _autoSubmitPending = false;
    });
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          if (mounted) {
            setState(() {
              _isListening = status == 'listening';
              if (!_isListening &&
                  _lastWords.isNotEmpty &&
                  !_autoSubmitPending) {
                _autoSubmitPending = true;
                _performAutoSubmit();
              }
            });
          }
        },
        onError: (error) {
          if (mounted) {
            _showError('Speech recognition error: ${error.errorMsg}');
          }
        },
      );
    } catch (e) {
      if (mounted) {
        _showError('Speech initialization failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _initializationComplete = true);
      }
    }
  }

  Future<void> _performAutoSubmit() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted && _lastWords.isNotEmpty) {
      _titleController.text = _lastWords;
      await _saveTask();
      setState(() {
        _autoSubmitPending = false;
        _lastWords = '';
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleListening() async {
    if (!_initializationComplete) return;
    if (!_speechEnabled) {
      _showError('Speech recognition not available');
      return;
    }
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _lastWords = '';
      _autoSubmitPending = false;
    });
    try {
      await _speech.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              _lastWords = result.recognizedWords;
              if (result.finalResult) {
                _titleController.text = _lastWords;
              }
            });
          }
        },
        listenFor: const Duration(seconds: 30),
        localeId: 'en_US',
        cancelOnError: true,
        partialResults: true,
      );
    } catch (e) {
      if (mounted) {
        _showError('Listening failed: ${e.toString()}');
        setState(() => _isListening = false);
      }
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
    } catch (e) {
      if (mounted) {
        _showError('Failed to stop listening: ${e.toString()}');
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final dueDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        dueDate: dueDateTime,
        category: 'General',
        isRecurring: false,
        createdAt: DateTime.now(),
      );

      try {
        final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
        if (uid == null) throw 'User not authenticated';

        await Provider.of<TaskProvider>(
          context,
          listen: false,
        ).addTask(newTask, uid);
        if (mounted) {
          Navigator.pop(context);
          _resetState();
        }
      } catch (e) {
        _showError('Failed to save: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final textTheme = theme.textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanTaskScreen()),
            ),
        backgroundColor: primaryColor,
        child: const Icon(Icons.document_scanner, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Task Title*',
                  labelStyle: textTheme.bodyMedium,
                  border: const OutlineInputBorder(),
                  suffixIcon: _buildMicButton(primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectDate,
                      icon: Icon(Icons.calendar_today, color: primaryColor),
                      label: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: primaryColor,
                        ),
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
                      onPressed: _selectTime,
                      icon: Icon(Icons.access_time, color: primaryColor),
                      label: Text(
                        _selectedTime.format(context),
                        style: textTheme.bodyMedium?.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primaryColor,
                        backgroundColor: primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isListening)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _lastWords.isEmpty ? 'Listening...' : _lastWords,
                    style: textTheme.bodyMedium?.copyWith(
                      color: primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (_autoSubmitPending)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton(Color primaryColor) {
    if (!_initializationComplete) {
      return Icon(Icons.mic, color: Colors.grey);
    }
    return IconButton(
      icon: Icon(
        _isListening ? Icons.mic_off : Icons.mic,
        color:
            _isListening
                ? Colors.red
                : (_speechEnabled ? primaryColor : Colors.grey),
      ),
      onPressed: _toggleListening,
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _titleController.dispose();
    super.dispose();
  }
}
