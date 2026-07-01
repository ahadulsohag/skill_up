import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  bool _isLoading = false;
  String? _errorMessage;

  // FIXED: Changed String? to String so it matches your getter
  String _userRole = 'user';

  // Getters
  String get userRole => _userRole;
  bool get isAdmin => _userRole == 'admin';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _supabaseService.isLoggedIn;
  User? get currentUser => _supabaseService.currentUser;

  // Added this method so your main.dart can fetch the role on startup!
  Future<String> fetchUserRole(String userId) async {
    try {
      final role = await _supabaseService.fetchUserRole(userId);
      _userRole = role; // Cache it in the provider
      notifyListeners();
      return role;
    } catch (e) {
      debugPrint('Error fetching user role: $e');
      return 'user';
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _supabaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getFriendlyErrorMessage(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _supabaseService.signIn(email: email, password: password);
      // After successful sign-in, fetch the user's role
      final user = _supabaseService.currentUser;
      if (user != null) {
        _userRole = await _supabaseService.fetchUserRole(user.id);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getFriendlyErrorMessage(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
    _userRole = 'user'; // reset
    notifyListeners();
  }

  // FIXED: These methods are now properly INSIDE the class
  String _getFriendlyErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password. Please try again.';
    } else if (error.contains('User already registered')) {
      return 'An account with this email already exists.';
    } else if (error.contains('Password should be at least 6 characters')) {
      return 'Password must be at least 6 characters long.';
    } else if (error.contains('Email not confirmed')) {
      return 'Please verify your email address first.';
    }
    return 'An error occurred. Please try again.';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} // Properly closing the AuthProvider class here
