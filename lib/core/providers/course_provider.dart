import 'package:flutter/material.dart';
import 'package:skill_up/features/auth/domain/models/course_models.dart';
import '../services/supabase_service.dart';

class CourseProvider extends ChangeNotifier {
  final SupabaseService _service = SupabaseService();

  List<CourseModel> _courses = [];
  Map<String, List<LessonModel>> _courseLessons = {};
  UserProfileModel? _userProfile;
  bool _isLoading = false;

  List<CourseModel> get courses => _courses;
  UserProfileModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  List<LessonModel> getLessonsForCourse(String courseId) =>
      _courseLessons[courseId] ?? [];

  // Fetch courses, user progression analytics, and individual lesson assets
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch core primitives concurrently
      final rawCourses = await _service.fetchCourses();
      final completedLessonIds = List<String>.from(
        await _service.fetchUserCompletedLessons(),
      );
      final rawProfile = await _service.fetchUserProfile();

      _userProfile = UserProfileModel.fromJson(rawProfile);

      List<CourseModel> parsedCourses = [];

      // 2. Re-map courses and dynamically calculate live completion ratios
      for (var rawCourse in rawCourses) {
        final course = CourseModel.fromJson(rawCourse);
        final rawLessons = await _service.fetchLessons(course.id);

        final lessonsList = rawLessons
            .map((l) => LessonModel.fromJson(l, completedLessonIds))
            .toList();
        _courseLessons[course.id] = lessonsList;

        if (lessonsList.isNotEmpty) {
          int completedCount = lessonsList.where((l) => l.isCompleted).length;
          course.progress = completedCount / lessonsList.length;
        } else {
          course.progress = 0.0;
        }

        parsedCourses.add(course);
      }

      _courses = parsedCourses;
    } catch (e) {
      debugPrint("Error loading system metrics dashboard data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Complete a single interactive task
  Future<void> completeLesson(
    String courseId,
    String lessonId,
    int xpReward,
  ) async {
    try {
      await _service.markLessonAsComplete(lessonId, xpReward);
      // Reload updated records immediately from the schema
      await loadDashboardData();
    } catch (e) {
      debugPrint("Error completing lesson runtime action: $e");
    }
  }
}
