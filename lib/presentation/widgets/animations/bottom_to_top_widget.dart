import 'package:flutter/material.dart';

/// A widget that animates its child from bottom to top when first built.
///
/// This animation is inspired by the todo list app and provides a smooth
/// entrance animation for content as it appears on the screen.
class BottomToTopWidget extends StatefulWidget {
  /// The widget to animate
  final Widget child;

  /// The index used to stagger animations when multiple widgets are animated in sequence
  final int index;

  /// The delay before animation starts (in milliseconds)
  final int delay;

  /// The duration of the animation
  final Duration duration;

  const BottomToTopWidget({
    super.key,
    required this.child,
    required this.index,
    this.delay = 200,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  // ignore: library_private_types_in_public_api
  _BottomToTopWidgetState createState() => _BottomToTopWidgetState();
}

class _BottomToTopWidgetState extends State<BottomToTopWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));

    Future.delayed(Duration(milliseconds: widget.delay * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * size.height * 0.2),
          child: Opacity(opacity: _animation.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}
