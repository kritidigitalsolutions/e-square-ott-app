import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppAnimations {
  AppAnimations._();

  static const String _animationPath = 'assets/animations';

  static const String loading = "$_animationPath/loading.json";
}

class LoadingWidget extends StatelessWidget {
  final double size;
  final String? message;
  final Color? messageColor;

  const LoadingWidget({
    super.key,
    this.size = 120,
    this.message,
    this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Lottie.asset(
              AppAnimations.loading,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: messageColor ?? Colors.grey[600],
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
    this.backgroundColor = Colors.black45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: LoadingWidget(message: message, messageColor: Colors.white),
    );
  }
}
