import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/auth_controller.dart';

class GenreItem {
  const GenreItem({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}

class ChooseInterestScreen extends GetView<AuthController> {
  const ChooseInterestScreen({super.key});

  static const List<GenreItem> _genres = [
    GenreItem(
      id: 'Romance',
      name: 'Romance',
      icon: Icons.favorite_border_rounded,
    ),
    GenreItem(
      id: 'Thriller',
      name: 'Thriller',
      icon: Icons.flash_on_rounded,
    ),
    GenreItem(
      id: 'Drama',
      name: 'Drama',
      icon: Icons.theater_comedy_rounded,
    ),
    GenreItem(
      id: 'Mystery',
      name: 'Mystery',
      icon: Icons.person_search_rounded,
    ),
    GenreItem(
      id: 'Action',
      name: 'Action',
      icon: Icons.directions_run_rounded,
    ),
    GenreItem(
      id: 'Horror',
      name: 'Horror',
      icon: Icons.sentiment_very_dissatisfied_rounded,
    ),
    GenreItem(
      id: 'comedy',
      name: 'comedy',
      icon: Icons.sentiment_very_satisfied_rounded,
    ),
    GenreItem(
      id: 'Fantasy',
      name: 'Fantasy',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // ── Background image
            Positioned.fill(
              child: Image.asset(
                AppImages.bg,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => const SizedBox.shrink(),
              ),
            ),

            // ── Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x99010101), Color(0xF5161616)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.6],
                  ),
                ),
              ),
            ),

            // ── Fixed Top-Left Back Button
            Positioned(
              left: AppSizes.p20,
              top: MediaQuery.of(context).padding.top + 16,
              child: CustomBackButton(onTap: () => Get.back()),
            ),

            // ── Content Area
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p24,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top space below back button
                              const SizedBox(height: 54),

                              // Heading
                              Text(
                                'Choose your\nInterest',
                                style: AppTextStyles.text28Bold.copyWith(
                                  letterSpacing: -0.5,
                                  height: 1.25,
                                ),
                              ),
                              AppSizes.vGap8,

                              // Subtitle
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Pick a few genres you love. We'll use them to\npersonalize your Entertainment",
                                      style: AppTextStyles.text13.copyWith(
                                        color: const Color(0xFF8A8A8A),
                                        height: 1.4,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '²',
                                      style:
                                          AppTextStyles.text13Bold.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' experience.',
                                      style: AppTextStyles.text13.copyWith(
                                        color: const Color(0xFF8A8A8A),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Genre Selection Grid (Row + Expanded for flawless IntrinsicHeight layout)
                              Column(
                                children: [
                                  for (int i = 0; i < _genres.length; i += 2) ...[
                                    if (i > 0) const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Obx(() {
                                            final isSelected = controller
                                                .selectedGenres
                                                .contains(_genres[i].id);
                                            return _GenreCard(
                                              genre: _genres[i],
                                              isSelected: isSelected,
                                              onTap: () => controller
                                                  .toggleGenre(_genres[i].id),
                                            );
                                          }),
                                        ),
                                        const SizedBox(width: 12),
                                        if (i + 1 < _genres.length)
                                          Expanded(
                                            child: Obx(() {
                                              final isSelected = controller
                                                  .selectedGenres
                                                  .contains(_genres[i + 1].id);
                                              return _GenreCard(
                                                genre: _genres[i + 1],
                                                isSelected: isSelected,
                                                onTap: () => controller
                                                    .toggleGenre(_genres[i + 1].id),
                                              );
                                            }),
                                          )
                                        else
                                          const Expanded(child: SizedBox.shrink()),
                                      ],
                                    ),
                                  ],
                                ],
                              ),

                              const Spacer(),
                              const SizedBox(height: 24),

                              // ── Continue Button
                              Obx(() {
                                final hasSelection =
                                    controller.selectedGenres.isNotEmpty;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  height: AppSizes.buttonHeight,
                                  decoration: BoxDecoration(
                                    color: hasSelection
                                        ? AppColors.primary
                                        : const Color(0xFF1C1C1C),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: hasSelection
                                          ? AppColors.primary
                                          : const Color(0xFF2E2E2E),
                                      width: 1,
                                    ),
                                    boxShadow: hasSelection
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: hasSelection
                                          ? controller.completeOnboarding
                                          : null,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      child: Center(
                                        child: Text(
                                          'Continue',
                                          style: AppTextStyles.text16SemiBold
                                              .copyWith(
                                            color: hasSelection
                                                ? Colors.white
                                                : const Color(0xFF6E6E6E),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),

                              // ── Skip for Now
                              Center(
                                child: GestureDetector(
                                  onTap: controller.completeOnboarding,
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'Skip for Now',
                                      style:
                                          AppTextStyles.text14Medium.copyWith(
                                        color: const Color(0xFF8A8A8A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Genre Selection Card matching design screenshot
class _GenreCard extends StatelessWidget {
  const _GenreCard({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  final GenreItem genre;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF140505)
              : const Color(0xFF202020).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF2E2E2E),
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            // Icon & Label
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  genre.icon,
                  size: 26,
                  color: isSelected ? Colors.white : const Color(0xFF8A8A8A),
                ),
                Text(
                  genre.name,
                  style: AppTextStyles.text14Medium.copyWith(
                    color: isSelected ? Colors.white : const Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),

            // Top-right Red Checkmark Badge when Selected
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
