import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Initialize Supabase - Call this in main.dart
  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lltxpzcxwlbbxhtncrze.supabase.co',
      anonKey: 'sb_publishable_0wc_yu8dRmaY8skztFk9KQ_Q_5BUY6t',
    );
  }

  // Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  // Get current user
  User? get currentUser => Supabase.instance.client.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
