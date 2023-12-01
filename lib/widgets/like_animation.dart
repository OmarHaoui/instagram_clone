import 'package:flutter/material.dart';

/// A widget that applies a scale animation to its child.
///
/// The [LikeAnimation] widget is used to animate its child widget with a scale animation.
/// It can be used to create a like animation effect, where the child widget scales up and down.
///
/// The animation can be triggered by setting the [isAnimating] property to true.
/// The duration of the animation can be customized using the [duration] property.
/// An optional [onEnd] callback can be provided to be called when the animation ends.
/// The [smallLike] property can be set to true to create a smaller scale effect.
///
/// Example usage:
///
/// ```dart
/// LikeAnimation(
///   child: Icon(Icons.favorite),
///   isAnimating: true,
///   duration: Duration(milliseconds: 500),
///   onEnd: () {
///     print('Animation ended');
///   },
///   smallLike: false,
/// )
/// ```
class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  }) : super(key: key);

  @override
  _LikeAnimationState createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
        vsync: this);
    scale = Tween<double>(begin: 1.0, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
