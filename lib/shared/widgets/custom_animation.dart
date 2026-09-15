import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';

/// Animation types supported by [CustomAnimation]
enum CustomAnimationType {
  fadeThrough,
  sharedAxisHorizontal,
  sharedAxisVertical,
  sharedAxisScaled,
  fadeScale,
}

/// A versatile, reusable animation wrapper utilizing `animations: ^3.0.0`
/// that can be wrapped around any page, tab, component, or screen content.
class CustomAnimation extends StatelessWidget {
  final Widget child;
  final CustomAnimationType type;
  final Duration duration;
  final bool reverse;
  final Color fillColor;

  const CustomAnimation({
    super.key,
    required this.child,
    this.type = CustomAnimationType.fadeThrough,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  });

  const CustomAnimation.fadeThrough({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.fadeThrough,
       reverse = false;

  const CustomAnimation.sharedAxisHorizontal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.sharedAxisHorizontal;

  const CustomAnimation.sharedAxisVertical({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.sharedAxisVertical;

  const CustomAnimation.sharedAxisScaled({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.sharedAxisScaled;

  const CustomAnimation.fadeScale({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.fadeScale,
       reverse = false;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: duration,
      reverse: reverse,
      transitionBuilder:
          (
            Widget child,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
          ) {
            switch (type) {
              case CustomAnimationType.fadeThrough:
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: fillColor,
                  child: child,
                );
              case CustomAnimationType.sharedAxisHorizontal:
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  fillColor: fillColor,
                  child: child,
                );
              case CustomAnimationType.sharedAxisVertical:
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  fillColor: fillColor,
                  child: child,
                );
              case CustomAnimationType.sharedAxisScaled:
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  fillColor: fillColor,
                  child: child,
                );
              case CustomAnimationType.fadeScale:
                return FadeScaleTransition(
                  animation: primaryAnimation,
                  child: child,
                );
            }
          },
      child: child,
    );
  }
}

/// Custom GetX Page Transition for FadeThrough using `animations: ^3.0.0`
class FadeThroughPageTransition extends CustomTransition {
  final Color fillColor;
  FadeThroughPageTransition({this.fillColor = Colors.transparent});

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      fillColor: fillColor,
      child: child,
    );
  }
}

/// Custom GetX Page Transition for SharedAxis using `animations: ^3.0.0`
class SharedAxisPageTransition extends CustomTransition {
  final SharedAxisTransitionType transitionType;
  final Color fillColor;

  SharedAxisPageTransition({
    this.transitionType = SharedAxisTransitionType.horizontal,
    this.fillColor = Colors.transparent,
  });

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: transitionType,
      fillColor: fillColor,
      child: child,
    );
  }
}

/// Custom GetX Page Transition for FadeScale using `animations: ^3.0.0`
class FadeScalePageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeScaleTransition(animation: animation, child: child);
  }
}

/// Reusable Container Transform component using `OpenContainer` from `package:animations`.
class CustomOpenContainer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, VoidCallback openContainer)
  closedBuilder;
  final Widget Function(BuildContext context, VoidCallback closeContainer)
  openBuilder;
  final Duration transitionDuration;
  final BorderRadius closedRadius;
  final Color closedColor;
  final Color openColor;
  final double closedElevation;
  final double openElevation;
  final void Function(T? data)? onClosed;

  const CustomOpenContainer({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.closedRadius = const BorderRadius.all(Radius.circular(12)),
    this.closedColor = Colors.transparent,
    this.openColor = const Color(0xFF0F0F1A),
    this.closedElevation = 0,
    this.openElevation = 0,
    this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer<T>(
      transitionDuration: transitionDuration,
      closedShape: RoundedRectangleBorder(borderRadius: closedRadius),
      closedColor: closedColor,
      openColor: openColor,
      closedElevation: closedElevation,
      openElevation: openElevation,
      onClosed: onClosed,
      closedBuilder: closedBuilder,
      openBuilder: openBuilder,
    );
  }
}

/// Helper method to show modal dialogs using [FadeScaleTransitionConfiguration]
Future<T?> showCustomFadeScaleDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showModal<T>(
    context: context,
    configuration: const FadeScaleTransitionConfiguration(
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 200),
    ),
    builder: builder,
  );
}

/// Visual style applied to each staggered item as it reveals.
enum StaggerEffect { fadeSlideUp, fadeSlideRight, fadeScale, fade }

/// Wraps a list of children (grid, column, row — you control the layout)
/// and reveals them one after another using a SINGLE AnimationController,
/// each item's window carved out via [Interval]. This is smoother and
/// cheaper than giving every item its own controller + Future.delayed,
/// because everything stays on one synced timeline and one ticker —
/// no per-item drift, and it plays correctly even if the widget rebuilds
/// mid-animation.
///
/// Usage:
///   StaggeredAnimation(
///     itemCount: movies.length,
///     itemBuilder: (context, index) => PosterCard(movies[index]),
///     // Wrap the itemBuilder output in your Row/Wrap/GridView yourself,
///     // or use StaggeredAnimation.grid / .row helpers below.
///   )
class StaggeredAnimation extends StatefulWidget {
  /// Total number of items to stagger.
  final int itemCount;

  /// Builds each item's static content (no animation logic needed here —
  /// StaggeredAnimation wraps it for you).
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Layout builder — receives the already-animated children and arranges
  /// them (Row, Wrap, Column, GridView, etc). Defaults to a vertical Column.
  final Widget Function(BuildContext context, List<Widget> children)?
  layoutBuilder;

  /// Total duration across ALL items finishing their entrance.
  final Duration totalDuration;

  /// How much of the total duration each item's own animation takes up
  /// (0.0–1.0). Higher = more overlap between consecutive items.
  final double itemSpan;

  final StaggerEffect effect;
  final Curve curve;

  /// Distance items slide in from, for slide-based effects.
  final double slideOffset;

  /// If true, starts automatically on mount. Set false to control manually
  /// via a GlobalKey<StaggeredAnimationState> and call .play().
  final bool autoPlay;

  const StaggeredAnimation({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.layoutBuilder,
    this.totalDuration = const Duration(milliseconds: 600),
    this.itemSpan = 0.6,
    this.effect = StaggerEffect.fadeSlideUp,
    this.curve = Curves.easeOutCubic,
    this.slideOffset = 24,
    this.autoPlay = true,
  });

  @override
  State<StaggeredAnimation> createState() => StaggeredAnimationState();
}

class StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );
    if (widget.autoPlay) {
      // post-frame so the first frame paints items already in their
      // "hidden" state instead of flashing fully-visible then animating
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.forward();
      });
    }
  }

  /// Call this to (re)play the stagger — e.g. when a tab becomes visible
  /// or a list refreshes. `reset: true` snaps back to hidden state first.
  void play({bool reset = true}) {
    if (reset) _controller.value = 0;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Interval _intervalFor(int index) {
    if (widget.itemCount <= 1) return const Interval(0, 1);
    final step = (1 - widget.itemSpan) / (widget.itemCount - 1);
    final start = (step * index).clamp(0.0, 1.0);
    final end = (start + widget.itemSpan).clamp(0.0, 1.0);
    // guard against start > end from extreme itemSpan values
    return Interval(start, start > end ? start : end, curve: widget.curve);
  }

  Widget _applyEffect(Widget child, Animation<double> animation) {
    switch (widget.effect) {
      case StaggerEffect.fadeSlideUp:
        return FadeTransition(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(0, widget.slideOffset * (1 - animation.value)),
            child: child,
          ),
        );
      case StaggerEffect.fadeSlideRight:
        return FadeTransition(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(widget.slideOffset * (1 - animation.value), 0),
            child: child,
          ),
        );
      case StaggerEffect.fadeScale:
        return FadeTransition(
          opacity: animation,
          child: Transform.scale(
            scale: 0.85 + (0.15 * animation.value),
            child: child,
          ),
        );
      case StaggerEffect.fade:
        return FadeTransition(opacity: animation, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = List.generate(widget.itemCount, (index) {
      final itemAnimation = _controller.drive(
        CurveTween(curve: _intervalFor(index)),
      );
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return _applyEffect(
            widget.itemBuilder(context, index),
            itemAnimation,
          );
        },
      );
    });

    if (widget.layoutBuilder != null) {
      return widget.layoutBuilder!(context, children);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
