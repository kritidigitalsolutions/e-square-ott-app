import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../models/explore_item_model.dart';

class ExploreController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentExploreIndex = 0.obs;

  final exploreList = <ExploreItemModel>[
    ExploreItemModel(
      id: 'e1',
      tag: 'TRAILER PREVIEW',
      title: 'The Last Promise',
      genre: 'Romance • Drama',
      description:
          'One secret. One promise. One story that changes everything. Watch the trailer before you decide where the story takes you.',
      image: AppImages.banner1,
    ),
    ExploreItemModel(
      id: 'e2',
      tag: 'TRAILER PREVIEW',
      title: 'If This Is LOVE Let Me Burn',
      genre: 'Romance • Thriller',
      description:
          'When passion collides with revenge, every breath becomes a dangerous game of love and survival.',
      image: AppImages.banner2,
    ),
    ExploreItemModel(
      id: 'e3',
      tag: 'TRAILER PREVIEW',
      title: 'The Billionaire Housewife',
      genre: 'Drama • Suspense',
      description:
          'Behind the luxurious mansion walls lies a hidden truth that could destroy two powerful families forever.',
      image: AppImages.banner3,
    ),
  ].obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentExploreIndex.value = index;
  }

  void toggleMyList(ExploreItemModel item) {
    item.isInMyList.value = !item.isInMyList.value;
    Get.snackbar(
      item.isInMyList.value ? 'Added to List' : 'Removed from List',
      '${item.title} has been ${item.isInMyList.value ? 'added to' : 'removed from'} your watchlist.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void watchNow(ExploreItemModel item) {
    Get.toNamed(Routes.dramaPlayer, arguments: item);
  }
}
