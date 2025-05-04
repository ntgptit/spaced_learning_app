// lib/presentation/widgets/progress/repetition_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/theme/theme_extensions.dart';
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
      return;
    }

    _controller.reverse();
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

    // Sử dụng color scheme từ Material 3
    Color cardColor = colorScheme.surfaceContainerLowest;
    Color borderColor = colorScheme.outlineVariant;
    Color textColor = colorScheme.onSurface;
    Color iconColor = colorScheme.primary;

    // Áp dụng màu sắc dựa trên trạng thái và phù hợp với Material 3
    if (isOverdue) {
      cardColor = colorScheme.errorContainer.withValues(alpha: 0.15);
      borderColor = colorScheme.error.withValues(alpha: 0.7);
      textColor = colorScheme.error;
      iconColor = colorScheme.error;
    }

    if (isCompleted) {
      cardColor = colorScheme.surfaceContainerLow;
      borderColor = colorScheme.success.withValues(alpha: 0.5);
      iconColor = colorScheme.success;
    }

    String statusText = 'Pending';
    IconData statusIcon = Icons.pending;

    if (isCompleted) {
      statusText = 'Completed';
      statusIcon = Icons.check_circle;
    }

    if (isOverdue) {
      statusText = 'Overdue';
      statusIcon = Icons.warning_amber;
    }

    // Sử dụng theme extension để đảm bảo nhất quán màu sắc
    final repetitionColor = theme.getRepetitionColor(
      widget.repetition.repetitionOrder.index,
      isHistory: widget.isHistory,
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
                    ? borderColor
                    : borderColor.withValues(alpha: 0.8),
                width: _isHovering ? 2.0 : 1.5,
              ),
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(
                          alpha: AppDimens.opacityLight,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
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
                              border: Border.all(
                                color: repetitionColor,
                                width: 1.5,
                              ),
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
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
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
                              colorScheme,
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
        color: _isHovering ? colorScheme.success : colorScheme.primary,
        size: AppDimens.iconL,
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
        color: colorScheme.primary,
      ),
      label: Text(
        'Reschedule',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
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
    ColorScheme colorScheme,
    String reviewDateText,
    bool isOverdue,
  ) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: AppDimens.iconS,
          color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppDimens.spaceXS),
        Flexible(
          child: Text(
            'Review date: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            reviewDateText,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isOverdue ? colorScheme.error : colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
