import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SummariesScreen extends StatefulWidget {
  const SummariesScreen({super.key});

  @override
  State<SummariesScreen> createState() => _SummariesScreenState();
}

class _SummariesScreenState extends State<SummariesScreen> {
  final TextEditingController _noteController = TextEditingController();
  String _summary = '';
  bool _isLoading = false;
  bool _hasError = false;

  Future<void> _generateSummary() async {
    if (_noteController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _summary = '';
    });

    try {
      const apiKey = 'AIzaSyC3FdGM6kq7cIY5rOHv2BPsEFFC_qVwado';
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 300,
          temperature: 0.3,
        ),
      );

      final prompt = """
      Summarize this into 3-5 bullet points (max 300 characters):
      - Focus on key concepts
      - Include action items
      - Highlight dates/numbers
      - Use concise language
      - Format with markdown bullets

      Text to summarize:
      ${_noteController.text}
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      final generatedText = response.text?.trim() ?? 'No summary generated';

      setState(() {
        _summary = _formatSummary(generatedText);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _summary = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    }
  }

  String _formatSummary(String text) {
    return text
        .replaceAll(RegExp(r'^[\s*•-]+', multiLine: true), '• ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Summarizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed:
                () => showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Using Gemini 1.5 Flash'),
                        content: const Text(
                          'This free model provides fast, concise summaries.\n\n'
                          'For best results:\n'
                          '• Keep notes under 1000 words\n'
                          '• Include clear key terms\n'
                          '• Avoid overly complex texts',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _noteController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: 'Paste your notes',
                      labelStyle: const TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Example: Lecture notes, meeting minutes...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_hasError)
                    Text(
                      _summary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  if (_summary.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Summary:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(_summary),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  '${_summary.split('\n').length} points',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: _summary),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _isLoading ? null : _generateSummary,
              child: const Text('Generate Summary'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
