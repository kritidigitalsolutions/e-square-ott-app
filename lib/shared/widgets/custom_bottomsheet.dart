import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = false,
    Color barrierColor = const Color(0xB3000000), // Black ~70%
    Color backgroundColor = Colors.white,
    double? maxHeight,
    Duration openDelay = const Duration(
      milliseconds: 60,
    ), // NEW: beat before spring-in
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'CustomBottomSheet',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _BottomSheetContent(
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          showDragHandle: showDragHandle,
          backgroundColor: backgroundColor,
          barrierColor: barrierColor,
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
  final double? maxHeight;
  final Duration openDelay;

  const _BottomSheetContent({
    required this.child,
    required this.isDismissible,
    required this.enableDrag,
    required this.showDragHandle,
    required this.backgroundColor,
    required this.barrierColor,
    required this.openDelay,
    this.maxHeight,
  });

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  // separate, faster barrier controller so the scrim can lead slightly
  late AnimationController _barrierController;
  double _dragExtent = 0;

  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 280,
    damping: 26,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _barrierController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    // barrier fades in immediately (no delay) — gives the "something is about to
    // happen" cue instantly, while the sheet itself waits a beat then springs in.
    _barrierController.forward();

    Future.delayed(widget.openDelay, () {
      if (mounted) _controller.animateWith(SpringSimulation(_spring, 0, 1, 5));
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
      SpringSimulation(_spring, _controller.value, 0, velocity),
    );
    if (mounted) Navigator.of(context).pop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dy;
      if (_dragExtent < 0) _dragExtent = 0;
      final screenHeight = MediaQuery.of(context).size.height;
      _controller.value = (1 - (_dragExtent / screenHeight)).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    _dragExtent = 0;

    if (velocity > 700 || _controller.value < 0.6) {
      _closeSheet(velocity / 1000);
    } else {
      _controller.animateWith(
        SpringSimulation(_spring, _controller.value, 1, velocity / 1000),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _barrierController]),
      builder: (context, _) {
        final progress = _controller.value.clamp(0.0, 1.0);
        final barrierProgress = _barrierController.value.clamp(0.0, 1.0);
        final offsetY = screenHeight * (1 - progress);
        // slight scale-up on entry for extra "pop"
        final scale = 0.96 + (0.04 * progress);

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Opacity(
                opacity: barrierProgress,
                child: GestureDetector(
                  onTap: widget.isDismissible ? () => _closeSheet() : null,
                  child: Container(color: widget.barrierColor),
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
                      opacity: progress,
                      child: GestureDetector(
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
                            color: widget.backgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            top: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.showDragHandle) _buildDragHandle(),
                                Flexible(child: widget.child),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// Bonus: wrap items inside your sheet's child with this to get a
/// staggered fade + slide-up entrance — e.g. list of options in a
/// bottom sheet appearing one after another instead of all at once.
///
/// Usage:
///   Column(children: [
///     StaggeredEntry(index: 0, child: OptionTile(...)),
///     StaggeredEntry(index: 1, child: OptionTile(...)),
///     StaggeredEntry(index: 2, child: OptionTile(...)),
///   ])
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
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
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
