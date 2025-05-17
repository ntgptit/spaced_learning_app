// lib/presentation/widgets/common/dialog/sl_input_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/dialog/sl_dialog_button_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/input/sl_text_field.dart';
part 'sl_input_dialog.g.dart';

@riverpod
class DialogInputValue extends _$DialogInputValue {
  @override
  String build(String dialogId) => '';

  void setValue(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

/// A dialog that allows the user to input text with various customization options.
class SlInputDialog extends ConsumerStatefulWidget {
  final String dialogId;
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
  final bool isDangerAction; // For styling the confirm button if needed
  final IconData? prefixIcon;
  final bool barrierDismissible;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autovalidateMode;

  const SlInputDialog({
    super.key,
    required this.dialogId,
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

  factory SlInputDialog._create({
    required String dialogId,
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
    return SlInputDialog(
      dialogId: dialogId,
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
    );
  }

  /// Factory for generic text input
  factory SlInputDialog.text({
    required String dialogId,
    required String title,
    String? message,
    String? initialValue,
    String? hintText,
    String confirmText = 'OK',
    String? Function(String?)? validator,
  }) {
    return SlInputDialog._create(
      dialogId: dialogId,
      title: title,
      message: message,
      initialValue: initialValue,
      hintText: hintText,
      confirmText: confirmText,
      validator: validator,
    );
  }

  /// Factory for number input
  factory SlInputDialog.number({
    required String dialogId,
    required String title,
    String? message,
    String? initialValue,
    String? hintText = 'Enter a number',
    String confirmText = 'OK',
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return SlInputDialog._create(
      dialogId: dialogId,
      title: title,
      message: message,
      initialValue: initialValue,
      hintText: hintText,
      confirmText: confirmText,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: maxLength,
      prefixIcon: Icons.looks_one_outlined,
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

  /// Factory for password input
  factory SlInputDialog.password({
    required String dialogId,
    required String title,
    String? message,
    String hintText = 'Enter password',
    String confirmText = 'Confirm',
    String? Function(String?)? validator,
  }) {
    return SlInputDialog._create(
      dialogId: dialogId,
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
              return 'Password must be at least 6 characters.';
            }
            return null;
          },
    );
  }

  @override
  ConsumerState<SlInputDialog> createState() => _SlInputDialogState();

  /// Show the input dialog with the given parameters
  static Future<String?> show(
    BuildContext context,
    WidgetRef ref, {
    required String dialogId,
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
    // Set initial value in provider if present
    final notifier = ref.read(dialogInputValueProvider(dialogId).notifier);
    if (initialValue != null && initialValue.isNotEmpty) {
      notifier.setValue(initialValue);
    } else {
      notifier.clear();
    }

    return showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => SlInputDialog._create(
        // Using private factory
        dialogId: dialogId,
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

class _SlInputDialogState extends ConsumerState<SlInputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerValue = ref.read(dialogInputValueProvider(widget.dialogId));
      if (providerValue.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = providerValue;
      }
    });
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

    final Color effectiveConfirmButtonColor = widget.isDangerAction
        ? colorScheme.error
        : colorScheme.primary;

    final Color effectiveConfirmButtonForegroundColor =
        effectiveConfirmButtonColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surface,
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
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
      actionsAlignment: MainAxisAlignment.end,

      title: Text(
        widget.title,
        style: theme.textTheme.headlineSmall?.copyWith(
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
              fillColor: colorScheme.surfaceContainerLowest,
              borderColor: colorScheme.outlineVariant,
              focusedBorderColor: colorScheme.primary,
              onChanged: (value) {
                ref
                    .read(dialogInputValueProvider(widget.dialogId).notifier)
                    .setValue(value);
              },
            ),
          ],
        ),
      ),
      actions: [
        SlDialogButtonBar(
          cancelButton: SlTextButton(
            text: widget.cancelText,
            onPressed: () => Navigator.of(context).pop(),
          ),
          confirmButton: SlPrimaryButton(
            text: widget.confirmText,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(_controller.text);
              }
            },
            backgroundColor: effectiveConfirmButtonColor,
            foregroundColor: effectiveConfirmButtonForegroundColor,
          ),
        ),
      ],
    );
  }
}
