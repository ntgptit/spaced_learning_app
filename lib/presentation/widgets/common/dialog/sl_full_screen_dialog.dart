// lib/presentation/widgets/common/dialog/sl_full_screen_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A full-screen dialog with Material 3 design and customizable options.
class SlFullScreenDialog extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final Color? backgroundColor;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingIconPressed;
  final List<Widget>? headerActions;
  final bool showDivider;
  final bool useSafeArea;
  final bool resizeToAvoidBottomInset;
  final bool centerTitle;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;

  const SlFullScreenDialog({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.backgroundColor,
    this.leadingIcon,
    this.onLeadingIconPressed,
    this.headerActions,
    this.showDivider = true,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.centerTitle = false,
    this.floatingActionButton,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;

    final content = Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: centerTitle,
        leading: leadingIcon != null
            ? IconButton(
                icon: Icon(leadingIcon),
                onPressed:
                    onLeadingIconPressed ?? () => Navigator.of(context).pop(),
              )
            : showCloseButton
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: headerActions,
        backgroundColor: effectiveBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (showDivider) const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppDimens.paddingL),
              child: body,
            ),
          ),
          if (actions != null && actions!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingL,
                vertical: AppDimens.paddingM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!.map((action) {
                  final index = actions!.indexOf(action);
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index > 0 ? AppDimens.paddingM : 0,
                    ),
                    child: action,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
      backgroundColor: effectiveBackgroundColor,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    if (useSafeArea) {
      return SafeArea(child: content);
    }

    return content;
  }

  /// Show a full screen dialog
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget>? actions,
    VoidCallback? onClose,
    bool showCloseButton = true,
    Color? backgroundColor,
    IconData? leadingIcon,
    VoidCallback? onLeadingIconPressed,
    List<Widget>? headerActions,
    bool showDivider = true,
    bool useSafeArea = true,
    bool resizeToAvoidBottomInset = true,
    bool centerTitle = false,
    Widget? floatingActionButton,
    EdgeInsetsGeometry? padding,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        fullscreenDialog: true,
        builder: (BuildContext context) => SlFullScreenDialog(
          title: title,
          body: body,
          actions: actions,
          onClose: onClose,
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
          leadingIcon: leadingIcon,
          onLeadingIconPressed: onLeadingIconPressed,
          headerActions: headerActions,
          showDivider: showDivider,
          useSafeArea: useSafeArea,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          centerTitle: centerTitle,
          floatingActionButton: floatingActionButton,
          padding: padding,
        ),
      ),
    );
  }

  /// Convenience method to show a form in a full-screen dialog
  static Future<T?> showForm<T>(
    BuildContext context, {
    required String title,
    required Widget formBody,
    required List<Widget> actions,
    bool resizeToAvoidBottomInset = true,
  }) {
    return show<T>(
      context,
      title: title,
      body: SingleChildScrollView(child: formBody),
      actions: actions,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  /// Convenience method to show a detail view in a full-screen dialog
  static Future<T?> showDetail<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget>? actions,
    bool showCloseButton = true,
  }) {
    return show<T>(
      context,
      title: title,
      body: body,
      actions: actions,
      showCloseButton: showCloseButton,
      centerTitle: true,
    );
  }

  /// Convenience method to show an editor in a full-screen dialog
  static Future<T?> showEditor<T>(
    BuildContext context, {
    required String title,
    required Widget editor,
    required List<Widget> actions,
    bool resizeToAvoidBottomInset = true,
  }) {
    return show<T>(
      context,
      title: title,
      body: editor,
      actions: actions,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      showDivider: true,
    );
  }
}
