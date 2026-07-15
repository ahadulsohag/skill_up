import 'package:flutter/material.dart';
import 'package:skill_up/features/auth/domain/models/course_models.dart';
import '../../../lesson/presentation/screens/course_detail_screen.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_colors.dart';

class YourPathSection extends StatelessWidget {
  final List<CourseModel> courses;

  const YourPathSection({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Learning Path',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Text(
                'No courses yet. Start learning today!',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              ),
            ),
          ),
        ],
      );
    }

    // Sort courses: completed first, then by progress
    final sortedCourses = [...courses]
      ..sort((a, b) {
        if (a.progress == 1.0 && b.progress != 1.0) return -1;
        if (a.progress != 1.0 && b.progress == 1.0) return 1;
        return b.progress.compareTo(a.progress);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Learning Path',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedCourses.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppDimensions.paddingM),
          itemBuilder: (context, index) {
            final course = sortedCourses[index];
            final isCompleted = course.progress == 1.0;
            final progressPercent = (course.progress * 100).toInt();

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(course: course),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.surface : Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: isCompleted ? AppColors.primary : AppColors.border,
                    width: isCompleted ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? AppColors.primary
                                : (course.progress > 0
                                      ? AppColors.warning
                                      : AppColors.border),
                          ),
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 14.0,
                                  color: Colors.white,
                                )
                              : (course.progress > 0
                                    ? const Icon(
                                        Icons.hourglass_bottom_rounded,
                                        size: 12.0,
                                        color: Colors.white,
                                      )
                                    : null),
                        ),
                        const SizedBox(width: AppDimensions.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: isCompleted
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppDimensions.paddingXS),
                              Text(
                                course.duration,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.textLight,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (!isCompleted)
                          Text(
                            '$progressPercent%',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                      ],
                    ),
                    if (!isCompleted) ...[
                      const SizedBox(height: AppDimensions.paddingM),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                        child: LinearProgressIndicator(
                          value: course.progress,
                          minHeight: 6,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            course.color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
