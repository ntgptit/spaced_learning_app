import 'package:flutter/material.dart';

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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final completionPercentage =
        totalModules > 0
            ? (completedModules / totalModules * 100).toStringAsFixed(1)
            : '0.0';

    final progressSemanticLabel =
        'Completed $completedModules of $totalModules modules, $completionPercentage percent complete';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child:
          isSmallScreen
              ? _buildSmallScreenLayout(
                theme,
                completionPercentage,
                progressSemanticLabel,
              )
              : _buildWideScreenLayout(
                theme,
                completionPercentage,
                progressSemanticLabel,
              ),
    );
  }

  Widget _buildSmallScreenLayout(
    ThemeData theme,
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Learning Progress', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Semantics(
              label: progressSemanticLabel,
              child: ExcludeSemantics(
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: 'Completed: ',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '$completedModules of $totalModules modules ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: '($completionPercentage%)',
                        style: TextStyle(color: theme.colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
              children: _buildActionButtons(theme),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideScreenLayout(
    ThemeData theme,
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Learning Progress', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Semantics(
                label: progressSemanticLabel,
                child: ExcludeSemantics(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Completed: ',
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        TextSpan(
                          text: '$completedModules of $totalModules modules ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: '($completionPercentage%)',
                          style: TextStyle(color: theme.colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildActionButtons(theme),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons(ThemeData theme) {
    final buttons = <Widget>[];

    if (onExportData != null) {
      buttons.add(
        Tooltip(
          message: 'Export learning data',
          child: TextButton.icon(
            onPressed: onExportData,
            icon: const Icon(Icons.download),
            label: const Text('Export'),
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
        ),
      );
    }

    if (onSettingsPressed != null) {
      buttons.addAll([
        const SizedBox(width: 8),
        Tooltip(
          message: 'Settings',
          child: IconButton(
            onPressed: onSettingsPressed,
            icon: const Icon(Icons.settings_outlined),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ]);
    }

    if (onFeedbackPressed != null) {
      buttons.addAll([
        const SizedBox(width: 8),
        Tooltip(
          message: 'Send feedback',
          child: IconButton(
            onPressed: onFeedbackPressed,
            icon: const Icon(Icons.feedback_outlined),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ]);
    }

    if (onHelpPressed != null) {
      buttons.addAll([
        const SizedBox(width: 8),
        Tooltip(
          message: 'Help',
          child: IconButton(
            onPressed: onHelpPressed,
            icon: const Icon(Icons.help_outline),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ]);
    }

    return buttons;
  }
}
