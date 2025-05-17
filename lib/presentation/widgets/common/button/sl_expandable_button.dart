// lib/presentation/widgets/common/button/sl_expandable_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlExpandableButton extends StatefulWidget {
  final String label;
  final List<Widget> children;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool initiallyExpanded;
  final bool isDisabled;
  final VoidCallback? onTap;

  const SlExpandableButton({
    super.key,
    required this.label,
    required this.children,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.initiallyExpanded = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  State<SlExpandableButton> createState() => _SlExpandableButtonState();
}

class _SlExpandableButtonState extends State<SlExpandableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.surfaceContainerLow;
    final effectiveForegroundColor =
        widget.foregroundColor ?? colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Button header
        Material(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.isDisabled ? null : _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingM),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: widget.isDisabled
                          ? colorScheme.onSurface.withValues(
                              alpha: AppDimens.opacityDisabled,
                            )
                          : effectiveForegroundColor,
                      size: AppDimens.iconM,
                    ),
                    const SizedBox(width: AppDimens.spaceM),
                  ],
                  Expanded(
                    child: Text(
                      widget.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: widget.isDisabled
                            ? colorScheme.onSurface.withValues(
                                alpha: AppDimens.opacityDisabled,
                              )
                            : effectiveForegroundColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.isDisabled
                          ? colorScheme.onSurface.withValues(
                              alpha: AppDimens.opacityDisabled,
                            )
                          : effectiveForegroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Expandable content
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.paddingL,
              top: AppDimens.paddingS,
              right: AppDimens.paddingS,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
