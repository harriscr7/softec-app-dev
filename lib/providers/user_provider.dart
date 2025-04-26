import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> loadUserData(String uid) async {
    if (_user != null && _user!.uid == uid) return; // Don't reload if we already have the data
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!, uid);
      } else {
        _error = 'User data not found';
      }
    } catch (e) {
      _error = 'Failed to load user data: ${e.toString()}';
      debugPrint("Error loading user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    if (_user == null) return;
    await loadUserData(_user!.uid);
  }

  void clearUserData() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}
