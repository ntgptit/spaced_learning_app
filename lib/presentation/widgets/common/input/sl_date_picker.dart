import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<DateTime?>? onChanged;
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
  final String dateFormat;
  final String dialogHelpText;
  final String dialogCancelText;
  final String dialogConfirmText;
  final DatePickerEntryMode initialEntryMode;
  final bool showLeadingZeroes;

  const SlDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.prefixIcon = Icons.calendar_today,
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
    this.dateFormat = 'MM/dd/yyyy',
    this.dialogHelpText = 'Select date',
    this.dialogCancelText = 'Cancel',
    this.dialogConfirmText = 'OK',
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.showLeadingZeroes = true,
  });

  @override
  State<SlDatePicker> createState() => _SlDatePickerState();
}

class _SlDatePickerState extends State<SlDatePicker> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedDate = widget.initialDate;

    if (_selectedDate != null) {
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
  void didUpdateWidget(SlDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != _selectedDate) {
      _selectedDate = widget.initialDate;
      _updateTextController();
    }
  }

  void _updateTextController() {
    if (_selectedDate != null) {
      final DateFormat formatter = DateFormat(widget.dateFormat);
      _controller.text = formatter.format(_selectedDate!);
    } else {
      _controller.text = '';
    }
  }

  Future<void> _selectDate() async {
    if (!widget.enabled) return;

    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now;
    final DateTime firstDate = widget.firstDate ?? DateTime(1900);
    final DateTime lastDate = widget.lastDate ?? DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: widget.dialogHelpText,
      cancelText: widget.dialogCancelText,
      confirmText: widget.dialogConfirmText,
      initialEntryMode: widget.initialEntryMode,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
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

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _updateTextController();
      });

      if (widget.onChanged != null) {
        widget.onChanged!(pickedDate);
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
          hintText: widget.hint ?? 'Select date',
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
          onTap: widget.enabled ? _selectDate : null,
        );
      },
    );
  }
}
