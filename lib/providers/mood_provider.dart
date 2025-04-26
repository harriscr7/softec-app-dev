import 'package:flutter/foundation.dart';
import 'package:softec_project/models/task_model.dart';

class MoodProvider with ChangeNotifier {
  String _currentMood = 'neutral';
  final List<Map<String, dynamic>> _moodLogs = [];

  String get currentMood => _currentMood;
  List<Map<String, dynamic>> get moodLogs => _moodLogs;

  void logMood(String mood) {
    _currentMood = mood;
    _moodLogs.add({'mood': mood, 'timestamp': DateTime.now()});
    notifyListeners();
  }

  // Mood-based task filtering rules
  List<String> _getMoodFilters() {
    switch (_currentMood) {
      case 'stressed':
        return ['priority', 'quick'];
      case 'tired':
        return ['important', 'short'];
      case 'energized':
        return ['challenging', 'creative'];
      default:
        return []; // Show all for neutral mood
    }
  }

  // Apply mood-based sorting
  List<Task> filterTasksByMood(List<Task> tasks) {
    final filters = _getMoodFilters();
    if (filters.isEmpty) return tasks;

    return tasks.where((task) {
      return filters.any(
        (filter) =>
            task.title.toLowerCase().contains(filter) ||
            (task.description?.toLowerCase().contains(filter) ?? false) ||
            task.category.toLowerCase().contains(filter),
      );
    }).toList();
  }
}
