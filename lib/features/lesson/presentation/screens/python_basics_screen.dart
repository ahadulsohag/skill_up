import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';

class PythonBasicsScreen extends StatefulWidget {
  const PythonBasicsScreen({super.key});

  @override
  State<PythonBasicsScreen> createState() => _PythonBasicsScreenState();
}

class _PythonBasicsScreenState extends State<PythonBasicsScreen> {
  // State variables for interactive quiz elements
  int? _selectedAnswerIndex;
  bool _quizSubmitted = false;
  bool _codeExecuted = false;

  final List<String> _quizOptions = [
    'compile("Hello, SkillUp!")',
    'print("Hello, SkillUp!")',
    'echo("Hello, SkillUp!")',
    'system.out.print("Hello, SkillUp!")',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Rich Header with Slivers
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0,
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

              // Interactive Lesson Body Content
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingL,
                  AppDimensions.paddingL,
                  AppDimensions.paddingL,
                  100, // Bottom padding cushion for the static overlay button
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle(context, 'Introduction'),
                    const Text(
                      'Python is a high-level, general-purpose programming language. Its design philosophy emphasizes code readability with the use of significant indentation.',
                      style: TextStyle(
                        fontSize: AppDimensions.fontM,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    _buildSectionTitle(context, 'Key Features'),
                    _buildBulletPoint('Interpreted & interactive runtime'),
                    _buildBulletPoint(
                      'Clean syntax that reads closely to plain English',
                    ),
                    _buildBulletPoint(
                      'Dynamically typed variable declarations',
                    ),
                    _buildBulletPoint('Extensive standard libraries ecosystem'),
                    const SizedBox(height: AppDimensions.paddingL),

                    _buildSectionTitle(context, 'First Program Playground'),
                    const Text(
                      'Try running your first lines of real Python code using the simulation module below:',
                      style: TextStyle(fontSize: AppDimensions.fontM),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Interactive Code Console Panel
                    _buildCodePlayground(context, 'print("Hello, SkillUp!")'),
                    const SizedBox(height: AppDimensions.paddingXL),

                    _buildSectionTitle(context, 'Quick Knowledge Check'),
                    const Text(
                      'Which built-in Python function is utilized to output messages directly to your screen?',
                      style: TextStyle(
                        fontSize: AppDimensions.fontM,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Tappable Quiz Blocks
                    ...List.generate(
                      _quizOptions.length,
                      (index) => _buildQuizOption(index),
                    ),

                    if (_quizSubmitted) ...[
                      const SizedBox(height: AppDimensions.paddingM),
                      _buildQuizFeedbackBlock(),
                    ],
                  ]),
                ),
              ),
            ],
          ),

          // Persistent Floating Progress Bar Anchor
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _quizSubmitted && _codeExecuted
                  ? 1.0
                  : (_quizSubmitted || _codeExecuted ? 0.6 : 0.2),
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
              minHeight: 4,
            ),
          ),

          // Floating Lesson Complete Action Button Fixed to Screen Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(0),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: CustomButton(
                text: 'Complete Lesson',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder for Title Headers
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

  // Builder for Rich Checkmarks
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: AppDimensions.fontM),
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Code Sandbox Component
  Widget _buildCodePlayground(BuildContext context, String codeSnippet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[950],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Console Header Mac-Style Structure
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0
                            ? Colors.redAccent
                            : index == 1
                            ? Colors.amberAccent
                            : Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Text(
                  'main.py',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code block view
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Text(
              codeSnippet,
              style: const TextStyle(
                color: AppColors.secondary,
                fontFamily: 'monospace',
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Execute interactive trigger panel
          Divider(color: Colors.grey[900], height: 1),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => setState(() => _codeExecuted = true),
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.greenAccent,
                  ),
                  label: const Text(
                    'Run Code',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_codeExecuted) ...[
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _codeExecuted = false),
                  ),
                ],
              ],
            ),
          ),
          // Interactive Terminal Emulation Screen Console
          if (_codeExecuted)
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: Colors.grey[900]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terminal Output:',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hello, SkillUp!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: AppDimensions.fontM,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Quiz Option Selector Cards
  Widget _buildQuizOption(int index) {
    final isSelected = _selectedAnswerIndex == index;
    Color cardBorderColor = Colors.grey.withAlpha(40);
    Color cardBgColor = Theme.of(context).cardColor;

    if (isSelected) {
      cardBorderColor = AppColors.primary;
      cardBgColor = AppColors.primary.withAlpha(15);
    }
    if (_quizSubmitted) {
      if (index == 1) {
        // 1 is correct index
        cardBorderColor = Colors.green;
        cardBgColor = Colors.green.withAlpha(20);
      } else if (isSelected) {
        cardBorderColor = Colors.red;
        cardBgColor = Colors.red.withAlpha(20);
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Card(
        elevation: 0,
        color: cardBgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: cardBorderColor,
            width: isSelected || _quizSubmitted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _quizSubmitted
              ? null
              : () => setState(() => _selectedAnswerIndex = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingM,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _quizOptions[index],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: AppDimensions.fontM - 1,
                    ),
                  ),
                ),
                if (_quizSubmitted && index == 1)
                  const Icon(Icons.check_circle, color: Colors.green)
                else if (_quizSubmitted && isSelected && index != 1)
                  const Icon(Icons.cancel, color: Colors.red)
                else
                  Radio<int>(
                    value: index,
                    groupValue: _selectedAnswerIndex,
                    activeColor: AppColors.primary,
                    onChanged: _quizSubmitted
                        ? null
                        : (val) => setState(() => _selectedAnswerIndex = val),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Conditional feedback block validation
  Widget _buildQuizFeedbackBlock() {
    final isCorrect = _selectedAnswerIndex == 1;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withAlpha(25)
            : Colors.red.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle_rounded
                : Icons.error_outline_rounded,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Awesome job! print() outputs raw strings to the system console terminal.'
                  : 'Not quite. Remember that Python keeps syntax simple with lowercase functions!',
              style: TextStyle(
                color: isCorrect ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!isCorrect)
            TextButton(
              onPressed: () => setState(() {
                _quizSubmitted = false;
                _selectedAnswerIndex = null;
              }),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  // Trigger quiz validation logic cleanly inside widget frame lifecycle tracking
  @override
  void didUpdateWidget(covariant PythonBasicsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedAnswerIndex != null && !_quizSubmitted) {
      setState(() => _quizSubmitted = true);
    }
  }
}
