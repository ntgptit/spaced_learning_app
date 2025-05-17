// lib/presentation/widgets/common/dialog/sl_bottom_sheet_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/dialog/sl_dialog_button_bar.dart';

/// A customizable bottom sheet dialog with Material 3 design principles.
class SlBottomSheetDialog extends ConsumerWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions; // Use this for custom button arrangements
  final bool isDismissible;
  final bool enableDrag;
  final bool showCloseButton;
  final double? maxHeightFraction;
  final EdgeInsetsGeometry padding;
  final Widget? iconWidget;
  final bool useSafeArea;
  final bool showDivider;
  final BorderRadius? borderRadius;
  final ScrollController? scrollController;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final bool showDragHandle;
  final bool expandToFullScreen;
  final VoidCallback? onClose; // Called when sheet is closed by any means

  const SlBottomSheetDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showCloseButton = true,
    this.maxHeightFraction = 0.85,
    this.padding = const EdgeInsets.fromLTRB(
      AppDimens.paddingL,
      AppDimens.paddingS,
      AppDimens.paddingL,
      AppDimens.paddingL,
    ),
    this.iconWidget,
    this.useSafeArea = true,
    this.showDivider = true,
    this.borderRadius,
    this.scrollController,
    this.isScrollControlled = true,
    this.backgroundColor,
    this.showDragHandle = true,
    this.expandToFullScreen = false,
    this.onClose,
  });

  factory SlBottomSheetDialog._create({
    // Private factory
    String? title,
    String? message,
    Widget? content,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showCloseButton = true,
    double? maxHeightFraction = 0.85,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(
      AppDimens.paddingL,
      AppDimens.paddingS,
      AppDimens.paddingL,
      AppDimens.paddingL,
    ),
    Widget? iconWidget,
    bool useSafeArea = true,
    bool showDivider = true,
    BorderRadius? borderRadius,
    ScrollController? scrollController,
    bool isScrollControlled = true,
    Color? backgroundColor,
    bool showDragHandle = true,
    bool expandToFullScreen = false,
    VoidCallback? onClose,
  }) {
    return SlBottomSheetDialog(
      title: title,
      message: message,
      content: content,
      actions: actions,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showCloseButton: showCloseButton,
      maxHeightFraction: maxHeightFraction,
      padding: padding,
      iconWidget: iconWidget,
      useSafeArea: useSafeArea,
      showDivider: showDivider,
      borderRadius: borderRadius,
      scrollController: scrollController,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      showDragHandle: showDragHandle,
      expandToFullScreen: expandToFullScreen,
      onClose: onClose,
    );
  }

  /// Factory for a simple message bottom sheet
  static void showMessage(
    BuildContext context, {
    required String title,
    required String message,
    String closeButtonText = 'OK',
    VoidCallback? onClose,
    Widget? icon,
  }) {
    SlBottomSheetDialog.show(
      context,
      title: title,
      message: message,
      iconWidget: icon,
      showCloseButton: false,
      actions: [
        SlPrimaryButton(
          // Using SlPrimaryButton
          text: closeButtonText,
          onPressed: () {
            Navigator.pop(context);
            onClose?.call();
          },
          isFullWidth: true, // Example of using new button props
        ),
      ],
      onClose: onClose,
    );
  }

  /// Factory for an action sheet
  static void showActionSheet(
    BuildContext context, {
    String? title,
    required List<Widget> options,
    Widget? cancelButton, // This should be an SlButtonBase derivative
    VoidCallback? onClose,
  }) {
    SlBottomSheetDialog.show(
      context,
      title: title,
      content: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: options,
      ),
      actions: cancelButton != null ? [cancelButton] : null,
      showCloseButton: title != null && cancelButton == null,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      onClose: onClose,
    );
  }

  /// Factory for a list view bottom sheet
  static void showList(
    BuildContext context, {
    required String title,
    required List<Widget> items,
    bool showDividers = true,
    ScrollController? scrollController,
    VoidCallback? onClose,
  }) {
    SlBottomSheetDialog.show(
      context,
      title: title,
      content: ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (context, index) {
          if (!showDividers) return const SizedBox.shrink();
          return const Divider(
            height: 1,
            indent: AppDimens.paddingL,
            endIndent: AppDimens.paddingL,
          );
        },
        itemBuilder: (context, index) => items[index],
      ),
      padding: const EdgeInsets.only(bottom: AppDimens.paddingL),
      onClose: onClose,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    final effectiveBackgroundColor =
        backgroundColor ??
        colorScheme.surfaceContainerLowest; // M3: surfaceContainerLow
    final effectiveBorderRadius =
        borderRadius ??
        const BorderRadius.vertical(top: Radius.circular(AppDimens.radiusXL));

    final double actualMaxHeight = expandToFullScreen
        ? mediaQuery.size.height - (useSafeArea ? mediaQuery.padding.top : 0)
        : mediaQuery.size.height * (maxHeightFraction ?? 0.85);

    final defaultOnClose = onClose ?? () => Navigator.pop(context);

    final Widget mainContent = Column(
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
                width: AppDimens.paddingXXL + AppDimens.paddingS,
                height: AppDimens.paddingXXS * 2,
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
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                const Spacer(),
                if (showCloseButton)
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: defaultOnClose,
                    tooltip: 'Close',
                    color: colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        if (showDivider && (title != null || message != null))
          const Divider(height: 1, thickness: 1),
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
            child: SingleChildScrollView(
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
              child: content!,
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
            child: SlDialogButtonBar(
              // Using SlDialogButtonBar for consistency
              // This assumes actions are typically [cancel, confirm] or just [confirm]
              cancelButton: actions!.length > 1 ? actions![0] : null,
              confirmButton: actions!.length == 1
                  ? actions![0]
                  : (actions!.length > 1 ? actions![1] : null),
            ),
          ),
      ],
    );

    return Material(
      type: MaterialType.transparency, // Ensures InkWell splashes are visible
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            // M3 style elevation shadow
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: AppDimens.elevationS, // e.g., 3.0
              offset: const Offset(0, 1), // Shadow below
            ),
          ],
        ),
        constraints: BoxConstraints(maxHeight: actualMaxHeight),
        child: useSafeArea
            ? SafeArea(
                top: false,
                child: mainContent,
              ) // Avoid top safe area for bottom sheet
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
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: false,
      // Let the SlBottomSheetDialog handle its own safe area for content
      backgroundColor: Colors.transparent,
      // Make background transparent
      isScrollControlled: isScrollControlled,
      elevation: 0,
      // Use custom shadow in SlBottomSheetDialog
      builder: (BuildContext builderContext) {
        return SlBottomSheetDialog._create(
          // Using private factory
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
          onClose: onClose ?? () => Navigator.pop(builderContext),
        );
      },
    ).whenComplete(() {
      onClose?.call(); // Call onClose when the sheet is dismissed by any means
    });
  }
}
