import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;

  UserProfile? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Mock network request latency
    await Future.delayed(const Duration(seconds: 1));

    if (email.contains('@') && password.length >= 6) {
      String displayName = email.split('@').first;
      if (displayName.isNotEmpty) {
        displayName = displayName[0].toUpperCase() + displayName.substring(1);
      } else {
        displayName = 'User';
      }

      _user = UserProfile(
        uid: 'email_${DateTime.now().millisecondsSinceEpoch}',
        displayName: displayName,
        email: email,
        photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
        loginMethod: 'email',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    // Mock network request latency
    await Future.delayed(const Duration(seconds: 1));

    _user = UserProfile(
      uid: 'google_${DateTime.now().millisecondsSinceEpoch}',
      displayName: 'Alex Carter',
      email: 'alex.carter@gmail.com',
      photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
      loginMethod: 'google',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> registerWithEmail(String displayName, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (displayName.isNotEmpty && email.contains('@') && password.length >= 6) {
      _user = UserProfile(
        uid: 'email_${DateTime.now().millisecondsSinceEpoch}',
        displayName: displayName,
        email: email,
        photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
        loginMethod: 'email',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }
}
