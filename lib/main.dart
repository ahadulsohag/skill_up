import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_up/core/providers/auth_provider.dart';
import 'package:skill_up/core/services/supabase_service.dart';
import 'package:skill_up/core/theme/app_theme.dart';
import 'package:skill_up/features/auth/presentation/screens/login_screen.dart';
import 'package:skill_up/features/auth/presentation/screens/register_screen.dart';
import 'package:skill_up/features/home/presentation/screens/home_screen.dart';
import 'package:skill_up/features/main/presentation/screens/main_screen.dart';
import 'package:skill_up/routes/app_routes.dart';
import 'core/providers/course_provider.dart';

void main() async {
  // 1. Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize your Supabase connection
  await SupabaseService().init();

  // 3. Run the app, wrapping it in MultiProvider so your app can access states
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

// Your existing MyApp class remains exactly as you had it
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillUp',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.main: (context) => const MainScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      },
    );
  }
}
