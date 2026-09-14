import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_dialog.dart';
import '../../explore/views/explore_tab_view.dart';
import '../../profile/views/profile_tab_view.dart';
import '../controller/home_controller.dart';
import 'home_tab_view.dart';
import 'search_tab_view.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If on Explore (1), Profile (2), or Search (3) tab → Go directly back to Home (0)
        if (controller.currentNavIndex.value != 0) {
          controller.currentNavIndex.value = 0;
        } else {
          // If on Home tab (0) → Show custom animated exit dialog
          CustomDialog.showExitDialog(context);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: const Color(0xFF0D0D12),
          body: Stack(
          children: [
            // ── Background ambient gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E0A0C),
                      Color(0xFF0D0D12),
                      Color(0xFF0A0A0F),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),

            // ── Main Tab Views with CustomAnimation
            Obx(() {
              final index = controller.currentNavIndex.value;
              Widget currentTab;
              switch (index) {
                case 0:
                  currentTab = const SafeArea(
                    bottom: false,
                    child: HomeTabView(),
                  );
                  break;
                case 1:
                  currentTab = const ExploreTabView();
                  break;
                case 2:
                  currentTab = const SafeArea(
                    bottom: false,
                    child: ProfileTabView(),
                  );
                  break;
                case 3:
                  currentTab = const SafeArea(
                    bottom: false,
                    child: SearchTabView(),
                  );
                  break;
                default:
                  currentTab = const SafeArea(
                    bottom: false,
                    child: HomeTabView(),
                  );
              }

              return CustomAnimation.fadeThrough(
                child: KeyedSubtree(
                  key: ValueKey<int>(index),
                  child: currentTab,
                ),
              );
            }),

            // ── Floating Bottom Navigation Bar
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
