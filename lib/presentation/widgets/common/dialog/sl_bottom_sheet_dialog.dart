// lib/presentation/widgets/common/dialog/sl_bottom_sheet_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton

/// A customizable bottom sheet dialog with Material 3 design principles.
class SlBottomSheetDialog extends ConsumerWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final bool isDismissible;
  final bool enableDrag;
  final bool showCloseButton;
  final double? maxHeightFraction; // Use fraction of screen height
  final EdgeInsetsGeometry padding;
  final Widget?
  iconWidget; // Changed from IconData to Widget for more flexibility
  final bool useSafeArea;
  final bool showDivider;
  final BorderRadius? borderRadius;
  final ScrollController? scrollController;
  final bool isScrollControlled;

  // final Function(DragEndDetails)? onDragEnd; // Removed as it's part of showModalBottomSheet
  final Color? backgroundColor;
  final bool showDragHandle;
  final bool expandToFullScreen; // New property

  const SlBottomSheetDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showCloseButton = true,
    this.maxHeightFraction = 0.85, // Default to 85% of screen height
    this.padding = const EdgeInsets.fromLTRB(
      AppDimens.paddingL, // 16
      AppDimens.paddingS, // 8 (for drag handle space)
      AppDimens.paddingL, // 16
      AppDimens.paddingL, // 16
    ),
    this.iconWidget,
    this.useSafeArea = true, // Default to true as per M3
    this.showDivider = true,
    this.borderRadius,
    this.scrollController,
    this.isScrollControlled = true, // Default to true for flexible height
    // this.onDragEnd,
    this.backgroundColor,
    this.showDragHandle = true,
    this.expandToFullScreen = false, // Default to not full screen
  });

  // Factory for a simple message bottom sheet
  factory SlBottomSheetDialog.message({
    required String title,
    required String message,
    String closeButtonText = 'OK',
    VoidCallback? onClose,
    Widget? icon,
  }) {
    return SlBottomSheetDialog(
      title: title,
      message: message,
      iconWidget: icon,
      showCloseButton: false,
      // Custom close button handling
      actions: [
        SLButton(
          text: closeButtonText,
          onPressed: onClose ?? () {},
          // Needs context to pop, handle in show method
          type: SLButtonType.primary,
        ),
      ],
    );
  }

  // Factory for an action sheet
  factory SlBottomSheetDialog.actionSheet({
    String? title,
    required List<Widget>
    options, // Each option should be a tappable widget like ListTile or SLButton
    Widget? cancelButton, // Optional custom cancel button
  }) {
    return SlBottomSheetDialog(
      title: title,
      content: ListView(
        // Use ListView for scrollable options
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: options,
      ),
      actions: cancelButton != null ? [cancelButton] : null,
      showCloseButton: title != null,
      // Show close if title exists and no custom cancel
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    );
  }

  // Factory for a list view bottom sheet
  factory SlBottomSheetDialog.list({
    required String title,
    required List<Widget> items, // Each item is a widget
    bool showDividers = true,
    ScrollController? scrollController,
  }) {
    return SlBottomSheetDialog(
      title: title,
      content: ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (context, index) => showDividers
            ? const Divider(
                height: 1,
                indent: AppDimens.paddingL,
                endIndent: AppDimens.paddingL,
              )
            : const SizedBox.shrink(),
        itemBuilder: (context, index) => items[index],
      ),
      padding: const EdgeInsets.only(bottom: AppDimens.paddingL),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surfaceContainerLow; // M3 surface color

    final effectiveBorderRadius =
        borderRadius ??
        const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ); // M3 like radius

    final double actualMaxHeight = expandToFullScreen
        ? mediaQuery.size.height - (useSafeArea ? mediaQuery.padding.top : 0)
        : mediaQuery.size.height * (maxHeightFraction ?? 0.85);

    Widget mainContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDragHandle)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.paddingM,
                bottom: AppDimens.paddingS,
              ),
              child: Container(
                width: AppDimens.paddingXXL + AppDimens.paddingS, // 32.0
                height: AppDimens.paddingXXS * 2, // 4.0
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
                ),
              ),
            ),
          ),
        if (title != null || (showCloseButton && onClose != null))
          Padding(
            padding: EdgeInsets.only(
              left: padding.resolve(TextDirection.ltr).left,
              right: padding.resolve(TextDirection.ltr).right,
              top: showDragHandle
                  ? AppDimens.paddingXS
                  : padding.resolve(TextDirection.ltr).top,
              bottom: AppDimens.paddingS,
            ),
            child: Row(
              children: [
                if (iconWidget != null) ...[
                  iconWidget!,
                  const SizedBox(width: AppDimens.spaceS),
                ],
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600, // M3 title
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                const Spacer(),
                // Pushes close button to the right if title is short
                if (showCloseButton && onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: onClose,
                    tooltip: 'Close',
                    color: colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        if (showDivider && (title != null || message != null))
          const Divider(height: 1, thickness: 1), // M3 divider
        if (message != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding.resolve(TextDirection.ltr).left,
              vertical: AppDimens.paddingM,
            ),
            child: Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        if (content != null)
          Flexible(
            // Makes content scrollable if it overflows
            child: SingleChildScrollView(
              // Ensures scrollability
              controller: scrollController,
              padding: EdgeInsets.only(
                left: padding.resolve(TextDirection.ltr).left,
                right: padding.resolve(TextDirection.ltr).right,
                top: (title == null && message == null && !showDragHandle)
                    ? padding.resolve(TextDirection.ltr).top
                    : AppDimens.paddingS,
                bottom: (actions == null || actions!.isEmpty)
                    ? padding.resolve(TextDirection.ltr).bottom
                    : AppDimens.paddingS,
              ),
              child: content,
            ),
          ),
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding.resolve(TextDirection.ltr).left,
              AppDimens.paddingM,
              padding.resolve(TextDirection.ltr).right,
              padding.resolve(TextDirection.ltr).bottom +
                  (useSafeArea ? mediaQuery.padding.bottom : 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: entry.key > 0 ? AppDimens.spaceM : 0,
                  ),
                  child: entry.value,
                );
              }).toList(),
            ),
          ),
      ],
    );

    return Material(
      // Ensures Material theming is applied
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            // M3 shadow
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: AppDimens.elevationS, // 2.0
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(maxHeight: actualMaxHeight),
        child: useSafeArea
            ? SafeArea(top: false, child: mainContent)
            : mainContent,
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
    double? maxHeightFraction = 0.85,
    EdgeInsetsGeometry? padding,
    Widget? iconWidget,
    bool useSafeArea = true,
    bool showDivider = true,
    BorderRadius? borderRadius,
    ScrollController? scrollController,
    bool isScrollControlled = true,
    Color? backgroundColor,
    bool showDragHandle = true,
    bool expandToFullScreen = false,
  }) {
    VoidCallback? defaultOnClose = showCloseButton
        ? () => Navigator.of(context).pop()
        : null;

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: false,
      // SafeArea is handled inside SlBottomSheetDialog now
      backgroundColor: Colors.transparent,
      // Make it transparent to see custom shape/color
      isScrollControlled: isScrollControlled,
      elevation: 0,
      // Handled by SlBottomSheetDialog's shadow
      builder: (context) => SlBottomSheetDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showCloseButton: showCloseButton,
        maxHeightFraction: maxHeightFraction,
        padding:
            padding ??
            const EdgeInsets.fromLTRB(
              AppDimens.paddingL,
              AppDimens.paddingS,
              AppDimens.paddingL,
              AppDimens.paddingL,
            ),
        iconWidget: iconWidget,
        useSafeArea: useSafeArea,
        showDivider: showDivider,
        borderRadius: borderRadius,
        scrollController: scrollController,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        showDragHandle: showDragHandle,
        expandToFullScreen: expandToFullScreen,
        onClose: defaultOnClose, // Pass the default close action
      ),
    );
  }
}
