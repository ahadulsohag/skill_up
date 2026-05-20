import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Simple layout states for the switches
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 20),
            onPressed: () {
              // Handle edit profile page route logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            // Hero Profile Header Card Layout
            const CircleAvatar(
              radius: 54,
              backgroundColor: AppColors.primary,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_rounded,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            const Text(
              'Sohag',
              style: TextStyle(
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'sohag.223071151@smuct.ac.bd',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: AppDimensions.fontM - 2,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Achievement Rank Tracker Module
            _buildTierProgressCard(),
            const SizedBox(height: AppDimensions.paddingXL),

            // Achievement Badges Section Header
            _buildSectionHeader('Earned Achievements'),
            const SizedBox(height: AppDimensions.paddingM),
            _buildBadgesRow(),
            const SizedBox(height: AppDimensions.paddingXL),

            // General Settings Card Block
            _buildSectionHeader('Preferences'),
            const SizedBox(height: AppDimensions.paddingM),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  _buildToggleOption(
                    Icons.dark_mode_rounded,
                    'Dark Interface Mode',
                    _isDarkMode,
                    (value) => setState(() => _isDarkMode = value),
                  ),
                  _buildToggleOption(
                    Icons.notifications_active_rounded,
                    'Push Notifications',
                    _notificationsEnabled,
                    (value) => setState(() => _notificationsEnabled = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),

            // Account Actions Card Block
            _buildSectionHeader('Account Support'),
            const SizedBox(height: AppDimensions.paddingM),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  _buildProfileOption(Icons.settings_rounded, 'App Settings'),
                  _buildProfileOption(
                    Icons.help_outline_rounded,
                    'Help & Support Center',
                  ),
                  _buildProfileOption(
                    Icons.verified_user_rounded,
                    'Privacy Policy Agreement',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildProfileOption(
                    Icons.logout_rounded,
                    'Sign Out Account',
                    textColor: AppColors.error,
                    showChevron: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row header builder
  Widget _buildSectionHeader(String heading) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        heading,
        style: const TextStyle(
          fontSize: AppDimensions.fontM,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // Dashboard Rank & Progress Meter Component
  Widget _buildTierProgressCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                  SizedBox(width: AppDimensions.paddingS),
                  Text(
                    'Level 4 Pro Learner',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontM,
                    ),
                  ),
                ],
              ),
              const Text(
                '1,450 XP',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: AppDimensions.fontM - 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Earn 250 XP more to advance to Senior Class!',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal Badges Scroller Component
  Widget _buildBadgesRow() {
    final List<Map<String, dynamic>> badges = [
      {
        'icon': Icons.bolt_rounded,
        'color': Colors.amber,
        'label': 'Fast Track',
      },
      {
        'icon': Icons.terminal_rounded,
        'color': Colors.blueAccent,
        'label': 'Code Wizard',
      },
      {
        'icon': Icons.workspace_premium_rounded,
        'color': Colors.purpleAccent,
        'label': 'Completed 5',
      },
      {
        'icon': Icons.local_fire_department_rounded,
        'color': Colors.orangeAccent,
        'label': '7 Day Streak',
      },
    ];

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return Container(
            margin: const EdgeInsets.only(right: AppDimensions.paddingM),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Colors.grey.withAlpha(20)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: (badge['color'] as Color).withAlpha(30),
                  child: Icon(
                    badge['icon'] as IconData,
                    color: badge['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge['label'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Clean Navigation ListTile Options Builder
  Widget _buildProfileOption(
    IconData icon,
    String title, {
    Color? textColor,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: AppDimensions.fontM - 1,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showChevron
          ? const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Colors.grey,
            )
          : null,
      onTap: onTap ?? () {},
    );
  }

  // Tappable Toggle Switch Line Builder
  Widget _buildToggleOption(
    IconData icon,
    String title,
    bool currentValue,
    ValueChanged<bool> onToggle,
  ) {
    return SwitchListTile.adaptive(
      secondary: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppDimensions.fontM - 1,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      activeColor: AppColors.primary,
      value: currentValue,
      onChanged: onToggle,
    );
  }
}
