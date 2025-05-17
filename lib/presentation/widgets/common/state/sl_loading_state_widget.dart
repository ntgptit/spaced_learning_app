// lib/presentation/widgets/common/state/sl_loading_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlLoadingStateWidget extends ConsumerWidget {
  final String? loadingText;
  final bool isFullPage; // Determines if it should be wrapped in a Scaffold

  const SlLoadingStateWidget({
    super.key,
    this.loadingText,
    this.isFullPage = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme; // Or context.typography

    final Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
        if (loadingText != null && loadingText!.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceM), // Using AppDimens
          Text(
            loadingText!,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isFullPage) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: content),
      );
    }
    // If not full page, ensure it can be placed within other widgets.
    // A Container might be useful if specific alignment or padding is needed when embedded.
    return Center(child: content);
  }
}
