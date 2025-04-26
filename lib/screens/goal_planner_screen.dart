import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GoalPlannerScreen extends StatefulWidget {
  const GoalPlannerScreen({super.key});

  @override
  State<GoalPlannerScreen> createState() => _GoalPlannerScreenState();
}

class _GoalPlannerScreenState extends State<GoalPlannerScreen> {
  final TextEditingController _goalController = TextEditingController();
  List<String> _subtasks = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  Future<void> _generateChecklist() async {
    if (_goalController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _subtasks = [];
    });

    try {
      // Initialize with your free-tier API key
      const apiKey =
          'AIzaSyC3FdGM6kq7cIY5rOHv2BPsEFFC_qVwado'; // Get from Google AI Studio
      final model = GenerativeModel(
        model: 'gemini-1.5-flash', // Free tier model
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 300, // Keep responses short
          temperature: 0.3, // More deterministic output
        ),
      );

      final prompt = """
      Break down the following goal into 4-6 actionable steps as a checklist.
      Each step should start with a verb and be specific enough to execute.
      Format as a numbered list without additional explanations.
      
      Goal: ${_goalController.text}
      
      Example format:
      1. Research available internship programs
      2. Update resume with recent projects
      3. Write cover letter template
      4. Identify 10 target companies
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      if (text.isEmpty) {
        throw Exception('No checklist generated');
      }

      // Parse the numbered list into individual tasks
      final tasks =
          text
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
              .where((task) => task.isNotEmpty)
              .toList();

      setState(() {
        _subtasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = 'Failed to generate checklist: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: 'Enter your goal',
                hintText:
                    'e.g. "Apply for internship", "Plan a trip to Europe"',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _generateChecklist,
                ),
              ),
              onSubmitted: (_) => _generateChecklist(),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_hasError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            if (_subtasks.isNotEmpty) ...[
              const Text(
                'Action Plan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _subtasks.length,
                  itemBuilder:
                      (context, index) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(_subtasks[index]),
                          leading: CircleAvatar(child: Text('${index + 1}')),
                        ),
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Goal Planner Help'),
            content: const Text(
              'Enter any big goal and get an actionable checklist.\n\n'
              'Examples:\n'
              '• "Prepare for final exams"\n'
              '• "Organize a birthday party"\n'
              '• "Start a fitness routine"\n\n'
              'The AI will break it down into clear steps.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }
}
