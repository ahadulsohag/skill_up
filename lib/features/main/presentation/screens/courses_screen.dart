import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../routes/app_routes.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: [
          _buildCourseCard(
            context,
            'Python Basics',
            'Learn the fundamentals of Python programming.',
            Icons.code_rounded,
            AppRoutes.pythonBasics,
          ),
          _buildCourseCard(
            context,
            'Flutter UI Design',
            'Master the art of creating beautiful mobile interfaces.',
            Icons.palette_rounded,
            null,
          ),
          _buildCourseCard(
            context,
            'Data Science 101',
            'Introduction to data analysis and visualization.',
            Icons.analytics_rounded,
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String? route,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.paddingM),
        leading: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingS),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      ),
    );
  }
}
