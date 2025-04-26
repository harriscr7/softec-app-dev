import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/providers/mood_provider.dart';

class MoodTracker extends StatelessWidget {
  const MoodTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Mood:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildMoodButton(context, '😊 Energized', 'energized'),
                    _buildMoodButton(context, '😐 Neutral', 'neutral'),
                    _buildMoodButton(context, '😟 Stressed', 'stressed'),
                    _buildMoodButton(context, '😴 Tired', 'tired'),
                  ],
                ),
                if (moodProvider.currentMood != 'neutral')
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Showing ${moodProvider.currentMood}-friendly tasks',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodButton(BuildContext context, String label, String mood) {
    return ChoiceChip(
      label: Text(label),
      selected: Provider.of<MoodProvider>(context).currentMood == mood,
      onSelected:
          (_) =>
              Provider.of<MoodProvider>(context, listen: false).logMood(mood),
    );
  }
}
