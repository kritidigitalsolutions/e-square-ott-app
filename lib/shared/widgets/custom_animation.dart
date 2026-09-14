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
  /// The child widget to be animated. Give it a distinct [Key] or [ValueKey]
  /// whenever its content changes to trigger the transition.
  final Widget child;

  /// The type of animation transition to apply.
  final CustomAnimationType type;

  /// Duration of the transition animation. Default is 350ms.
  final Duration duration;

  /// Whether the transition is in reverse direction (relevant for sharedAxis).
  final bool reverse;

  /// Background fill color during the transition.
  final Color fillColor;

  const CustomAnimation({
    super.key,
    required this.child,
    this.type = CustomAnimationType.fadeThrough,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  });

  /// Quick constructor for Fade Through transition (ideal for switching tabs, views, or pages)
  const CustomAnimation.fadeThrough({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.fadeThrough,
       reverse = false;

  /// Quick constructor for Horizontal Shared Axis transition (e.g. forward/back steps)
  const CustomAnimation.sharedAxisHorizontal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.sharedAxisHorizontal;

  /// Quick constructor for Vertical Shared Axis transition (e.g. up/down sheets, modals)
  const CustomAnimation.sharedAxisVertical({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.sharedAxisVertical;

  /// Quick constructor for Scaled Shared Axis transition
  const CustomAnimation.sharedAxisScaled({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.reverse = false,
    this.fillColor = Colors.transparent,
  }) : type = CustomAnimationType.sharedAxisScaled;

  /// Quick constructor for Fade Scale transition (ideal for dialogs, cards, popup entries)
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
/// Wraps any thumbnail/card/button (closed) and smoothly expands it into a full page (open).
class CustomOpenContainer<T> extends StatelessWidget {
  /// The widget displayed in closed state (e.g. Drama poster card, thumbnail).
  final Widget Function(BuildContext context, VoidCallback openContainer)
  closedBuilder;

  /// The target screen/page opened when clicked.
  final Widget Function(BuildContext context, VoidCallback closeContainer)
  openBuilder;

  /// Transition duration.
  final Duration transitionDuration;

  /// Border radius of the closed container.
  final BorderRadius closedRadius;

  /// Color of closed container.
  final Color closedColor;

  /// Color of open container.
  final Color openColor;

  /// Elevation of closed container.
  final double closedElevation;

  /// Elevation of open container.
  final double openElevation;

  /// Callback when closed.
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
