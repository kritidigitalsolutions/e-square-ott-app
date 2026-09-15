import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_text_styles.dart';
import '../../controller/home_controller.dart';

class CustomBottomAppBar extends GetView<HomeController> {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      height: 62 + (bottomInset > 0 ? bottomInset * 0.6 : 0),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A10).withValues(alpha: 0.94),
              border: const Border(
                top: BorderSide(color: Color(0x1FFFFFFF), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              bottom: bottomInset > 0 ? bottomInset * 0.4 : 2,
            ),
            child: Obx(() {
              final activeIndex = controller.currentNavIndex.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    label: 'Home'.tr,
                    activeIcon: FontAwesomeIcons.house,
                    inactiveIcon: FontAwesomeIcons.house,
                    activeIndex: activeIndex,
                  ),
                  _buildNavItem(
                    index: 1,
                    label: 'Explore'.tr,
                    activeIcon: FontAwesomeIcons.solidCompass,
                    inactiveIcon: FontAwesomeIcons.compass,
                    activeIndex: activeIndex,
                  ),
                  _buildNavItem(
                    index: 2,
                    label: 'Profile'.tr,
                    activeIcon: FontAwesomeIcons.solidUser,
                    inactiveIcon: FontAwesomeIcons.user,
                    activeIndex: activeIndex,
                  ),
                  _buildNavItem(
                    index: 3,
                    label: 'Search'.tr,
                    activeIcon: FontAwesomeIcons.magnifyingGlass,
                    inactiveIcon: FontAwesomeIcons.magnifyingGlass,
                    activeIndex: activeIndex,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required FaIconData activeIcon,
    required FaIconData inactiveIcon,
    required int activeIndex,
  }) {
    final isSelected = activeIndex == index;

    return Expanded(
      child: _NavItemButton(
        index: index,
        label: label,
        icon: isSelected ? activeIcon : inactiveIcon,
        isSelected: isSelected,
        onTap: () {
          HapticFeedback.lightImpact();
          controller.changeNavIndex(index);
        },
      ),
    );
  }
}

class _NavItemButton extends StatefulWidget {
  final int index;
  final String label;
  final FaIconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemButton({
    required this.index,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItemButton> createState() => _NavItemButtonState();
}

class _NavItemButtonState extends State<_NavItemButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      // onTapCancel: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Top Active Glow Indicator Bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isSelected ? 28 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE50914)
                    : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(3),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFE50914).withValues(alpha: 0.8),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            ),

            // ── Center Icon + Label
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    widget.icon,
                    color: isSelected
                        ? const Color(0xFFE50914)
                        : const Color(0xFF7E7E92),
                    size: isSelected ? 20 : 18.5,
                  ),
                  const SizedBox(height: 3),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF7E7E92),
                      letterSpacing: isSelected ? 0.2 : 0.0,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 1),
          ],
        ),
      ),
    );
  }
}

// Alias for backward compatibility
typedef CustomBottomNavBar = CustomBottomAppBar;
