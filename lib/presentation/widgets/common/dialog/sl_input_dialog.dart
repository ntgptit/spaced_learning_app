// lib/presentation/widgets/common/dialog/sl_input_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart'; // Assuming SLTextField

/// A dialog that allows the user to input text with various customization options.
class SlInputDialog extends ConsumerStatefulWidget {
  final String title;
  final String? message;
  final String? initialValue;
  final String? hintText;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final bool obscureText; // If true, will show a toggle icon
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int maxLines;
  final bool isDangerAction; // If confirm action is destructive
  final IconData? prefixIcon;
  final bool barrierDismissible;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autovalidateMode;

  const SlInputDialog({
    super.key,
    required this.title,
    this.message,
    this.initialValue,
    this.hintText,
    this.confirmText = 'Submit',
    this.cancelText = 'Cancel',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.isDangerAction = false,
    this.prefixIcon,
    this.barrierDismissible = true,
    this.autofocus = true,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  // Factory for generic text input
  factory SlInputDialog.text({
    required String title,
    String? message,
    String? initialValue,
    String? hintText,
    String confirmText = 'OK',
    String? Function(String?)? validator,
  }) {
    return SlInputDialog(
      title: title,
      message: message,
      initialValue: initialValue,
      hintText: hintText,
      confirmText: confirmText,
      validator: validator,
    );
  }

  // Factory for number input
  factory SlInputDialog.number({
    required String title,
    String? message,
    String? initialValue,
    String? hintText = 'Enter a number',
    String confirmText = 'OK',
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return SlInputDialog(
      title: title,
      message: message,
      initialValue: initialValue,
      hintText: hintText,
      confirmText: confirmText,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: maxLength,
      prefixIcon: Icons.looks_one_outlined,
      // Example icon
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Number cannot be empty.';
            }
            if (double.tryParse(value) == null) return 'Invalid number.';
            return null;
          },
    );
  }

  // Factory for password input
  factory SlInputDialog.password({
    required String title,
    String? message,
    String hintText = 'Enter password',
    String confirmText = 'Confirm',
    String? Function(String?)? validator,
  }) {
    return SlInputDialog(
      title: title,
      message: message,
      hintText: hintText,
      confirmText: confirmText,
      obscureText: true,
      prefixIcon: Icons.lock_outline_rounded,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Password cannot be empty.';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters.'; // Example
            }
            return null;
          },
    );
  }

  @override
  ConsumerState<SlInputDialog> createState() => _SlInputDialogState();
}

class _SlInputDialogState extends ConsumerState<SlInputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  // bool _isValid = false; // Validation is handled by FormState

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    // _controller.addListener(_validateInput); // Form widget handles validation on interaction
    // WidgetsBinding.instance.addPostFrameCallback((_) => _validateInput());
  }

  // void _validateInput() {
  //   if (mounted) {
  //     setState(() {
  //       _isValid = _formKey.currentState?.validate() ?? false;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppDimens.radiusL,
        ), // M3 dialog shape
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
      // M3 surface color
      surfaceTintColor: colorScheme.surfaceTint,
      titlePadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingS,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingS,
        AppDimens.paddingL,
        AppDimens.paddingL,
      ),
      actionsPadding: const EdgeInsets.all(AppDimens.paddingL),
      actionsAlignment: MainAxisAlignment.end,

      title: Text(
        widget.title,
        style: theme.textTheme.headlineSmall?.copyWith(
          // M3 headline
          fontWeight: FontWeight.w600,
          color: widget.isDangerAction
              ? colorScheme.error
              : colorScheme.onSurface,
        ),
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: widget.autovalidateMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message != null) ...[
              Text(
                widget.message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.spaceM),
            ],
            SLTextField(
              // Using the common SLTextField
              controller: _controller,
              autofocus: widget.autofocus,
              hint: widget.hintText,
              prefixIcon: widget.prefixIcon,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              inputFormatters: widget.inputFormatters,
              validator: widget.validator,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              textCapitalization: widget.textCapitalization,
              // onChanged: (_) => _validateInput(), // Form validation handles this
              fillColor: colorScheme.surfaceContainerLowest,
              // Consistent with dialog background
              borderColor: colorScheme.outlineVariant,
              focusedBorderColor: colorScheme.primary,
            ),
          ],
        ),
      ),
      actions: [
        SLButton(
          text: widget.cancelText,
          onPressed: () => Navigator.of(context).pop(),
          type: SLButtonType.text,
          textColor: colorScheme.onSurfaceVariant,
        ),
        SLButton(
          text: widget.confirmText,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          type: widget.isDangerAction
              ? SLButtonType.error
              : SLButtonType.primary,
        ),
      ],
    );
  }

  /// Show the input dialog with the given parameters
  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? message,
    String? initialValue,
    String? hintText,
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
    int maxLines = 1,
    bool isDangerAction = false,
    IconData? prefixIcon,
    bool barrierDismissible = true,
    bool autofocus = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => SlInputDialog(
        title: title,
        message: message,
        initialValue: initialValue,
        hintText: hintText,
        confirmText: confirmText,
        cancelText: cancelText,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
        isDangerAction: isDangerAction,
        prefixIcon: prefixIcon,
        barrierDismissible: barrierDismissible,
        autofocus: autofocus,
        textCapitalization: textCapitalization,
        autovalidateMode: autovalidateMode,
      ),
    );
  }
}
