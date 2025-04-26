import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Task> _tasks = [];
  String? _currentUserId;

  List<Task> get tasks => _tasks;
  String? get currentUser => _currentUserId;

  // Set current user ID
  void setCurrentUser(String uid) {
    _currentUserId = uid;
  }

  // Add a new task
  Future<void> addTask(Task task, [String? uid]) async {
    final userId = uid ?? _currentUserId;
    if (userId == null) throw 'User not authenticated';

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(task.id)
          .set(task.toMap());

      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error adding task: $e');
      rethrow;
    }
  }

  // Fetch all tasks for user
  Future<void> fetchTasks([String? uid]) async {
    final userId = uid ?? _currentUserId;
    if (userId == null) throw 'User not authenticated';

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('tasks')
              .orderBy('dueDate', descending: false)
              .get();

      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error fetching tasks: $e');
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId, [String? uid]) async {
    final userId = uid ?? _currentUserId;
    if (userId == null) throw 'User not authenticated';

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .delete();

      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error deleting task: $e');
      rethrow;
    }
  }

  // Update a task
  Future<void> updateTask(Task task, [String? uid]) async {
    final userId = uid ?? _currentUserId;
    if (userId == null) throw 'User not authenticated';

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      } else {
        _tasks.add(task);
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error updating task: $e');
      rethrow;
    }
  }

  // Get tasks for a specific date
  List<Task> getTasksForDate(DateTime date) {
    return _tasks
        .where(
          (task) =>
              task.dueDate.year == date.year &&
              task.dueDate.month == date.month &&
              task.dueDate.day == date.day,
        )
        .toList();
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId, [String? uid]) async {
    final userId = uid ?? _currentUserId;
    if (userId == null) throw 'User not authenticated';

    try {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

      await updateTask(updatedTask, userId);
    } catch (e) {
      if (kDebugMode) print('Error toggling task completion: $e');
      rethrow;
    }
  }

  // Stream of tasks for real-time updates
  Stream<List<Task>> get tasksStream {
    if (_currentUserId == null) throw 'User not authenticated';

    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('tasks')
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList(),
        );
  }

  // Clear all tasks (for logout)
  void clearTasks() {
    _tasks.clear();
    _currentUserId = null;
    notifyListeners();
  }
}
