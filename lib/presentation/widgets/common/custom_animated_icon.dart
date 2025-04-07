import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A custom floating border shape for the FAB
class FloatingBorder extends ShapeBorder {
  final double radius;
  final double shapeRotation;

  const FloatingBorder({this.radius = 30.0, this.shapeRotation = 0.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(radius);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No additional painting needed
  }

  @override
  ShapeBorder scale(double t) {
    return FloatingBorder(radius: radius * t, shapeRotation: shapeRotation);
  }
}

/// An animated floating action button inspired by the todo list app.
/// It can hide/show with animation and has a custom shape.
class AnimatedFloatingButton extends StatefulWidget {
  /// Background color of the button
  final Color? bgColor;

  /// Icon to display in the button
  final IconData icon;

  /// Icon color
  final Color? iconColor;

  /// Size of the button
  final double size;

  /// Whether the button is initially visible
  final bool initiallyVisible;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Whether to use a custom border shape
  final bool useCustomShape;

  const AnimatedFloatingButton({
    super.key,
    this.bgColor,
    this.icon = Icons.add,
    this.iconColor,
    this.size = 56.0,
    this.initiallyVisible = true,
    required this.onPressed,
    this.useCustomShape = true,
  });

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.initiallyVisible;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (!_isVisible) {
      _controller.value = 1.0; // Start with button hidden
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Show the floating button with animation
  void show() {
    if (!_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _controller.reverse();
    }
  }

  /// Hide the floating button with animation
  void hide() {
    if (_isVisible) {
      setState(() {
        _isVisible = false;
      });
      _controller.forward();
    }
  }

  /// Toggle visibility of the button
  void toggle() {
    if (_isVisible) {
      hide();
    } else {
      show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = widget.bgColor ?? theme.colorScheme.primary;
    final effectiveIconColor = widget.iconColor ?? Colors.white;

    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (_animation.value) * widget.size),
          child: Transform.scale(
            scale: 1 - _animation.value,
            child: Transform.rotate(angle: _animation.value * pi, child: child),
          ),
        );
      },
      child: FloatingActionButton(
        heroTag: 'animatedFAB',
        backgroundColor: effectiveBgColor,
        onPressed: widget.onPressed,
        foregroundColor: effectiveIconColor,
        elevation: AppDimens.elevationL,
        shape: widget.useCustomShape ? const FloatingBorder() : null,
        child: Icon(widget.icon, size: widget.size / 2.5),
      ),
    );
  }
}
