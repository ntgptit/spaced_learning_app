import 'package:flutter/material.dart';

/// A widget that animates its child from top to its final position when first built.
///
/// This animation is inspired by the todo list app and provides a smooth
/// entrance animation for floating content like dialogs, tooltips, or notifications.
class TopAnimationShowWidget extends StatefulWidget {
  /// The widget to animate
  final Widget child;

  /// The duration of the animation
  final Duration? duration;

  /// How far the widget should move vertically during the animation
  final double distanceY;

  const TopAnimationShowWidget({
    super.key,
    required this.child,
    this.duration,
    this.distanceY = 30,
  });

  @override
  _TopAnimationShowWidgetState createState() => _TopAnimationShowWidgetState();
}

class _TopAnimationShowWidgetState extends State<TopAnimationShowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 600),
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * -widget.distanceY),
          child: Opacity(opacity: _animation.value, child: child),
        );
      },
    );
  }
}
