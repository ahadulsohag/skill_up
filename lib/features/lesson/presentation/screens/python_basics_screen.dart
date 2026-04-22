import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';

class PythonBasicsScreen extends StatelessWidget {
  const PythonBasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Python Basics',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Icon(
                    Icons.code_rounded,
                    size: 80,
                    color: Colors.white.withAlpha(51),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle(context, 'Introduction'),
                const Text(
                  'Python is a high-level, general-purpose programming language. Its design philosophy emphasizes code readability with the use of significant indentation.',
                  style: TextStyle(fontSize: AppDimensions.fontM),
                ),
                const SizedBox(height: AppDimensions.paddingL),
                _buildSectionTitle(context, 'Key Features'),
                _buildBulletPoint('Interpreted language'),
                _buildBulletPoint('Easy to learn'),
                _buildBulletPoint('Dynamically typed'),
                _buildBulletPoint('Large standard library'),
                const SizedBox(height: AppDimensions.paddingL),
                _buildSectionTitle(context, 'First Program'),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: const Text(
                    'print("Hello, SkillUp!")',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontFamily: 'monospace',
                      fontSize: AppDimensions.fontM,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                CustomButton(
                  text: 'Complete Lesson',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
