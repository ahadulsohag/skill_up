import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:skill_up/features/lesson/presentation/screens/variable_lesson_screen.dart';

class PythonBasicsScreen extends StatelessWidget {
  const PythonBasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Header
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
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.code_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Python Basics',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Master the foundational logic of the world\'s most versatile programming language.',
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
                              '4.5h',
                              'ESTIMATED TIME',
                            ),
                            const SizedBox(width: 16),
                            _buildInfoChip(
                              Icons.stars_rounded,
                              '240 XP',
                              'REWARD POINTS',
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

                // Curriculum Header
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
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '8 Lessons',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingL),

                // Lesson List
                _buildLessonItem(
                  context,
                  'Intro to Variables',
                  'Chapter 1 • 12 mins',
                  1,
                  true,
                ),
                _buildLessonItem(
                  context,
                  'Loops & Logic',
                  'Chapter 2 • 18 mins',
                  2,
                  false,
                ),
                _buildLessonItem(
                  context,
                  'List Comprehension',
                  'Chapter 3 • 15 mins',
                  3,
                  false,
                ),
                _buildLessonItem(
                  context,
                  'Functional Structures',
                  'Chapter 4 • 22 mins',
                  4,
                  false,
                ),
                _buildLessonItem(
                  context,
                  'Error Handling',
                  'Chapter 5 • 10 mins',
                  5,
                  false,
                ),

                const SizedBox(height: AppDimensions.paddingXL),

                // Resume Button
                CustomButton(
                  text: 'Resume Course',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VariablesLessonScreen(),
                      ),
                    );
                  },
                  prefix: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),

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
    String title,
    String subtitle,
    int chapterNumber,
    bool isCompleted,
  ) {
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
            gradient: isCompleted ? AppColors.primaryGradient : null,
            color: isCompleted ? null : AppColors.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check_rounded : Icons.play_arrow_rounded,
            color: isCompleted ? Colors.white : AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: isCompleted
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
            : const Icon(Icons.lock_open_rounded, color: Colors.grey, size: 20),
        onTap: () {
          if (isCompleted || chapterNumber == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VariablesLessonScreen(),
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
