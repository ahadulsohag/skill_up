import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_up/core/providers/auth_provider.dart';
import 'package:skill_up/routes/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              if (context.mounted) {
                // Use pushNamedAndRemoveUntil to clear the entire navigation stack
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            const Text(
              'Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // --- Stats Grid Section ---
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Let SingleChildScrollView handle scrolling
              children: [
                _buildStatCard(
                  'Total Users',
                  '1,248',
                  Icons.people,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Active Courses',
                  '34',
                  Icons.book,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Completed Lessons',
                  '8,902',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatCard(
                  'Pending Reports',
                  '5',
                  Icons.warning_amber_rounded,
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Quick Actions Section ---
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to Course Management
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Course'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to User Management
                    },
                    icon: const Icon(Icons.manage_accounts),
                    label: const Text('Manage Users'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Recent Activity Section ---
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                // Mock data for display purposes
                final activities = [
                  'John Doe registered a new account.',
                  'Jane Smith completed "Python Basics".',
                  'New course "Advanced Flutter" was published.',
                  'System backup completed successfully.',
                  'Mark signed up as an Instructor.',
                ];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.history, color: Colors.white, size: 20),
                  ),
                  title: Text(activities[index]),
                  subtitle: Text('${index + 1} hours ago'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build consistent statistical cards
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
