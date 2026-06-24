import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_up/core/providers/course_provider.dart';
import 'package:skill_up/features/lesson/presentation/screens/lesson_detail_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:skill_up/features/auth/domain/models/course_models.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Watch the provider to get real-time updates when a lesson is completed
    final lessons = context.watch<CourseProvider>().getLessonsForCourse(
      course.id,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Header (Dynamically uses course data)
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [course.color, course.color.withAlpha(200)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(course.icon, size: 50, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.access_time_rounded,
                              course.duration,
                              'ESTIMATED',
                            ),
                            const SizedBox(width: 16),
                            _buildInfoChip(
                              Icons.stars_rounded,
                              '${course.xpReward} XP',
                              'REWARD',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Course Curriculum Section
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.paddingM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Course Curriculum',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: course.color.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${lessons.length} Lessons',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: course.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingL),

                // Dynamically build the list of lessons
                if (lessons.isEmpty)
                  const Center(child: Text("Loading lessons..."))
                else
                  ...lessons
                      .map(
                        (lesson) =>
                            _buildLessonItem(context, lesson, lessons, course),
                      )
                      .toList(),

                const SizedBox(height: AppDimensions.paddingXL),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(
    BuildContext context,
    LessonModel lesson,
    List<LessonModel> allLessons,
    CourseModel course,
  ) {
    // Logic to unlock only if it's chapter 1, or if the previous chapter is completed
    bool isUnlocked =
        lesson.chapterNumber == 1 ||
        lesson.isCompleted ||
        allLessons.any(
          (l) => l.chapterNumber == lesson.chapterNumber - 1 && l.isCompleted,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: lesson.isCompleted
                ? Colors.green
                : (isUnlocked
                      ? course.color.withAlpha(15)
                      : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            lesson.isCompleted
                ? Icons.check_rounded
                : (isUnlocked ? Icons.play_arrow_rounded : Icons.lock_rounded),
            color: lesson.isCompleted
                ? Colors.white
                : (isUnlocked ? course.color : Colors.grey),
            size: 24,
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isUnlocked ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Text(
          lesson.subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: lesson.isCompleted
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              )
            : null,
        onTap: () {
          if (isUnlocked) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LessonDetailScreen(course: course, lesson: lesson),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Complete previous lessons first!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
