import 'package:flutter/material.dart';

/// A widget that animates its child with a scaling effect.
///
/// This can be used for:
/// - Drawing attention to important elements
/// - Button press animations
/// - Pulse effects for notifications
///
/// Inspired by the todo list app's animation styles.
class ScaleAnimationWidget extends StatefulWidget {
  /// The widget to animate
  final Widget child;

  /// Duration of the animation cycle
  final Duration duration;

  /// Whether to repeat the animation continuously
  final bool repeat;

  /// Minimum scale value (between 0.0 and 1.0)
  final double minScale;

  /// Maximum scale value (usually 1.0 or higher)
  final double maxScale;

  /// Whether to automatically start the animation
  final bool autoStart;

  const ScaleAnimationWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.repeat = true,
    this.minScale = 0.9,
    this.maxScale = 1.1,
    this.autoStart = true,
  });

  @override
  _ScaleAnimationWidgetState createState() => _ScaleAnimationWidgetState();
}

class _ScaleAnimationWidgetState extends State<ScaleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.repeat) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    }

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Manually start the animation
  void start() {
    if (!_controller.isAnimating) {
      _controller.forward();
    }
  }

  /// Manually stop the animation
  void stop() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  /// Reset the animation to its starting state
  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: widget.child,
    );
  }
}
