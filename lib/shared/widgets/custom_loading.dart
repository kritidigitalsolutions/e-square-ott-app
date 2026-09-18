import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final String? message;
  final Color? messageColor;
  final Color? color;
  final Color? waveColor;
  final Color? trackColor;

  const LoadingWidget({
    super.key,
    this.size = 50,
    this.message,
    this.messageColor,
    this.color,
    this.waveColor,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    if (size <= 32) {
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? const Color(0xFF0C0B10),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitWaveSpinner(
            color: activeColor,
            waveColor: waveColor ?? activeColor.withValues(alpha: 0.5),
            trackColor: trackColor ?? activeColor.withValues(alpha: 0.2),
            size: size,
          ),
          if (message != null) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: messageColor ?? Colors.white70,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full screen overlay loading (dialog jaisa use ke liye)
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final Color backgroundColor;

  const LoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: backgroundColor,
          child: LoadingWidget(
            message: message,
            messageColor: Colors.white,
            size: 60,
          ),
        ),
      ),
    );
  }
}
