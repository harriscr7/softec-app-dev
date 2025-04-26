import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        _lastWords = ''; // Reset last words after auto-submit
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

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        dueDate: DateTime.now().add(const Duration(days: 1)),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title*',
                  border: const OutlineInputBorder(),
                  suffixIcon: _buildMicButton(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              if (_isListening)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _lastWords.isEmpty ? 'Listening...' : _lastWords,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (_autoSubmitPending)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    if (!_initializationComplete) {
      return const Icon(Icons.mic, color: Colors.grey);
    }
    return IconButton(
      icon: Icon(
        _isListening ? Icons.mic_off : Icons.mic,
        color:
            _isListening
                ? Colors.red
                : (_speechEnabled ? Colors.blue : Colors.grey),
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
