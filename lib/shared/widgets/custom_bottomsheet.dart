import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    Color barrierColor = const Color(0xCC000000),
    Color backgroundColor = const Color(0xFF141419),
    Color accentColor = const Color(0xFFE50914), // swap for your brand color
    double? maxHeight,
    Duration openDelay = const Duration(milliseconds: 60),
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'CustomBottomSheet',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _BottomSheetContent(
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          showDragHandle: showDragHandle,
          backgroundColor: backgroundColor,
          barrierColor: barrierColor,
          accentColor: accentColor,
          maxHeight: maxHeight,
          openDelay: openDelay,
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  final Widget child;
  final bool isDismissible;
  final bool enableDrag;
  final bool showDragHandle;
  final Color backgroundColor;
  final Color barrierColor;
  final Color accentColor;
  final double? maxHeight;
  final Duration openDelay;

  const _BottomSheetContent({
    required this.child,
    required this.isDismissible,
    required this.enableDrag,
    required this.showDragHandle,
    required this.backgroundColor,
    required this.barrierColor,
    required this.accentColor,
    required this.openDelay,
    this.maxHeight,
  });

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _barrierController;
  double _dragExtent = 0;
  bool _hapticFired = false;
  bool _isDragging = false;

  // Lower damping = more overshoot/bounce — gives that premium "pop" on open
  static const _entrySpring = SpringDescription(
    mass: 1,
    stiffness: 320,
    damping: 22,
  );
  static const _settleSpring = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 28,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _barrierController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _barrierController.forward();

    Future.delayed(widget.openDelay, () {
      if (mounted) {
        HapticFeedback.mediumImpact();
        _controller.animateWith(SpringSimulation(_entrySpring, 0, 1, 6));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _barrierController.dispose();
    super.dispose();
  }

  Future<void> _closeSheet([double velocity = 0]) async {
    _barrierController.reverse();
    await _controller.animateWith(
      SpringSimulation(_settleSpring, _controller.value, 0, velocity),
    );
    if (mounted) Navigator.of(context).pop();
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = true;
    _hapticFired = false;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dy;
      if (_dragExtent < 0) {
        // rubber-band resistance when overscrolling upward past full open
        _dragExtent *= 0.35;
      }
      final screenHeight = MediaQuery.of(context).size.height;
      final raw = 1 - (_dragExtent / screenHeight);
      _controller.value = raw.clamp(0.0, 1.08); // allow tiny overshoot room

      if (!_hapticFired && _dragExtent > 4) {
        _hapticFired = true;
        HapticFeedback.selectionClick();
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    _dragExtent = 0;
    _isDragging = false;

    if (velocity > 700 || _controller.value < 0.6) {
      HapticFeedback.lightImpact();
      _closeSheet(velocity / 1000);
    } else {
      _controller.animateWith(
        SpringSimulation(_entrySpring, _controller.value, 1, velocity / 1000),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _barrierController]),
      builder: (context, _) {
        final progress = _controller.value.clamp(0.0, 1.15);
        final barrierProgress = _barrierController.value.clamp(0.0, 1.0);
        final offsetY = screenHeight * (1 - progress.clamp(0.0, 1.0));
        final scale = 0.90 + (0.10 * progress); // more pronounced pop-in

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // ── Frosted glass scrim with vignette
              Opacity(
                opacity: barrierProgress,
                child: GestureDetector(
                  onTap: widget.isDismissible ? () => _closeSheet() : null,
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 12 * barrierProgress,
                          sigmaY: 12 * barrierProgress,
                        ),
                        child: Container(color: widget.barrierColor),
                      ),
                      // radial vignette focused low, draws the eye to the sheet
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0, 0.9),
                            radius: 1.4,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35 * barrierProgress),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Transform.translate(
                offset: Offset(0, offsetY),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.bottomCenter,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: progress.clamp(0.0, 1.0),
                      child: GestureDetector(
                        onVerticalDragStart: widget.enableDrag
                            ? _onDragStart
                            : null,
                        onVerticalDragUpdate: widget.enableDrag
                            ? _onDragUpdate
                            : null,
                        onVerticalDragEnd: widget.enableDrag
                            ? _onDragEnd
                            : null,
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: widget.maxHeight ?? screenHeight * 0.92,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.lerp(
                                  widget.backgroundColor,
                                  Colors.white,
                                  0.05,
                                )!,
                                widget.backgroundColor,
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.07),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withOpacity(
                                  _isDragging ? 0.18 : 0.10,
                                ),
                                blurRadius: 50,
                                spreadRadius: 2,
                                offset: const Offset(0, -6),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 2,
                                offset: const Offset(0, -8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            child: Stack(
                              children: [
                                SafeArea(
                                  top: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (widget.showDragHandle)
                                        _buildDragHandle(),
                                      Flexible(child: widget.child),
                                    ],
                                  ),
                                ),
                                // top accent glow strip — the "brand pop"
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          widget.accentColor.withOpacity(0.9),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.15, 0.5, 0.85],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // soft glow behind the handle
          Container(
            width: 70,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.06), Colors.transparent],
              ),
            ),
          ),
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.32),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

/// Staggered fade + slide-up entrance for items inside the sheet.
class StaggeredEntry extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration baseDelay;
  final Duration stepDelay;

  const StaggeredEntry({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 120),
    this.stepDelay = const Duration(milliseconds: 45),
  });

  @override
  State<StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<StaggeredEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    final delay = widget.baseDelay + (widget.stepDelay * widget.index);
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
