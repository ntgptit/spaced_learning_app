// lib/presentation/widgets/common/dialog/sl_input_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A dialog that allows the user to input text with various customization options.
class SlInputDialog extends ConsumerStatefulWidget {
  final String title;
  final String? message;
  final String? initialValue;
  final String? hintText;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int maxLines;
  final bool isDanger;
  final IconData? prefixIcon;
  final bool barrierDismissible;
  final bool autofocus;
  final TextCapitalization textCapitalization;

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
    this.isDanger = false,
    this.prefixIcon,
    this.barrierDismissible = true,
    this.autofocus = true,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  ConsumerState<SlInputDialog> createState() => _SlInputDialogState();
}

class _SlInputDialogState extends ConsumerState<SlInputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_validateInput);

    // Initial validation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateInput();
    });
  }

  void _validateInput() {
    if (mounted) {
      setState(() {
        if (widget.validator != null) {
          _isValid = widget.validator!(_controller.text) == null;
        } else {
          _isValid = _controller.text.isNotEmpty;
        }
      });
    }
  }

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
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surface,
      title: Text(
        widget.title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.isDanger ? colorScheme.error : null,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message != null) ...[
              Text(widget.message!, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppDimens.spaceM),
            ],
            TextFormField(
              controller: _controller,
              autofocus: widget.autofocus,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon)
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingM,
                ),
                counterText: '',
              ),
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              inputFormatters: widget.inputFormatters,
              validator: widget.validator,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              textCapitalization: widget.textCapitalization,
              onChanged: (_) => _validateInput(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            widget.cancelText,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        FilledButton(
          onPressed: _isValid
              ? () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.of(context).pop(_controller.text);
                  }
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: widget.isDanger
                ? colorScheme.error
                : colorScheme.primary,
            foregroundColor: widget.isDanger
                ? colorScheme.onError
                : colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurface.withValues(
              alpha: 0.38,
            ),
          ),
          child: Text(widget.confirmText),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
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
    bool isDanger = false,
    IconData? prefixIcon,
    bool barrierDismissible = true,
    bool autofocus = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
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
        isDanger: isDanger,
        prefixIcon: prefixIcon,
        barrierDismissible: barrierDismissible,
        autofocus: autofocus,
        textCapitalization: textCapitalization,
      ),
    );
  }

  /// Convenience method to show a name input dialog
  static Future<String?> showNameInput(
    BuildContext context, {
    String title = 'Enter Name',
    String? initialValue,
    String confirmText = 'Save',
  }) {
    return show(
      context,
      title: title,
      initialValue: initialValue,
      hintText: 'Name',
      confirmText: confirmText,
      prefixIcon: Icons.person,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name cannot be empty';
        }
        return null;
      },
    );
  }

  /// Convenience method to show a password input dialog
  static Future<String?> showPasswordInput(
    BuildContext context, {
    String title = 'Enter Password',
    String confirmText = 'Submit',
  }) {
    return show(
      context,
      title: title,
      hintText: 'Password',
      confirmText: confirmText,
      prefixIcon: Icons.lock,
      obscureText: true,
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  /// Convenience method to show a number input dialog
  static Future<String?> showNumberInput(
    BuildContext context, {
    String title = 'Enter Number',
    String? initialValue,
    String confirmText = 'Submit',
    int? maxLength,
  }) {
    return show(
      context,
      title: title,
      initialValue: initialValue,
      hintText: 'Number',
      confirmText: confirmText,
      keyboardType: TextInputType.number,
      prefixIcon: Icons.numbers,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: maxLength,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Number cannot be empty';
        }
        return null;
      },
    );
  }
}
