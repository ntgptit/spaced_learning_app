// lib/presentation/widgets/common/dialog/sl_full_screen_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton

/// A full-screen dialog with Material 3 design and customizable options.
class SlFullScreenDialog extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final VoidCallback? onClose; // If null, a default pop action is used
  final bool showAppBar; // Control AppBar visibility
  final Color? backgroundColor;
  final IconData? leadingIcon; // For AppBar leading
  final VoidCallback? onLeadingIconPressed;
  final List<Widget>? appBarActions; // Actions for AppBar
  final bool showAppBarDivider;
  final bool useSafeArea;
  final bool resizeToAvoidBottomInset;
  final bool centerTitle;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry bodyPadding; // Renamed for clarity
  final PreferredSizeWidget? customAppBar; // Allow custom AppBar

  const SlFullScreenDialog({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.onClose,
    this.showAppBar = true,
    this.backgroundColor,
    this.leadingIcon = Icons.close_rounded, // Default to close icon
    this.onLeadingIconPressed,
    this.appBarActions,
    this.showAppBarDivider = true,
    this.useSafeArea = true, // Default to true
    this.resizeToAvoidBottomInset = true,
    this.centerTitle = false, // M3 often starts titles from left
    this.floatingActionButton,
    this.bodyPadding = const EdgeInsets.all(AppDimens.paddingL),
    this.customAppBar,
  });

  // Factory for a simple informational full-screen dialog
  factory SlFullScreenDialog.info({
    required String title,
    required Widget contentBody,
    String closeButtonText = 'Done',
    VoidCallback? onCloseAction,
  }) {
    return SlFullScreenDialog(
      title: title,
      body: contentBody,
      actions: [
        SLButton(
          text: closeButtonText,
          onPressed: onCloseAction ?? () {}, // Handle in show method
          type: SLButtonType.primary,
        ),
      ],
      centerTitle: true,
    );
  }

  // Factory for a form editing full-screen dialog
  factory SlFullScreenDialog.form({
    required String title,
    required Widget formBody,
    required List<Widget> formActions, // e.g., Save, Cancel buttons
    bool resizeToAvoidBottomInset = true,
    IconData leadingIcon = Icons.arrow_back_rounded, // Back arrow for forms
  }) {
    return SlFullScreenDialog(
      title: title,
      body: SingleChildScrollView(
        // Ensure form is scrollable
        padding: const EdgeInsets.all(AppDimens.paddingL),
        // Default padding for form
        child: formBody,
      ),
      actions: formActions,
      leadingIcon: leadingIcon,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      showAppBarDivider: true,
    );
  }

  // Factory for a detailed view full-screen dialog
  factory SlFullScreenDialog.detail({
    required String title,
    required Widget detailBody,
    List<Widget>? appBarActions, // Actions specific to the detail view
    IconData leadingIcon = Icons.arrow_back_rounded,
  }) {
    return SlFullScreenDialog(
      title: title,
      body: detailBody,
      // Body might be complex, let user handle scrolling
      appBarActions: appBarActions,
      leadingIcon: leadingIcon,
      centerTitle: false, // Titles often start left in detail views
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surface; // M3 surface

    final Widget mainBody = Column(
      children: [
        if (showAppBarDivider && showAppBar && customAppBar == null)
          const Divider(height: 1, thickness: 1),
        Expanded(
          child: Padding(padding: bodyPadding, child: body),
        ),
        if (actions != null && actions!.isNotEmpty)
          Container(
            // M3 Bottom App Bar style for actions
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              // M3 surface container for action bar
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: AppDimens.elevationS, // 2.0
                  offset: const Offset(0, -1), // Shadow above
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: AppDimens.paddingL,
              right: AppDimens.paddingL,
              top: AppDimens.paddingS,
              bottom:
                  AppDimens.paddingM +
                  (useSafeArea ? MediaQuery.of(context).padding.bottom : 0),
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

    final Widget scaffoldContent = Scaffold(
      appBar: showAppBar
          ? customAppBar ??
                AppBar(
                  title: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      // M3 titleLarge
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  centerTitle: centerTitle,
                  leading: IconButton(
                    icon: Icon(
                      leadingIcon,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed:
                        onLeadingIconPressed ??
                        onClose ??
                        () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                  actions: appBarActions,
                  backgroundColor: effectiveBackgroundColor,
                  // Should match scaffold's for seamless look
                  elevation: 0,
                  // M3 often uses flat AppBars in full-screen dialogs
                  surfaceTintColor: Colors.transparent, // M3
                )
          : null,
      body: useSafeArea ? SafeArea(child: mainBody) : mainBody,
      backgroundColor: effectiveBackgroundColor,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    return scaffoldContent; // Full-screen dialogs are typically routes, not direct dialogs
  }

  /// Show a full screen dialog as a new route
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget>? actions,
    VoidCallback? onClose,
    bool showAppBar = true,
    Color? backgroundColor,
    IconData? leadingIcon = Icons.close_rounded,
    VoidCallback? onLeadingIconPressed,
    List<Widget>? appBarActions,
    bool showAppBarDivider = true,
    bool useSafeArea = true,
    bool resizeToAvoidBottomInset = true,
    bool centerTitle = false,
    Widget? floatingActionButton,
    EdgeInsetsGeometry? bodyPadding,
    PreferredSizeWidget? customAppBar,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        fullscreenDialog: true, // This makes it a full-screen dialog route
        builder: (BuildContext context) => SlFullScreenDialog(
          title: title,
          body: body,
          actions: actions,
          onClose: onClose,
          showAppBar: showAppBar,
          backgroundColor: backgroundColor,
          leadingIcon: leadingIcon,
          onLeadingIconPressed: onLeadingIconPressed,
          appBarActions: appBarActions,
          showAppBarDivider: showAppBarDivider,
          useSafeArea: useSafeArea,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          centerTitle: centerTitle,
          floatingActionButton: floatingActionButton,
          bodyPadding: bodyPadding ?? const EdgeInsets.all(AppDimens.paddingL),
          customAppBar: customAppBar,
        ),
      ),
    );
  }
}
