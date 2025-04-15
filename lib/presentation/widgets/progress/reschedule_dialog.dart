import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';

class RescheduleDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required DateTime initialDate,
    required String title,
  }) async {
    DateTime selectedDate = initialDate;
    bool rescheduleFollowing = false;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setState) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingL),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context, title),
                        const SizedBox(height: AppDimens.spaceM),
                        _buildDatePicker(
                          context,
                          selectedDate,
                          (date) => setState(() => selectedDate = date),
                        ),
                        const SizedBox(height: AppDimens.spaceM),
                        _buildRescheduleSwitchOption(
                          context,
                          rescheduleFollowing,
                          (value) =>
                              setState(() => rescheduleFollowing = value),
                        ),
                        const SizedBox(height: AppDimens.spaceL),
                        _buildActionButtons(
                          context,
                          selectedDate,
                          rescheduleFollowing,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  static Widget _buildHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.event,
          color: theme.colorScheme.primary,
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceM),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }

  static Widget _buildDatePicker(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateChanged,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingM),
            child: Text('Select new date:', style: theme.textTheme.titleMedium),
          ),
          Expanded(
            child: Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: theme.colorScheme.primary,
                  onPrimary: theme.colorScheme.onPrimary,
                  surface: theme.colorScheme.surface,
                ),
              ),
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: onDateChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRescheduleSwitchOption(
    BuildContext context,
    bool rescheduleFollowing,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          'Reschedule following repetitions',
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          'Adjust all future repetitions based on this new date',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: rescheduleFollowing,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingXS,
        ),
      ),
    );
  }

  static Widget _buildActionButtons(
    BuildContext context,
    DateTime selectedDate,
    bool rescheduleFollowing,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          text: 'Cancel',
          type: AppButtonType.text,
          size: AppButtonSize.small, // Changed to small
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: AppDimens.spaceM),
        AppButton(
          text: 'Reschedule',
          type: AppButtonType.primary,
          prefixIcon: Icons.calendar_today,
          size: AppButtonSize.small, // Changed to small
          onPressed:
              () => Navigator.pop(context, {
                'date': selectedDate,
                'rescheduleFollowing': rescheduleFollowing,
              }),
        ),
      ],
    );
  }
}
