import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel() {
    // Listen to auth changes
    _authService.userChanges.listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      currentUser = await _authService.signInWithEmail(email, password);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> registerWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      currentUser = await _authService.registerWithEmail(email, password);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      currentUser = await _authService.signInWithGoogle();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
