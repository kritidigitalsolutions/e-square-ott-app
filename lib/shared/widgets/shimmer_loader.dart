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

/// Shimmer loader matching Home Screen layout
class HomeFeedShimmer extends StatelessWidget {
  const HomeFeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Carousel Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: 80, height: 22, borderRadius: 6),
                    const SizedBox(height: 10),
                    const ShimmerBox(width: 220, height: 26, borderRadius: 6),
                    const SizedBox(height: 8),
                    const ShimmerBox(width: 160, height: 14, borderRadius: 4),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(
                          child: ShimmerBox(height: 38, borderRadius: 10),
                        ),
                        SizedBox(width: 10),
                        ShimmerBox(width: 38, height: 38, borderRadius: 10),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Section 1 (Trending)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ShimmerBox(width: 120, height: 20, borderRadius: 4),
                  ShimmerBox(width: 50, height: 16, borderRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => const ShimmerBox(
                  width: 110,
                  height: 170,
                  borderRadius: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Section 2 (Recommended)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ShimmerBox(width: 140, height: 20, borderRadius: 4),
                  ShimmerBox(width: 50, height: 16, borderRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => const ShimmerBox(
                  width: 110,
                  height: 170,
                  borderRadius: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loader matching Explore Reel Screen
class ExploreReelShimmer extends StatelessWidget {
  const ExploreReelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomShimmer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop area
            Container(color: const Color(0xFF14141E)),

            // Right floating actions
            Positioned(
              right: 16,
              bottom: 110,
              child: Column(
                children: const [
                  ShimmerBox(width: 44, height: 44, shape: BoxShape.circle),
                  SizedBox(height: 18),
                  ShimmerBox(width: 44, height: 44, shape: BoxShape.circle),
                  SizedBox(height: 18),
                  ShimmerBox(width: 44, height: 44, shape: BoxShape.circle),
                ],
              ),
            ),

            // Bottom info
            Positioned(
              left: 18,
              right: 80,
              bottom: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  ShimmerBox(width: 110, height: 18, borderRadius: 4),
                  SizedBox(height: 10),
                  ShimmerBox(width: 220, height: 26, borderRadius: 6),
                  SizedBox(height: 8),
                  ShimmerBox(width: 160, height: 14, borderRadius: 4),
                  SizedBox(height: 16),
                  ShimmerBox(width: 130, height: 40, borderRadius: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loader matching Drama Player / Episode View
class DramaPlayerShimmer extends StatelessWidget {
  const DramaPlayerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomShimmer(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top navigation shimmer
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerBox(width: 40, height: 40, shape: BoxShape.circle),
                    ShimmerBox(width: 90, height: 32, borderRadius: 20),
                    ShimmerBox(width: 40, height: 40, shape: BoxShape.circle),
                  ],
                ),
              ),

              // Center play icon shimmer
              const ShimmerBox(width: 60, height: 60, shape: BoxShape.circle),

              // Bottom controls shimmer
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    ShimmerBox(width: 80, height: 28, borderRadius: 8),
                    SizedBox(height: 12),
                    ShimmerBox(width: 240, height: 24, borderRadius: 6),
                    SizedBox(height: 8),
                    ShimmerBox(
                        width: double.infinity, height: 14, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerBox(width: 180, height: 14, borderRadius: 4),
                    SizedBox(height: 14),
                    ShimmerBox(
                        width: double.infinity, height: 4, borderRadius: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
