// lib/presentation/widgets/progress/reschedule_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/sl_toggle_switch.dart';

class RescheduleDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required DateTime initialDate,
    required String title,
  }) async {
    DateTime selectedDate = initialDate;
    // Mặc định rescheduleFollowing luôn là true
    bool rescheduleFollowing = true;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => ProviderScope(
        child: _RescheduleDialogContent(
          initialDate: initialDate,
          title: title,
          onDateSelected: (date) => selectedDate = date,
          onRescheduleFollowingChanged: (value) => rescheduleFollowing = value,
          onCancel: () => Navigator.pop(dialogContext),
          onReschedule: () => Navigator.pop(dialogContext, {
            'date': selectedDate,
            'rescheduleFollowing': rescheduleFollowing,
          }),
        ),
      ),
    );
  }
}

class _RescheduleDialogContent extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final String title;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<bool> onRescheduleFollowingChanged;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const _RescheduleDialogContent({
    required this.initialDate,
    required this.title,
    required this.onDateSelected,
    required this.onRescheduleFollowingChanged,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  ConsumerState<_RescheduleDialogContent> createState() =>
      _RescheduleDialogContentState();
}

class _RescheduleDialogContentState
    extends ConsumerState<_RescheduleDialogContent> {
  late DateTime _selectedDate;

  // Khởi tạo giá trị mặc định là true
  bool _rescheduleFollowing = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    // Thông báo cho parent widget về giá trị mặc định
    widget.onRescheduleFollowingChanged(_rescheduleFollowing);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      elevation: AppDimens.elevationM,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, widget.title),
            const SizedBox(height: AppDimens.spaceM),
            _buildDatePicker(context, _selectedDate, (date) {
              setState(() => _selectedDate = date);
              widget.onDateSelected(date);
            }),
            const SizedBox(height: AppDimens.spaceM),
            _buildRescheduleSwitchOption(context, _rescheduleFollowing, (
              value,
            ) {
              setState(() => _rescheduleFollowing = value);
              widget.onRescheduleFollowingChanged(value);
            }),
            const SizedBox(height: AppDimens.spaceL),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(Icons.event, color: colorScheme.primary, size: AppDimens.iconM),
        const SizedBox(width: AppDimens.spaceM),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
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
                colorScheme: colorScheme.copyWith(
                  primary: colorScheme.primary,
                  onPrimary: colorScheme.onPrimary,
                  surface: colorScheme.surface,
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

  Widget _buildRescheduleSwitchOption(
    BuildContext context,
    bool rescheduleFollowing,
    Function(bool) onChanged,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityMediumHigh,
          ),
        ),
      ),
      child: SLToggleSwitch(
        title: 'Reschedule following repetitions',
        subtitle: 'Adjust all future repetitions based on this new date',
        value: rescheduleFollowing,
        onChanged: onChanged,
        type: SLToggleSwitchType.standard,
        size: SLToggleSwitchSize.medium,
        icon: Icons.repeat,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingXS,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SLButton(
          text: 'Cancel',
          type: SLButtonType.text,
          size: SLButtonSize.small,
          onPressed: widget.onCancel,
        ),
        const SizedBox(width: AppDimens.spaceM),
        SLButton(
          text: 'Reschedule',
          type: SLButtonType.primary,
          prefixIcon: Icons.calendar_today,
          size: SLButtonSize.small,
          onPressed: widget.onReschedule,
        ),
      ],
    );
  }
}
