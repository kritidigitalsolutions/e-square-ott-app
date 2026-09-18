import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import 'custom_loading.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width = double.infinity,
    this.height = AppSizes.buttonHeight,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.borderRadius = 14.0,
    this.textStyle,
    this.icon,
    this.gradient,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final bool canPress = isEnabled && !isLoading;
    final isPrimary = backgroundColor == AppColors.primary;
    final effectiveGradient =
        gradient ?? (isPrimary && canPress ? AppColors.primaryGradient : null);
    final effectiveTextColor = isPrimary && canPress
        ? (textColor == Colors.white ? const Color(0xFF0C0B10) : textColor)
        : (canPress ? textColor : textColor.withValues(alpha: 0.6));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveGradient == null
            ? (canPress
                ? backgroundColor
                : backgroundColor.withValues(alpha: 0.4))
            : null,
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: canPress && isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canPress ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.black.withValues(alpha: 0.15),
          highlightColor: Colors.black.withValues(alpha: 0.08),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: LoadingWidget(size: 30),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: (textStyle ?? AppTextStyles.text16SemiBold)
                              .copyWith(
                                color: effectiveTextColor,
                                fontWeight: isPrimary && canPress
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF14141E).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  }
}
