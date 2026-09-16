import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// ============================================================
/// CustomScaffold — App-wide reusable scaffold
/// ============================================================
/// Combines:
///  • Consistent flat background color (customizable)
///  • Full AppBar support (title, actions, leading, elevation, etc.)
///  • Staggered fade + slide-up entrance animation for the body
///
/// Use this instead of Scaffold on every screen (Login, Create
/// Account, Verify, Choose Plan, etc.) so look & feel + entrance
/// animation stay consistent without repeating boilerplate.
///
/// ------------------------------------------------------------
/// Basic usage:
/// ------------------------------------------------------------
/// CustomScaffold(
///   appBarTitle: "Choose Plan",
///   body: SafeArea(child: YourScreenContent()),
/// )
///
/// ------------------------------------------------------------
/// With custom appbar + background + FAB:
/// ------------------------------------------------------------
/// CustomScaffold(
///   appBarTitle: "Wallet",
///   actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
///   leading: BackButton(),
///   centerTitle: false,
///   backgroundColor: const Color(0xFF16181F),
///   floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
///   body: YourScreenContent(),
/// )
///
/// ------------------------------------------------------------
/// Without AppBar (e.g. Login screen):
/// ------------------------------------------------------------
/// CustomScaffold(
///   showAppBar: false,
///   body: YourScreenContent(),
/// )
/// ============================================================

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,

    // ---------- Background ----------
    this.backgroundColor = AppColors.scaffoldBackground,

    // ---------- AppBar ----------
    this.showAppBar = true,
    this.appBarTitle,
    this.titleWidget,
    this.titleStyle,
    this.centerTitle = false,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.appBarBackgroundColor = Colors.transparent,
    this.appBarElevation = 0,
    this.appBarIconColor,
    this.systemOverlayStyle,
    this.bottom,
    this.extendBodyBehindAppBar = false,

    // ---------- Scaffold extras ----------
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset = true,
    this.safeArea = true,

    // ---------- Animation ----------
    this.animationDuration = const Duration(milliseconds: 600),
    this.verticalOffset = 50.0,
    this.animate = true,
  });

  /// Main screen content — required
  final Widget body;

  // ---------- Background ----------
  final Color? backgroundColor;

  // ---------- AppBar ----------
  final bool showAppBar;
  final String? appBarTitle;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color appBarBackgroundColor;
  final double appBarElevation;
  final Color? appBarIconColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final PreferredSizeWidget? bottom;
  final bool extendBodyBehindAppBar;

  // ---------- Scaffold extras ----------
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool resizeToAvoidBottomInset;
  final bool safeArea;

  // ---------- Animation ----------
  final Duration animationDuration;
  final double verticalOffset;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Widget content = safeArea ? SafeArea(child: body) : body;

    if (animate) {
      content = AnimationLimiter(
        child: AnimationConfiguration.synchronized(
          duration: animationDuration,
          child: SlideAnimation(
            verticalOffset: verticalOffset,
            curve: Curves.easeOutCubic,
            child: FadeInAnimation(curve: Curves.easeOut, child: content),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? AppColors.scaffoldBackground,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: appBarBackgroundColor,
              elevation: appBarElevation,
              centerTitle: centerTitle,
              automaticallyImplyLeading: automaticallyImplyLeading,
              leading: leading,
              actions: actions,
              bottom: bottom,
              systemOverlayStyle: systemOverlayStyle,
              iconTheme: IconThemeData(color: appBarIconColor ?? Colors.white),
              title:
                  titleWidget ??
                  (appBarTitle != null
                      ? Text(
                          appBarTitle!,
                          style:
                              titleStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                        )
                      : null),
            )
          : null,
      body: content,
    );
  }
}

class CustomAnimation {
  CustomAnimation._();

  /// Smooth fade transition for switching tabs/screens
  static Widget fadeThrough({
    required Widget child,
    Duration duration = const Duration(milliseconds: 280),
  }) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}
