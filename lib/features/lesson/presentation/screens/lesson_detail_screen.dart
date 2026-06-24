import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_up/core/providers/course_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:skill_up/features/auth/domain/models/course_models.dart';
class LessonDetailScreen extends StatefulWidget {
  final CourseModel course;
  final LessonModel lesson;

  const LessonDetailScreen({
    super.key,
    required this.course,
    required this.lesson,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _isSavingProgress = false;

  // This pushes the XP to Supabase via our Provider!
  Future<void> _completeAndSyncLesson() async {
    if (widget.lesson.isCompleted) {
      Navigator.pop(context); // Already completed, just go back
      return;
    }

    setState(() => _isSavingProgress = true);

    // Give 50 XP per lesson completion
    await context.read<CourseProvider>().completeLesson(
      widget.course.id,
      widget.lesson.id,
      50,
    );

    if (mounted) {
      setState(() => _isSavingProgress = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Lesson Completed! +50 XP'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back to course details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.course.color.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  widget.lesson.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 16,
                  color: widget.course.color,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.lesson.isCompleted ? '100%' : 'In Progress',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.course.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: widget.lesson.isCompleted ? 1.0 : 0.5,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(widget.course.color),
              minHeight: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lesson.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // NOTE: If lesson.content is null in Supabase, we fall back to a placeholder for now!
                  _buildExplanationCard(
                    widget.lesson.content ??
                        'This is where your dynamic lesson content from Supabase will go! For now, keep learning and expanding your database.',
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),

                  CustomButton(
                    text: _isSavingProgress
                        ? 'Syncing to Cloud...'
                        : (widget.lesson.isCompleted
                              ? 'Go Back'
                              : 'Complete Lesson (+50 XP)'),
                    backgroundColor: widget.course.color,
                    onPressed: _isSavingProgress
                        ? null
                        : _completeAndSyncLesson,
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.course.color.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.course.color.withAlpha(30)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: widget.course.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
