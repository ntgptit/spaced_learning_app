import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<TimeOfDay?>? onChanged;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final bool enabled;
  final bool readOnly;
  final InputDecoration? decoration;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final String dialogHelpText;
  final String dialogCancelText;
  final String dialogConfirmText;
  final bool use24HourFormat;
  final TimePickerEntryMode initialEntryMode;

  const SlTimePicker({
    super.key,
    this.initialTime,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.prefixIcon = Icons.access_time,
    this.suffixIcon = Icons.arrow_drop_down,
    this.enabled = true,
    this.readOnly = false,
    this.decoration,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.style,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.dialogHelpText = 'Select time',
    this.dialogCancelText = 'Cancel',
    this.dialogConfirmText = 'OK',
    this.use24HourFormat = false,
    this.initialEntryMode = TimePickerEntryMode.dial,
  });

  @override
  State<SlTimePicker> createState() => _SlTimePickerState();
}

class _SlTimePickerState extends State<SlTimePicker> {
  late TextEditingController _controller;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedTime = widget.initialTime;

    if (_selectedTime != null) {
      _updateTextController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(SlTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime &&
        widget.initialTime != _selectedTime) {
      _selectedTime = widget.initialTime;
      _updateTextController();
    }
  }

  void _updateTextController() {
    if (_selectedTime != null) {
      _controller.text = _formatTime(_selectedTime!);
    } else {
      _controller.text = '';
    }
  }

  String _formatTime(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;

    if (widget.use24HourFormat) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else {
      final int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final String period = hour >= 12 ? 'PM' : 'AM';
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    }
  }

  Future<void> _selectTime() async {
    if (!widget.enabled) return;

    final TimeOfDay initialTime = _selectedTime ?? TimeOfDay.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: widget.dialogHelpText,
      cancelText: widget.dialogCancelText,
      confirmText: widget.dialogConfirmText,
      initialEntryMode: widget.initialEntryMode,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
              dayPeriodColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerLow,
              hourMinuteColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHigh,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
              entryModeIconColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _updateTextController();
      });

      if (widget.onChanged != null) {
        widget.onChanged!(pickedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveFillColor =
        widget.fillColor ?? colorScheme.surfaceContainerLowest;
    final effectiveBorderColor = widget.borderColor ?? colorScheme.outline;
    final effectiveFocusedBorderColor =
        widget.focusedBorderColor ?? colorScheme.primary;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      borderSide: BorderSide(
        color: effectiveBorderColor,
        width: AppDimens.outlineButtonBorderWidth,
      ),
    );

    final InputDecoration effectiveDecoration =
        widget.decoration ??
        InputDecoration(
          labelText: widget.label,
          hintText: widget.hint ?? 'Select time',
          errorText: widget.errorText,
          helperText: widget.helperText,
          filled: true,
          fillColor: effectiveFillColor,
          prefixIcon: Icon(
            widget.prefixIcon,
            color: widget.errorText != null
                ? colorScheme.error
                : colorScheme.primary,
            size: AppDimens.iconM,
          ),
          suffixIcon: widget.enabled
              ? Icon(
                  widget.suffixIcon,
                  color: widget.errorText != null
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                  size: AppDimens.iconL,
                )
              : null,
          border: border,
          enabledBorder: border,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: effectiveFocusedBorderColor,
              width: AppDimens.outlineButtonBorderWidth * 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: AppDimens.outlineButtonBorderWidth,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: AppDimens.outlineButtonBorderWidth * 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: effectiveBorderColor.withValues(
                alpha: AppDimens.opacityDisabled,
              ),
              width: AppDimens.outlineButtonBorderWidth,
            ),
          ),
        );

    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<String> field) {
        final isError = field.hasError || widget.errorText != null;

        return TextField(
          controller: _controller,
          decoration: effectiveDecoration.copyWith(
            errorText: isError ? (widget.errorText ?? field.errorText) : null,
          ),
          style:
              widget.style ??
              theme.textTheme.bodyMedium?.copyWith(
                color: widget.enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(
                        alpha: AppDimens.opacityDisabled,
                      ),
              ),
          readOnly: true,
          enabled: widget.enabled,
          onTap: widget.enabled ? _selectTime : null,
        );
      },
    );
  }
}
