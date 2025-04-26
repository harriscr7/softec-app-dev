import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  bool get isAuthenticated => user != null;

  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userModel = UserModel(
        uid: cred.user!.uid,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(userModel.toMap());
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An error occurred during sign up.';
      }
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An error occurred during login.';
      }
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw 'An error occurred during logout. Please try again.';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An error occurred while sending password reset email.';
      }
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }
}
