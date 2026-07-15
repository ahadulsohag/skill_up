import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/course_provider.dart';
import '../../../lesson/presentation/screens/course_detail_screen.dart';
import '../widgets/current_mission_card.dart';
import '../widgets/popular_skills_section.dart';
import '../widgets/your_path_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : CustomScrollView(
              slivers: [
                // User greeting header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${provider.userProfile?.fullName ?? 'Learner'}! 👋',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingS),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingM,
                                vertical: AppDimensions.paddingS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusM,
                                ),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.stars_rounded,
                                    size: 16,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: AppDimensions.paddingS),
                                  Text(
                                    '${provider.userProfile?.xp ?? 0} XP',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Current Mission - First incomplete course
                      if (provider.courses.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            final currentCourse = provider.courses.firstWhere(
                              (course) => course.progress < 1.0,
                              orElse: () => provider.courses.first,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(course: currentCourse),
                              ),
                            );
                          },
                          child: _buildCurrentMissionSection(context, provider),
                        ),
                        const SizedBox(height: AppDimensions.paddingXL),
                      ],

                      // Your Learning Path - Show all courses
                      if (provider.courses.isNotEmpty) ...[
                        YourPathSection(courses: provider.courses),
                        const SizedBox(height: AppDimensions.paddingXL),
                      ],

                      // Featured Course - Course with highest progress
                      if (provider.courses.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            final featuredCourse = provider.courses.reduce(
                              (a, b) => a.progress > b.progress ? a : b,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(course: featuredCourse),
                              ),
                            );
                          },
                          child: _buildFeaturedCourseSection(context, provider),
                        ),
                        const SizedBox(height: AppDimensions.paddingXL),
                      ],

                      // Statistics Overview
                      GestureDetector(
                        onTap: () {
                          // Navigate to courses screen to see all stats
                          Navigator.pushNamed(context, '/main');
                        },
                        child: _buildStatsSection(context, provider),
                      ),
                      const SizedBox(height: AppDimensions.paddingXL),

                      // Popular Skills
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Skills section coming soon!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: PopularSkillsSection(),
                      ),
                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCurrentMissionSection(
    BuildContext context,
    CourseProvider provider,
  ) {
    // Find first incomplete course or just take the first one
    final currentCourse = provider.courses.firstWhere(
      (course) => course.progress < 1.0,
      orElse: () => provider.courses.first,
    );

    return CurrentMissionCard(
      progress: currentCourse.progress,
      courseName: currentCourse.title,
    );
  }

  Widget _buildFeaturedCourseSection(
    BuildContext context,
    CourseProvider provider,
  ) {
    // Get the course with highest progress or first if all 0
    final featuredCourse = provider.courses.reduce(
      (a, b) => a.progress > b.progress ? a : b,
    );

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            featuredCourse.color,
            featuredCourse.color.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Course',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  featuredCourse.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Text(
                  featuredCourse.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  child: LinearProgressIndicator(
                    value: featuredCourse.progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, CourseProvider provider) {
    final totalCourses = provider.courses.length;
    final completedCourses = provider.courses
        .where((c) => c.progress == 1.0)
        .length;
    final inProgressCourses = provider.courses
        .where((c) => c.progress > 0 && c.progress < 1.0)
        .length;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                icon: Icons.school_rounded,
                label: 'Courses',
                value: '$totalCourses',
                color: AppColors.primary,
              ),
              _buildStatItem(
                context,
                icon: Icons.check_circle_rounded,
                label: 'Completed',
                value: '$completedCourses',
                color: AppColors.success,
              ),
              _buildStatItem(
                context,
                icon: Icons.hourglass_bottom_rounded,
                label: 'In Progress',
                value: '$inProgressCourses',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }
}
