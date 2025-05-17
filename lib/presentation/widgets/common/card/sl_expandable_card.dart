// lib/presentation/widgets/common/card/sl_expandable_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

class SlExpandableCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget content;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final SlCardType cardType;
  final double borderRadius;
  final VoidCallback? onExpansionChanged;
  final bool showExpandIcon;
  final bool animateSize;
  final Duration animationDuration;

  const SlExpandableCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.content,
    this.initiallyExpanded = false,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.backgroundColor,
    this.cardType = SlCardType.elevated,
    this.borderRadius = AppDimens.radiusL,
    this.onExpansionChanged,
    this.showExpandIcon = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<SlExpandableCard> createState() => _SlExpandableCardState();
}

class _SlExpandableCardState extends State<SlExpandableCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

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

      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SlCard(
      type: widget.cardType,
      backgroundColor: widget.backgroundColor,
      padding: EdgeInsets.zero,
      margin: widget.margin,
      borderRadius: widget.borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.borderRadius),
              topRight: Radius.circular(widget.borderRadius),
              bottomLeft: _isExpanded
                  ? Radius.zero
                  : Radius.circular(widget.borderRadius),
              bottomRight: _isExpanded
                  ? Radius.zero
                  : Radius.circular(widget.borderRadius),
            ),
            child: Padding(
              padding: widget.padding,
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: AppDimens.spaceM),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: theme.textTheme.titleMedium),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: AppDimens.spaceXS),
                          Text(
                            widget.subtitle!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.showExpandIcon)
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.animateSize)
            SizeTransition(sizeFactor: _expandAnimation, child: _buildContent())
          else
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: _buildContent(),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: widget.animationDuration,
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const Divider(height: 1),
        Padding(padding: widget.padding, child: widget.content),
      ],
    );
  }
}
