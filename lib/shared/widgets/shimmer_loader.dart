import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const CustomShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFF1A1A26),
      highlightColor: highlightColor ?? const Color(0xFF2C2C3E),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
    );
  }
}

/// Shimmer placeholder specifically for the Profile user card
class ProfileUserCardShimmer extends StatelessWidget {
  const ProfileUserCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: CustomShimmer(
        child: Row(
          children: [
            // Avatar shimmer circle
            const ShimmerBox(
              width: 58,
              height: 58,
              shape: BoxShape.circle,
            ),
            const SizedBox(width: 14),

            // Name & details shimmer lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  ShimmerBox(
                    width: 140,
                    height: 18,
                    borderRadius: 6,
                  ),
                  SizedBox(height: 8),
                  ShimmerBox(
                    width: 180,
                    height: 13,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // VIP / Action badge shimmer
            const ShimmerBox(
              width: 50,
              height: 28,
              borderRadius: 14,
            ),
            const SizedBox(width: 8),
            const ShimmerBox(
              width: 36,
              height: 36,
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
