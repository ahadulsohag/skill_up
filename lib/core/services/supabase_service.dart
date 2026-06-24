import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lltxpzcxwlbbxhtncrze.supabase.co',
      anonKey: 'sb_publishable_0wc_yu8dRmaY8skztFk9KQ_Q_5BUY6t',
    );
  }

  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => Supabase.instance.client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // --- Auth Section ---
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // --- Profile Queries ---
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final uid = currentUser?.id;
    if (uid == null) throw Exception('User not authenticated');
    return await client.from('profiles').select().eq('id', uid).single();
  }

  // --- Course & Lesson Queries ---
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    return await client.from('courses').select().order('title');
  }

  Future<List<Map<String, dynamic>>> fetchLessons(String courseId) async {
    return await client
        .from('lessons')
        .select()
        .eq('course_id', courseId)
        .order('chapter_number', ascending: true);
  }

  // FIXED: Changed 'user_lesson_progress' to 'user_progress'
  Future<List<dynamic>> fetchUserCompletedLessons() async {
    final uid = currentUser?.id;
    if (uid == null) return [];
    final response = await client
        .from('user_progress')
        .select('lesson_id')
        .eq('user_id', uid);
    return response.map((element) => element['lesson_id']).toList();
  }

  // --- Progress Updates ---
  Future<void> markLessonAsComplete(String lessonId, int courseXpReward) async {
    final uid = currentUser?.id;
    if (uid == null) return;

    // FIXED: Changed 'user_lesson_progress' to 'user_progress'
    // 1. Record lesson completion status safely
    await client.from('user_progress').upsert({
      'user_id': uid,
      'lesson_id': lessonId,
    });

    // 2. Query current points value to increment accurately
    final profile = await fetchUserProfile();
    int activeXp = profile['xp'] ?? 0;

    // 3. Increment XP on user profiles table
    await client
        .from('profiles')
        .update({'xp': activeXp + courseXpReward})
        .eq('id', uid);
  }
}
