import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';

typedef M3ColorPair = ({Color container, Color onContainer});

class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final bool isHistory;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSkip;
  final Function(DateTime)? onReschedule;
  final ThemeData? theme;

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onSkip,
    this.onReschedule,
    this.theme,
  });

  M3ColorPair _getSuccessColors(ColorScheme colorScheme) {
    return (
      container: colorScheme.tertiaryContainer,
      onContainer: colorScheme.onTertiaryContainer,
    );
  }

  M3ColorPair _getWarningColors(ColorScheme colorScheme) {
    return (
      container: colorScheme.secondaryContainer,
      onContainer: colorScheme.onSecondaryContainer,
    );
  }

  M3ColorPair _getErrorColors(ColorScheme colorScheme) {
    return (
      container: colorScheme.errorContainer,
      onContainer: colorScheme.onErrorContainer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    final colorScheme = currentTheme.colorScheme;
    final textTheme = currentTheme.textTheme;
    final dateFormat = DateFormat('dd MMM yyyy');
    final orderText = repetition.formatFullOrder();
    final statusColors = _getStatusColors(repetition.status, colorScheme);
    final dateText =
        repetition.reviewDate != null
            ? dateFormat.format(repetition.reviewDate!)
            : 'Not scheduled';
    final timeIndicator = _getTimeIndicator(repetition.reviewDate);
    final indicatorColors = _getTimeIndicatorColors(
      repetition.reviewDate,
      colorScheme,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // AppDimens.paddingS
      elevation:
          isHistory ? (currentTheme.cardTheme.elevation ?? 1.0) * 0.5 : null,
      color: isHistory ? colorScheme.surfaceContainerLow : null,
      child: InkWell(
        onTap:
            (isHistory || repetition.status != RepetitionStatus.notStarted)
                ? null
                : onMarkCompleted,
        borderRadius:
            ((currentTheme.cardTheme.shape as RoundedRectangleBorder?)
                    ?.borderRadius
                as BorderRadius?) ??
            BorderRadius.circular(12.0), // AppDimens.radiusL
        child: Padding(
          padding: const EdgeInsets.all(16.0), // AppDimens.paddingL
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(textTheme, colorScheme, orderText, statusColors),
              const SizedBox(height: 12.0), // AppDimens.spaceM
              _buildDateRow(
                context,
                textTheme,
                colorScheme,
                dateText,
                timeIndicator,
                indicatorColors,
              ),
              if (!isHistory &&
                  repetition.status == RepetitionStatus.notStarted)
                _buildActions(context, colorScheme, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String orderText,
    M3ColorPair statusColors,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderText,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ), // AppDimens.paddingM, paddingXS
          decoration: BoxDecoration(
            color: statusColors.container,
            borderRadius: BorderRadius.circular(8.0), // AppDimens.radiusM
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatStatus(repetition.status),
                style: textTheme.labelSmall?.copyWith(
                  color: statusColors.onContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (repetition.status == RepetitionStatus.completed) ...[
                const SizedBox(width: 4.0), // AppDimens.spaceXS
                Icon(
                  Icons.check_circle_outline,
                  size: 12.0,
                  color: statusColors.onContainer,
                ), // AppDimens.iconXS
              ],
              if (repetition.status == RepetitionStatus.skipped) ...[
                const SizedBox(width: 4.0), // AppDimens.spaceXS
                Icon(
                  Icons.redo_outlined,
                  size: 12.0,
                  color: statusColors.onContainer,
                ), // AppDimens.iconXS
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String dateText,
    String timeIndicator,
    M3ColorPair? indicatorColors,
  ) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          color: colorScheme.primary,
          size: 16.0,
        ), // AppDimens.iconS
        const SizedBox(width: 8.0), // AppDimens.spaceS
        Text(
          dateText,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        if (indicatorColors != null && timeIndicator.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ), // AppDimens.paddingS, paddingXXS
            decoration: BoxDecoration(
              color: indicatorColors.container,
              borderRadius: BorderRadius.circular(4.0), // AppDimens.radiusS
            ),
            child: Text(
              timeIndicator,
              style: textTheme.labelSmall?.copyWith(
                color: indicatorColors.onContainer,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final rescheduleColor = colorScheme.secondary;
    final rescheduleContainerColors = _getWarningColors(colorScheme);
    final completeColor = colorScheme.tertiary;
    final completeContainerColors = _getSuccessColors(colorScheme);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0), // AppDimens.paddingL
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 12.0, // AppDimens.spaceM
        runSpacing: 8.0, // AppDimens.spaceS
        children: [
          if (onReschedule != null)
            _buildActionButton(
              textTheme: textTheme,
              colorScheme: colorScheme,
              foregroundColor: rescheduleColor,
              containerColors: rescheduleContainerColors,
              label: 'Reschedule',
              icon: Icons.calendar_month_outlined,
              onPressed:
                  () => onReschedule?.call(
                    repetition.reviewDate ?? DateTime.now(),
                  ),
            ),
          if (onMarkCompleted != null)
            _buildActionButton(
              textTheme: textTheme,
              colorScheme: colorScheme,
              foregroundColor: completeColor,
              containerColors: completeContainerColors,
              label: 'Complete',
              icon: Icons.check_circle_outlined,
              onPressed: onMarkCompleted!,
              showScoreIndicator: true,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required Color foregroundColor,
    required M3ColorPair containerColors,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool showScoreIndicator = false,
  }) {
    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: BorderSide(color: foregroundColor),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ), // AppDimens.paddingM
      textStyle: textTheme.labelLarge,
    ).copyWith(minimumSize: WidgetStateProperty.all(Size.zero));
    final scoreIndicatorBg = containerColors.container.withOpacity(0.4);
    final scoreIndicatorFg = containerColors.onContainer;

    return SizedBox(
      height: 36.0, // AppDimens.buttonHeightM
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16.0), // AppDimens.iconS
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (showScoreIndicator) ...[
              const SizedBox(width: 8.0), // AppDimens.spaceS
              Container(
                padding: const EdgeInsets.all(3.0), // AppDimens.paddingXXS + 1
                decoration: BoxDecoration(
                  color: scoreIndicatorBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.percent,
                  size: 10.0,
                  color: scoreIndicatorFg,
                ), // AppDimens.iconXXS
              ),
            ],
          ],
        ),
        style: buttonStyle,
      ),
    );
  }

  String _formatStatus(RepetitionStatus status) {
    switch (status) {
      case RepetitionStatus.notStarted:
        return 'Pending';
      case RepetitionStatus.completed:
        return 'Completed';
      case RepetitionStatus.skipped:
        return 'Skipped';
    }
  }

  M3ColorPair _getStatusColors(
    RepetitionStatus status,
    ColorScheme colorScheme,
  ) {
    return switch (status) {
      RepetitionStatus.notStarted => (
        container: colorScheme.primaryContainer,
        onContainer: colorScheme.onPrimaryContainer,
      ),
      RepetitionStatus.completed => _getSuccessColors(colorScheme),
      RepetitionStatus.skipped => _getWarningColors(colorScheme),
    };
  }

  String _getTimeIndicator(DateTime? date) {
    if (date == null) return '';
    final now = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    final difference = target.difference(now).inDays;
    if (difference < 0) return 'Overdue ${-difference}d';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return 'In $difference days';
  }

  M3ColorPair? _getTimeIndicatorColors(
    DateTime? date,
    ColorScheme colorScheme,
  ) {
    if (date == null) return null;
    final now = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    final difference = target.difference(now).inDays;
    if (difference < 0) return _getErrorColors(colorScheme);
    if (difference == 0) return _getSuccessColors(colorScheme);
    if (difference <= 3) return _getWarningColors(colorScheme);
    return (
      container: colorScheme.secondaryContainer,
      onContainer: colorScheme.onSecondaryContainer,
    );
  }
}
