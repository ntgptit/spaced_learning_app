// lib/presentation/widgets/common/dialog/sl_bottom_sheet_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A customizable bottom sheet dialog with Material 3 design principles.
class SlBottomSheetDialog extends ConsumerWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final bool isDismissible;
  final bool enableDrag;
  final bool showCloseButton;
  final double? maxHeight;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final bool useSafeArea;
  final bool showDivider;
  final BorderRadius? borderRadius;
  final ScrollController? scrollController;
  final bool isScrollControlled;
  final Function(DragEndDetails)? onDragEnd;
  final Color? backgroundColor;
  final bool showDragHandle;

  const SlBottomSheetDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showCloseButton = true,
    this.maxHeight,
    this.padding = const EdgeInsets.fromLTRB(
      AppDimens.paddingL,
      AppDimens.paddingL,
      AppDimens.paddingL,
      AppDimens.paddingL,
    ),
    this.icon,
    this.useSafeArea = true,
    this.showDivider = true,
    this.borderRadius,
    this.scrollController,
    this.isScrollControlled = true,
    this.onDragEnd,
    this.backgroundColor,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;

    final effectiveBorderRadius =
        borderRadius ??
        BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radiusL),
          topRight: Radius.circular(AppDimens.radiusL),
        );

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
      ),
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showDragHandle) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimens.paddingM),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusCircular,
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (title != null || showCloseButton) ...[
            Padding(
              padding: EdgeInsets.only(
                left: padding.resolve(TextDirection.ltr).left,
                right: padding.resolve(TextDirection.ltr).right,
                top: showDragHandle
                    ? AppDimens.paddingM
                    : padding.resolve(TextDirection.ltr).top,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: AppDimens.spaceM),
                        ],
                        if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Close',
                    ),
                ],
              ),
            ),
            if (showDivider) const Divider(height: AppDimens.spaceL),
          ],
          if (message != null)
            Padding(
              padding: EdgeInsets.only(
                left: padding.resolve(TextDirection.ltr).left,
                right: padding.resolve(TextDirection.ltr).right,
                top: title != null
                    ? AppDimens.paddingS
                    : padding.resolve(TextDirection.ltr).top,
                bottom: content != null
                    ? AppDimens.paddingM
                    : padding.resolve(TextDirection.ltr).bottom,
              ),
              child: Text(message!, style: theme.textTheme.bodyLarge),
            ),
          if (content != null)
            Flexible(
              child: Padding(
                padding: title != null || message != null
                    ? EdgeInsets.fromLTRB(
                        padding.resolve(TextDirection.ltr).left,
                        0,
                        padding.resolve(TextDirection.ltr).right,
                        actions != null
                            ? 0
                            : padding.resolve(TextDirection.ltr).bottom,
                      )
                    : padding,
                child: content!,
              ),
            ),
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding.resolve(TextDirection.ltr).left,
                AppDimens.paddingM,
                padding.resolve(TextDirection.ltr).right,
                padding.resolve(TextDirection.ltr).bottom,
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
    );
  }

  /// Show the bottom sheet dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? message,
    Widget? content,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showCloseButton = true,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
    Widget? icon,
    bool useSafeArea = true,
    bool showDivider = true,
    BorderRadius? borderRadius,
    ScrollController? scrollController,
    bool isScrollControlled = true,
    Function(DragEndDetails)? onDragEnd,
    Color? backgroundColor,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      clipBehavior: Clip.antiAlias,
      builder: (context) => SlBottomSheetDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showCloseButton: showCloseButton,
        maxHeight: maxHeight,
        padding:
            padding ??
            const EdgeInsets.fromLTRB(
              AppDimens.paddingL,
              AppDimens.paddingL,
              AppDimens.paddingL,
              AppDimens.paddingL,
            ),
        icon: icon,
        useSafeArea: useSafeArea,
        showDivider: showDivider,
        borderRadius: borderRadius,
        scrollController: scrollController,
        isScrollControlled: isScrollControlled,
        onDragEnd: onDragEnd,
        backgroundColor: backgroundColor,
        showDragHandle: showDragHandle,
      ),
    );
  }

  /// Convenience method to show an action sheet with options
  static Future<T?> showActionSheet<T>(
    BuildContext context, {
    required String title,
    String? message,
    required List<Widget> options,
    Widget? cancelButton,
  }) {
    return show<T>(
      context,
      title: title,
      message: message,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final index = options.indexOf(option);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option,
              if (index < options.length - 1) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
      actions: cancelButton != null ? [cancelButton] : null,
      showDragHandle: true,
    );
  }

  /// Convenience method to show a list in a bottom sheet
  static Future<T?> showList<T>(
    BuildContext context, {
    required String title,
    required List<Widget> items,
    bool showDividers = true,
  }) {
    return show<T>(
      context,
      title: title,
      content: ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            showDividers ? const Divider(height: 1) : const SizedBox.shrink(),
        itemBuilder: (context, index) => items[index],
      ),
      showDragHandle: true,
    );
  }

  /// Convenience method to show a menu with options
  static Future<T?> showMenu<T>(
    BuildContext context, {
    String? title,
    required List<ListTile> menuItems,
  }) {
    return show<T>(
      context,
      title: title,
      content: Column(mainAxisSize: MainAxisSize.min, children: menuItems),
      showDragHandle: true,
    );
  }
}
