// lib/presentation/widgets/app_empty_state.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';

class AppEmptyState extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double? iconSize;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                type: AppButtonType.primary,
                prefixIcon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
