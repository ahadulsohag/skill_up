import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_button.dart';
import '../../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 8) {
      return AppStrings.passwordLength;
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      // Navigate to home screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.paddingL),

                  // Header
                  Text(
                    AppStrings.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    AppStrings.appTagline,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: AppDimensions.paddingXL * 1.5),

                  // Email Field
                  AuthTextField(
                    label: AppStrings.emailAddress,
                    hint: AppStrings.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Password Field
                  AuthTextField(
                    label: AppStrings.password,
                    hint: AppStrings.passwordHint,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: _validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textLight,
                      ),
                      onPressed: () {
                        setState(() => _isPasswordVisible = !_isPasswordVisible);
                      },
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingXL),

                  // Login Button
                  CustomButton(
                    text: AppStrings.login,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                        ),
                        child: Text(
                          AppStrings.orContinueWith,
                          style: TextStyle(
                            fontSize: AppDimensions.fontXS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialButton(
                        icon: Icons.g_mobiledata,
                        label: AppStrings.google,
                        onPressed: () {
                          // Handle Google Sign In
                        },
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      SocialButton(
                        icon: Icons.apple,
                        label: AppStrings.apple,
                        onPressed: () {
                          // Handle Apple Sign In
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.paddingXL),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontS,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          AppStrings.signUp,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.fontS,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
