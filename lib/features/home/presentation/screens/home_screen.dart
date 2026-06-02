import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            sizedbox(height:2),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withAlpha(40),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            const Text(AppStrings.skillUp),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      // SingleChildScrollView prevents layout crashes/overflows on smaller screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.paddingM),

              // Welcome Hero Illustration Container
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // Greeting Text
              Text(
                AppStrings.hello,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                AppStrings.readyToLearn,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.paddingXL),

              // Enhancement 1: Quick Progress/Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildStatCard(context, '2', 'Courses\nActive'),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: _buildStatCard(context, '45%', 'Overall\nProgress'),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: _buildStatCard(context, '5d', 'Streak\nDays'),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingXL * 1.5),

              // Enhancement 2: Section Title for Popular Topics
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Popular Topics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),

              // Horizontal Topics List
              SizedBox(
                height: 115,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildTopicCard(
                      context,
                      Icons.code_rounded,
                      'Python',
                      AppRoutes.pythonBasics,
                    ),
                    _buildTopicCard(
                      context,
                      Icons.html_rounded,
                      'Web Dev',
                      AppRoutes.pythonBasics,
                    ),
                    _buildTopicCard(
                      context,
                      Icons.storage_rounded,
                      'SQL Data',
                      AppRoutes.pythonBasics,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXL * 1.5),

              // Primary CTA Button
              CustomButton(
                text: 'Continue Learning',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.pythonBasics);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for dynamic statistic chips
  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(15),
        borderRadius: BorderRadius.circular(AppDimensions.paddingM),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Helper builder for horizontal topic cards
  Widget _buildTopicCard(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(right: AppDimensions.paddingM),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Colors.grey.withAlpha(30)),
          borderRadius: BorderRadius.circular(AppDimensions.paddingM),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
