import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';

/// A visually rich and animated navigation header widget inspired by the todo list app.
/// This creates a decorative header with animated floating circles and rain-like particles.
class NavHead extends StatefulWidget {
  final double? height;
  final Gradient? gradient;
  final Widget? child;
  final bool showDecorations;

  const NavHead({
    super.key,
    this.height,
    this.gradient,
    this.child,
    this.showDecorations = true,
  });

  @override
  _NavHeadState createState() => _NavHeadState();
}

class _NavHeadState extends State<NavHead> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // Calculate dimensions
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double navHeaderHeight = widget.height ?? (statusBarHeight + 160);

    // Circle dimensions based on header height
    final double circleOneRadius = navHeaderHeight / 4;
    final double circleTwoRadius = navHeaderHeight / 8;
    final double circleThreeRadius = navHeaderHeight / 7;
    final double circleFourRadius = navHeaderHeight / 5;
    final double circleFiveRadius = navHeaderHeight / 3;

    // Generate rain-like particles if decorations are enabled
    final rains =
        widget.showDecorations
            ? _getRain(navHeaderHeight, context)
            : <Widget>[];

    return Container(
      height: navHeaderHeight,
      decoration: BoxDecoration(
        gradient:
            widget.gradient ??
            LinearGradient(
              colors:
                  isDark
                      ? [
                        AppColors.darkPrimaryContainer,
                        AppColors.darkPrimary,
                        AppColors.darkSurfaceContainerHighest,
                      ]
                      : [
                        AppColors.lightPrimaryContainer,
                        AppColors.lightPrimary,
                        Colors.white.withOpacity(0.6),
                      ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
      ),
      child: Stack(
        children: [
          // Only show animations if decorations are enabled
          if (widget.showDecorations) ...[
            // Animated rain particles
            AnimatedBuilder(
              animation: _animation,
              builder: (ctx, child) {
                return ClipRect(
                  child: Transform.translate(
                    offset: Offset(
                      (1 - _animation.value) * navHeaderHeight,
                      _animation.value * navHeaderHeight,
                    ),
                    child: child,
                  ),
                );
              },
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, -navHeaderHeight),
                    child: Stack(children: rains),
                  ),
                  Transform.translate(
                    offset: Offset(-navHeaderHeight, 0.0),
                    child: Stack(children: rains),
                  ),
                  Stack(children: rains),
                ],
              ),
            ),

            // Decorative circles
            Positioned(
              left: -circleOneRadius,
              top: 10,
              child: _getCircle(context, circleOneRadius),
            ),
            Positioned(
              left: circleOneRadius + circleTwoRadius,
              top: circleTwoRadius,
              child: _getCircle(context, circleTwoRadius),
            ),
            Positioned(
              left:
                  circleOneRadius + circleTwoRadius * 2 + circleThreeRadius * 2,
              top: 0,
              child: _getCircle(context, circleThreeRadius),
            ),
            Positioned(
              left: circleOneRadius + circleTwoRadius + circleThreeRadius,
              top: navHeaderHeight - circleFourRadius * 5 / 3,
              child: _getCircle(context, circleFourRadius),
            ),
            Positioned(
              left:
                  circleOneRadius +
                  circleTwoRadius +
                  circleThreeRadius +
                  circleFourRadius +
                  circleFiveRadius,
              bottom: circleFiveRadius - 50,
              child: _getCircle(context, circleFiveRadius),
            ),
          ],

          // Content child
          if (widget.child != null) Positioned.fill(child: widget.child!),
        ],
      ),
    );
  }

  /// Creates an animated circle with random rotation
  Widget _getCircle(BuildContext context, double radius) {
    final angle = _getRandomAngle();
    final randomPosOrNeg = Random().nextBool() ? 1 : -1;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      builder: (ctx, child) {
        return Transform.rotate(
          angle: angle * _animation.value * randomPosOrNeg,
          child: child,
        );
      },
      animation: _animation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: _getRandomColor(context),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, radius / 2),
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.3),
              blurRadius: radius + 5,
              spreadRadius: -radius / 2,
            ),
          ],
        ),
        width: radius * 2,
        height: radius * 2,
      ),
    );
  }

  /// Generates random color combinations for decorative elements
  List<Color> _getRandomColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> randomColorList =
        isDark
            ? [
              AppColors.darkPrimary,
              AppColors.darkSecondary,
              AppColors.darkTertiary,
              Colors.white.withOpacity(0.5),
            ]
            : [
              AppColors.lightPrimary,
              AppColors.lightSecondary,
              AppColors.lightTertiary,
              Colors.white.withOpacity(0.8),
            ];

    final List<Color> list = [];
    for (var i = 0; i < randomColorList.length; i++) {
      final randomNumber = Random().nextInt(randomColorList.length);
      list.add(randomColorList[randomNumber]);
    }

    // Ensure we have some white/lightness in the gradient
    final lightColor =
        isDark ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.8);

    if (!list.contains(lightColor)) {
      list.insert(Random().nextInt(list.length), lightColor);
    }

    return list;
  }

  /// Generates a random rotation angle
  double _getRandomAngle() {
    final randomNumberOne = Random().nextInt(10);
    final randomPosOrNeg = Random().nextBool() ? 1 : -1;
    final randomNumberTwo = Random().nextDouble();
    return pi * 2 +
        randomNumberOne * (pi * 2) +
        (pi * 2) * randomPosOrNeg * randomNumberTwo;
  }

  /// Generates rain-like particles
  List<Widget> _getRain(double navHeaderHeight, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final randomNum = Random().nextInt(50) + 30; // 30-80 particles

    final particles = <Widget>[];

    for (int i = 0; i < randomNum; i++) {
      final randomWidth =
          Random().nextDouble() * 3 + 0.5; // Width between 0.5-3.5
      final randomHeight =
          Random().nextDouble() * 30 + 5; // Height between 5-35
      final randomLeft = Random().nextDouble() * navHeaderHeight * 4 / 3;
      final randomTop = Random().nextDouble() * navHeaderHeight;

      particles.add(
        Positioned(
          left: randomLeft - navHeaderHeight * _animation.value,
          top: randomTop + navHeaderHeight * _animation.value,
          child: Transform.rotate(
            angle: pi / 6, // Angle of rain
            child: Container(
              width: randomWidth,
              height: randomHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(randomWidth / 2),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [AppColors.darkPrimary, Colors.white]
                          : [AppColors.lightPrimary, Colors.white],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return particles;
  }
}

/// A custom clipper that creates a full rectangle
class CustomRect extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return false;
  }
}
