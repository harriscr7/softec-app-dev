import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Pass user UID when adding a task
  Future<void> addTask(Task task, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task.id)
          .set(task.toMap());
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding task: $e');
      }
      rethrow;
    }
  }

  // Fetch tasks for a specific user
  Future<void> fetchTasks(String uid) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('tasks')
              .get();
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching tasks: $e');
      }
    }
  }

  // Delete a task from Firestore
  Future<void> deleteTask(String taskId, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting task: $e');
      }
      rethrow;
    }
  }

  // Update a task in Firestore
  Future<void> updateTask(Task task, String uid) async {
    try {
      // First update Firestore
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());
      
      // Then update local state
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      } else {
        // If task not found locally, add it
        _tasks.add(task);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating task: $e');
      }
      rethrow;
    }
  }
}
