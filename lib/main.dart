import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services & Providers
import 'package:skill_up/core/services/supabase_service.dart';
import 'package:skill_up/core/providers/auth_provider.dart';
import 'package:skill_up/core/providers/course_provider.dart';
import 'package:skill_up/core/theme/app_theme.dart';
import 'package:skill_up/features/main/presentation/screens/admin_dashboard_screen.dart';
import 'package:skill_up/routes/app_routes.dart';

// Screens
import 'package:skill_up/features/auth/presentation/screens/login_screen.dart';
import 'package:skill_up/features/auth/presentation/screens/register_screen.dart';
import 'package:skill_up/features/home/presentation/screens/home_screen.dart';
import 'package:skill_up/features/main/presentation/screens/main_screen.dart';
// IMPORT THIS:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillUp',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoggedIn) {
            return FutureBuilder<Widget>(
              future: _getInitialScreen(authProvider),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return snapshot.data ?? const LoginScreen();
              },
            );
          }
          return const LoginScreen();
        },
      ),

      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.main: (context) => const MainScreen(),
        '/admin-dashboard': (context) =>
            const AdminDashboardScreen(), // ADD THIS
      },

      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<Widget> _getInitialScreen(AuthProvider authProvider) async {
    final user = authProvider.currentUser;
    if (user != null) {
      final role = await authProvider.fetchUserRole(user.id);
      return (role == 'admin')
          ? const AdminDashboardScreen()
          : const MainScreen();
    }
    return const LoginScreen();
  }
}
