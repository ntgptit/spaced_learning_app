import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class LearningFooter extends StatelessWidget {
  final int totalModules;
  final int completedModules;
  final VoidCallback? onExportData;
  final VoidCallback? onHelpPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onFeedbackPressed;

  const LearningFooter({
    super.key,
    required this.totalModules,
    required this.completedModules,
    this.onExportData,
    this.onHelpPressed,
    this.onSettingsPressed,
    this.onFeedbackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < AppDimens.breakpointS;
    final completionPercentage = _calculateCompletionPercentage();
    final progressSemanticLabel = _buildProgressSemanticLabel(
      completionPercentage,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle for bottom sheet-like appearance
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child:
                isSmallScreen
                    ? _buildSmallScreenLayout(
                      theme,
                      colorScheme,
                      completionPercentage,
                      progressSemanticLabel,
                    )
                    : _buildWideScreenLayout(
                      theme,
                      colorScheme,
                      completionPercentage,
                      progressSemanticLabel,
                    ),
          ),
        ],
      ),
    );
  }

  String _calculateCompletionPercentage() {
    return totalModules > 0
        ? (completedModules / totalModules * 100).toStringAsFixed(1)
        : '0.0';
  }

  String _buildProgressSemanticLabel(String completionPercentage) {
    return 'Completed $completedModules of $totalModules modules, $completionPercentage percent complete';
  }

  Widget _buildSmallScreenLayout(
    ThemeData theme,
    ColorScheme colorScheme,
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProgressSection(
          theme,
          colorScheme,
          completionPercentage,
          progressSemanticLabel,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActionButtons(theme, colorScheme),
          ),
        ),
      ],
    );
  }

  Widget _buildWideScreenLayout(
    ThemeData theme,
    ColorScheme colorScheme,
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildProgressSection(
            theme,
            colorScheme,
            completionPercentage,
            progressSemanticLabel,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildActionButtons(theme, colorScheme),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    final double percent = double.tryParse(completionPercentage) ?? 0.0;
    Color progressColor;

    if (percent >= 75) {
      progressColor = colorScheme.tertiary;
    } else if (percent >= 50) {
      progressColor = colorScheme.primary;
    } else if (percent >= 25) {
      progressColor = colorScheme.secondary;
    } else {
      progressColor = colorScheme.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Learning Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              '$completionPercentage%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Semantics(
          label: progressSemanticLabel,
          child: ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: 'Completed: ',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              TextSpan(
                text: '$completedModules of $totalModules modules',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return [
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    ];
  }
}
