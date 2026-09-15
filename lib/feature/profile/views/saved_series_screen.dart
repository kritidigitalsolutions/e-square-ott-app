import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SavedSeriesModel {
  final String posterAsset; // path/URL to poster image
  final String title;
  final String category;
  final int episodes;

  const SavedSeriesModel({
    required this.posterAsset,
    required this.title,
    required this.category,
    required this.episodes,
  });
}

class SavedSeriesScreen extends StatelessWidget {
  const SavedSeriesScreen({super.key});

  static const List<SavedSeriesModel> _series = [
    SavedSeriesModel(
      posterAsset: 'assets/posters/mafia_romance.jpg',
      title: 'Mafia Romance',
      category: 'Romance',
      episodes: 12,
    ),
    SavedSeriesModel(
      posterAsset: 'assets/posters/divorce_to_billionaire.jpg',
      title: 'From Divorce to\nBillionaire Bride',
      category: 'Romance',
      episodes: 12,
    ),
    SavedSeriesModel(
      posterAsset: 'assets/posters/makkar_ceo_wife.jpg',
      title: 'Makkar CEO Wife',
      category: 'Romance',
      episodes: 12,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(
                        onTap: () {
                          Get.back();
                        },
                      ),
                      SizedBox(width: 14),
                      Text("Saved Series", style: AppTextStyles.text18Bold),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _series.length,
                      separatorBuilder: (_, __) => Divider(
                        color: AppColors.white.withValues(alpha: 0.1),
                      ),
                      itemBuilder: (context, index) {
                        return _SavedSeriesTile(item: _series[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedSeriesTile extends StatelessWidget {
  final SavedSeriesModel item;
  const _SavedSeriesTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Poster thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            item.posterAsset,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: AppColors.primary,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.image,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Title + subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.category} · ${item.episodes} Episodes',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Watch button
        _WatchButton(onTap: () {}),
      ],
    );
  }
}

class _WatchButton extends StatelessWidget {
  final VoidCallback onTap;
  const _WatchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.play, color: Colors.white, size: 12),
            SizedBox(width: 6),
            Text(
              'Watch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
