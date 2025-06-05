import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _showFeedback(context, e.message ?? "Sign up failed.", isError: true);
      return null;
    } catch (e) {
      _showFeedback(context, "An unexpected error occurred during sign up.", isError: true);
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _showFeedback(context, e.message ?? "Sign in failed.", isError: true);
      return null;
    } catch (e) {
      _showFeedback(context, "An unexpected error occurred during sign in.", isError: true);
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    if (email.isEmpty) {
      _showFeedback(context, "Please enter your email address to reset password.", isError: true);
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showFeedback(context, "Password reset email sent to $email. Please check your inbox (and spam folder).");
    } on FirebaseAuthException catch (e) {
      _showFeedback(context, e.message ?? "Failed to send password reset email.", isError: true);
    } catch (e) {
      _showFeedback(context, "An unexpected error occurred.", isError: true);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _showFeedback(context, e.message ?? "Sign out failed.", isError: true);
    } catch (e) {
       _showFeedback(context, "An unexpected error occurred during sign out.", isError: true);
    }
  }

  void _showFeedback(BuildContext context, String message, {bool isError = false}) {
    if (ScaffoldMessenger.maybeOf(context) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      print("Feedback: $message (Context not available for SnackBar)");
    }
  }
}
