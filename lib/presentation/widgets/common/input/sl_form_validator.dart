import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sl_form_validator.g.dart';

// Provider for form validation state
@riverpod
class FormValidationState extends _$FormValidationState {
  @override
  Map<String, String?> build(String formId) => {};

  // Set field error
  void setFieldError(String fieldName, String? error) {
    final updatedErrors = Map<String, String?>.from(state);
    updatedErrors[fieldName] = error;
    state = updatedErrors;
  }

  // Clear field error
  void clearFieldError(String fieldName) {
    if (!state.containsKey(fieldName)) return;

    final updatedErrors = Map<String, String?>.from(state);
    updatedErrors.remove(fieldName);
    state = updatedErrors;
  }

  // Clear all errors
  void clearAllErrors() {
    state = {};
  }

  // Check if form is valid
  bool isFormValid() {
    return state.values.every((error) => error == null || error.isEmpty);
  }

  // Get field error
  String? getFieldError(String fieldName) {
    return state[fieldName];
  }
}

class SlFormValidator extends ConsumerWidget {
  final String formId;
  final Widget child;
  final List<String> fieldNames;
  final bool showErrors;
  final Function(bool)? onValidationChanged;
  final AutovalidateMode autovalidateMode;
  final Color? errorColor;
  final bool scrollToError;
  final ScrollPhysics? scrollPhysics;
  final Duration scrollDuration;
  final Curve scrollCurve;
  final GlobalKey<FormState>? formKey;
  final EdgeInsets scrollPadding;

  const SlFormValidator({
    super.key,
    required this.formId,
    required this.child,
    this.fieldNames = const [],
    this.showErrors = true,
    this.onValidationChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.errorColor,
    this.scrollToError = true,
    this.scrollPhysics,
    this.scrollDuration = const Duration(milliseconds: 300),
    this.scrollCurve = Curves.easeInOut,
    this.formKey,
    this.scrollPadding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveErrorColor = errorColor ?? colorScheme.error;
    final validationState = ref.watch(formValidationStateProvider(formId));
    final GlobalKey<FormState> effectiveFormKey =
        formKey ?? GlobalKey<FormState>();

    void validateForm() {
      if (effectiveFormKey.currentState?.validate() ?? false) {
        ref.read(formValidationStateProvider(formId).notifier).clearAllErrors();
        if (onValidationChanged != null) {
          onValidationChanged!(true);
        }
      } else {
        if (onValidationChanged != null) {
          onValidationChanged!(false);
        }

        if (scrollToError) {
          _scrollToFirstError(context);
        }
      }
    }

    // Field validator wrapper
    String? fieldValidator(
      String fieldName,
      String? Function(String?) validator,
      String? value,
    ) {
      final String? error = validator(value);

      if (error != null && error.isNotEmpty) {
        ref
            .read(formValidationStateProvider(formId).notifier)
            .setFieldError(fieldName, error);
      } else {
        ref
            .read(formValidationStateProvider(formId).notifier)
            .clearFieldError(fieldName);
      }

      return showErrors ? error : null;
    }

    return Form(
      key: effectiveFormKey,
      autovalidateMode: autovalidateMode,
      onChanged:
          autovalidateMode == AutovalidateMode.always ||
              autovalidateMode == AutovalidateMode.onUserInteraction
          ? validateForm
          : null,
      child: _FormValidatorInheritedWidget(
        formId: formId,
        validationState: validationState,
        fieldValidator: fieldValidator,
        errorColor: effectiveErrorColor,
        child: child,
      ),
    );
  }

  void _scrollToFirstError(BuildContext context) {
    // Implementation requires ScrollablePositionedList or similar
    // This is a placeholder for the scrolling functionality
    // You would need to track field positions to implement this properly
  }
}

class _FormValidatorInheritedWidget extends InheritedWidget {
  final String formId;
  final Map<String, String?> validationState;
  final String? Function(String, String? Function(String?), String?)
  fieldValidator;
  final Color errorColor;

  const _FormValidatorInheritedWidget({
    required this.formId,
    required this.validationState,
    required this.fieldValidator,
    required this.errorColor,
    required super.child,
  });

  static _FormValidatorInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FormValidatorInheritedWidget>();
  }

  @override
  bool updateShouldNotify(_FormValidatorInheritedWidget oldWidget) {
    return formId != oldWidget.formId ||
        validationState != oldWidget.validationState ||
        errorColor != oldWidget.errorColor;
  }
}

// Utility to get field validator from context
class SlFormValidatorTools {
  static String? Function(String? Function(String?), String?) getFieldValidator(
    BuildContext context,
    String fieldName,
  ) {
    final validator = _FormValidatorInheritedWidget.of(context);
    if (validator == null) {
      // No validator found in widget tree
      return (validatorFn, value) => validatorFn(value);
    }

    return (validatorFn, value) =>
        validator.fieldValidator(fieldName, validatorFn, value);
  }

  static String? getFieldError(BuildContext context, String fieldName) {
    final validator = _FormValidatorInheritedWidget.of(context);
    if (validator == null) return null;

    return validator.validationState[fieldName];
  }

  static Color getErrorColor(BuildContext context) {
    final validator = _FormValidatorInheritedWidget.of(context);
    if (validator == null) {
      return Theme.of(context).colorScheme.error;
    }

    return validator.errorColor;
  }

  static bool isFormValid(BuildContext context, WidgetRef ref, String formId) {
    return ref.read(formValidationStateProvider(formId).notifier).isFormValid();
  }
}
