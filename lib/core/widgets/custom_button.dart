import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? Colors.white,
        minimumSize: Size(
          double.infinity,
          height ?? AppDimensions.buttonHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefix != null) ...[
                  prefix!,
                  const SizedBox(width: AppDimensions.paddingS),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: AppDimensions.paddingS),
                  suffix!,
                ],
              ],
            ),
    );
  }
}
