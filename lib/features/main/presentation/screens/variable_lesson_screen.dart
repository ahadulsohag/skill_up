import 'package:flutter/material.dart';
import 'package:skill_up/core/services/supabase_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';

class VariablesLessonScreen extends StatefulWidget {
  const VariablesLessonScreen({super.key});

  @override
  State<VariablesLessonScreen> createState() => _VariablesLessonScreenState();
}

class _VariablesLessonScreenState extends State<VariablesLessonScreen> {
  bool _showCodeOutput = false;
  bool _isAlreadyCompleted = false;
  bool _isSavingProgress = false;
  
  final _supabaseClient = SupabaseService().client;
  final TextEditingController _codeController = TextEditingController(
    text:
        '# Assigning values to variables\nuser_name = "Alex"\nuser_age = 24\nis_enrolled = True\n\n# Printing the values\nprint(user_name)\nprint(user_age)',
  );

  @override
  void initState() {
    super.initState();
    _checkLessonCompletionStatus();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Verify backend synchronization state
  Future<void> _checkLessonCompletionStatus() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return;

    try {
      final matchingRecord = await _supabaseClient
          .from('user_progress')
          .select()
          .eq('user_id', user.id)
          .eq('lesson_id', 'python_variables_lesson')
          .maybeSingle();

      if (matchingRecord != null) {
        setState(() {
          _isAlreadyCompleted = true;
        });
      }
    } catch (e) {
      debugPrint('Error verifying progression matrix logs: $e');
    }
  }

  // Push updates and credit user profiles with experience rewards
  Future<void> _completeAndSyncLesson() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return;

    setState(() => _isSavingProgress = true);

    try {
      if (!_isAlreadyCompleted) {
        // 1. Add complete milestone entry
        await _supabaseClient.from('user_progress').insert({
          'user_id': user.id,
          'lesson_id': 'python_variables_lesson',
        });

        // 2. Fetch active XP to modify profile securely
        final userProfile = await _supabaseClient
            .from('profiles')
            .select('xp')
            .eq('id', user.id)
            .maybeSingle();

        int currentXp = 0;
        if (userProfile != null) {
          currentXp = userProfile['xp'] ?? 0;
        }

        // 3. Upsert incremented score (+50 XP for completing a lesson)
        await _supabaseClient.from('profiles').upsert({
          'id': user.id,
          'xp': currentXp + 50,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Progress saved and synced to cloud!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error saving progress: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingProgress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Variables in Python'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  _isAlreadyCompleted ? Icons.check_circle : Icons.radio_button_unchecked, 
                  size: 16, 
                  color: AppColors.primary
                ),
                const SizedBox(width: 4),
                Text(
                  _isAlreadyCompleted ? '100%' : '65%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: _isAlreadyCompleted ? 1.0 : 0.65,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Variables in Python',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExplanationCard(
                    'Think of a variable as a labeled container. In Python, you use these containers to store data values that your program can use and change later.',
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  const Text(
                    'Creating Variables',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Python has no command for declaring a variable. A variable is created the moment you first assign a value to it. Unlike other languages, you don\'t need to specify the type.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  const Text(
                    'Example',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCodeBlock(
                    '# Assigning values to variables\nuser_name = "Alex"\nuser_age = 24\nis_enrolled = True\n\n# Printing the values\nprint(user_name)\nprint(user_age)',
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  CustomButton(
                    text: 'Run Code',
                    onPressed: () {
                      setState(() {
                        _showCodeOutput = true;
                      });
                    },
                    backgroundColor: AppColors.primary.withAlpha(20),
                    textColor: AppColors.primary,
                    prefix: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  if (_showCodeOutput) ...[
                    const SizedBox(height: AppDimensions.paddingM),
                    _buildOutputBlock('Alex\n24'),
                  ],
                  const SizedBox(height: AppDimensions.paddingL),
                  const Text(
                    'Naming Rules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('Names must start with a letter or underscore'),
                  _buildBulletPoint('Variable names are case-sensitive (age is not Age)'),
                  _buildBulletPoint('Can only contain letters, numbers, and underscores'),
                  _buildBulletPoint('Cannot use Python keywords (if, else, while, etc.)'),
                  const SizedBox(height: AppDimensions.paddingL),
                  const Text(
                    'Dynamic Typing',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Variables can change type after they are assigned. Python automatically determines the data type based on the value you assign.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildCodeBlock(
                    'x = 10        # x is an integer\nx = "Hello"   # now x is a string\nx = True      # now x is a boolean',
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _buildQuizSection(),
                  const SizedBox(height: AppDimensions.paddingXL),
                  const SizedBox(height: AppDimensions.paddingL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOutputBlock(String output) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Output:',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            output,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz_rounded, color: Colors.amber[700], size: 24),
              const SizedBox(width: 12),
              const Text(
                'Quick Check',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Which of the following is a valid variable name in Python?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildQuizOption('1var_name', false),
          _buildQuizOption('_myVariable', true),
          _buildQuizOption('my-var', false),
          _buildQuizOption('class', false),
        ],
      ),
    );
  }

  Widget _buildQuizOption(String text, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: null,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isCorrect ? '✓ Correct! Great job!' : '✗ Try again!',
                  ),
                  backgroundColor: isCorrect ? Colors.green : Colors.red,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}