import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';

class RepetitionCard extends StatefulWidget {
  final Repetition repetition;
  final bool isHistory;
  final VoidCallback? onMarkCompleted;
  final Function(DateTime)? onReschedule;

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onReschedule,
  });

  @override
  State<RepetitionCard> createState() => _RepetitionCardState();
}

class _RepetitionCardState extends State<RepetitionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: AppDimens.durationS),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });

    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Color _getRepetitionColor(int orderIndex) {
    const List<Color> repetitionColors = [
      Color(0xFF4CAF50), // Green 500
      Color(0xFF2196F3), // Blue 500
      Color(0xFFF4511E), // Deep Orange 600
      Color(0xFFAB47BC), // Purple 400
      Color(0xFFEF5350), // Red 400
    ];
    return repetitionColors[(orderIndex - 1) % repetitionColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCompleted = widget.repetition.status == RepetitionStatus.completed;
    final isPending = widget.repetition.status == RepetitionStatus.notStarted;

    final isOverdue =
        isPending &&
        widget.repetition.reviewDate != null &&
        widget.repetition.reviewDate!.isBefore(DateTime.now());

    Color cardColor = colorScheme.surface; // Keep neutral background
    if (isOverdue) {
      cardColor = colorScheme.errorContainer.withValues(
        alpha: AppDimens.opacityLight,
      );
    }

    Color borderColor = colorScheme.outlineVariant;
    if (isOverdue) {
      borderColor = colorScheme.error.withValues(alpha: AppDimens.opacitySemi);
    }
    if (isCompleted) {
      borderColor = colorScheme.outlineVariant; // Neutral border for completed
    }

    Color textColor = colorScheme.onSurface;
    if (isOverdue) {
      textColor = colorScheme.error;
    }
    if (isCompleted) {
      textColor = colorScheme.success; // Success color for status text
    }

    Color iconColor = colorScheme.primary;
    if (isOverdue) {
      iconColor = colorScheme.error;
    }
    if (isCompleted) {
      iconColor = colorScheme.success; // Success color for status icon
    }

    String statusText = 'Pending';
    if (isCompleted) {
      statusText = 'Completed';
    }
    if (isOverdue) {
      statusText = 'Overdue';
    }

    IconData statusIcon = Icons.pending;
    if (isCompleted) {
      statusIcon = Icons.check_circle;
    }
    if (isOverdue) {
      statusIcon = Icons.warning_amber;
    }

    final repetitionColor = _getRepetitionColor(
      widget.repetition.repetitionOrder.index,
    );

    final reviewDateText = widget.repetition.reviewDate != null
        ? DateFormat('MMM dd, yyyy').format(widget.repetition.reviewDate!)
        : 'Not scheduled';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              border: Border.all(
                color: _isHovering
                    ? borderColor.withValues(alpha: AppDimens.opacityVeryHigh)
                    : borderColor,
                width: _isHovering ? 1.5 : 1,
              ),
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(
                          alpha: AppDimens.opacityLight,
                        ),
                        blurRadius: AppDimens.shadowRadiusM,
                        offset: const Offset(0, AppDimens.shadowOffsetS),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              child: InkWell(
                onTap:
                    isPending &&
                        !widget.isHistory &&
                        widget.onMarkCompleted != null
                    ? widget.onMarkCompleted
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: AppDimens.iconL,
                            height: AppDimens.iconL,
                            decoration: BoxDecoration(
                              color: repetitionColor.withValues(
                                alpha: AppDimens.opacityLight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.repetition.formatOrder(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: repetitionColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.repetition.formatFullOrder(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceXS),
                                Row(
                                  children: [
                                    Icon(
                                      statusIcon,
                                      size: AppDimens.iconS,
                                      color: iconColor,
                                    ),
                                    const SizedBox(width: AppDimens.spaceXS),
                                    Text(
                                      statusText,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isPending &&
                              !widget.isHistory &&
                              widget.onMarkCompleted != null)
                            _buildCompletedButton(context, colorScheme),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spaceM),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildDateInfo(
                              theme,
                              reviewDateText,
                              isOverdue,
                            ),
                          ),
                          if (isPending &&
                              !widget.isHistory &&
                              widget.onReschedule != null)
                            _buildRescheduleButton(context, colorScheme),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: Icon(
        Icons.check_circle_outline,
        color: _isHovering
            ? colorScheme.success
            : colorScheme.primary.withValues(alpha: AppDimens.opacityHigh),
      ),
      onPressed: widget.onMarkCompleted,
      tooltip: 'Mark as completed',
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildRescheduleButton(BuildContext context, ColorScheme colorScheme) {
    return TextButton.icon(
      onPressed: widget.repetition.reviewDate != null
          ? () => widget.onReschedule?.call(widget.repetition.reviewDate!)
          : () => widget.onReschedule?.call(DateTime.now()),
      icon: Icon(
        Icons.event,
        size: AppDimens.iconS,
        color: _isHovering
            ? colorScheme.primary
            : colorScheme.primary.withValues(alpha: AppDimens.opacityHigh),
      ),
      label: Text(
        'Reschedule',
        style: TextStyle(
          color: _isHovering
              ? colorScheme.primary
              : colorScheme.primary.withValues(alpha: AppDimens.opacityHigh),
        ),
      ),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingS,
          vertical: AppDimens.paddingXS,
        ),
      ),
    );
  }

  Widget _buildDateInfo(
    ThemeData theme,
    String reviewDateText,
    bool isOverdue,
  ) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: AppDimens.iconS,
          color: isOverdue
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppDimens.spaceXS),
        Flexible(
          child: Text(
            'Review date: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            reviewDateText,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isOverdue
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
