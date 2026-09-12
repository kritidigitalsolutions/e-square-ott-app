import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
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

            // ── Main Tab Views
            Obx(() {
              switch (controller.currentNavIndex.value) {
                case 0:
                  return const SafeArea(
                    bottom: false,
                    child: HomeTabView(),
                  );
                case 1:
                  return const ExploreTabView();
                case 2:
                  return const SafeArea(
                    bottom: false,
                    child: ProfileTabView(),
                  );
                case 3:
                  return const SafeArea(
                    bottom: false,
                    child: SearchTabView(),
                  );
                default:
                  return const SafeArea(
                    bottom: false,
                    child: HomeTabView(),
                  );
              }
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
    );
  }
}
