import 'package:flutter/material.dart';

class FooterActionsSection extends StatelessWidget {
  final VoidCallback? onExportData;
  final VoidCallback? onHelpPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onFeedbackPressed;

  const FooterActionsSection({
    super.key,
    this.onExportData,
    this.onHelpPressed,
    this.onSettingsPressed,
    this.onFeedbackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onExportData != null)
          Tooltip(
            message: 'Export learning data',
            child: FilledButton.icon(
              onPressed: onExportData,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Export'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        if (onSettingsPressed != null) ...[
          const SizedBox(width: 8),
          Tooltip(
            message: 'Settings',
            child: IconButton(
              onPressed: onSettingsPressed,
              icon: const Icon(Icons.settings_outlined),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurface,
              ),
            ),
          ),
        ],
        if (onFeedbackPressed != null) ...[
          const SizedBox(width: 8),
          Tooltip(
            message: 'Send feedback',
            child: IconButton(
              onPressed: onFeedbackPressed,
              icon: const Icon(Icons.feedback_outlined),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurface,
              ),
            ),
          ),
        ],
        if (onHelpPressed != null) ...[
          const SizedBox(width: 8),
          Tooltip(
            message: 'Help',
            child: IconButton(
              onPressed: onHelpPressed,
              icon: const Icon(Icons.help_outline),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
