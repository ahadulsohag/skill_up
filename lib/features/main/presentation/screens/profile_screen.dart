import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            const Text(
              'Alex Rivera',
              style: TextStyle(
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'alex.rivera@university.edu',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            _buildProfileOption(Icons.settings, 'Settings'),
            _buildProfileOption(Icons.notifications, 'Notifications'),
            _buildProfileOption(Icons.help, 'Help & Support'),
            const Divider(height: AppDimensions.paddingXL),
            _buildProfileOption(
              Icons.logout,
              'Logout',
              textColor: AppColors.error,
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title,
      {Color? textColor, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? AppColors.textPrimary),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap ?? () {},
    );
  }
}
