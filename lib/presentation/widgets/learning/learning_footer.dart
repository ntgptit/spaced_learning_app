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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < AppDimens.breakpointS;
    final completionPercentage = _calculateCompletionPercentage();
    final progressSemanticLabel = _buildProgressSemanticLabel(
      completionPercentage,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingM,
        horizontal: AppDimens.paddingL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(AppDimens.opacityMedium),
            blurRadius: AppDimens.shadowRadiusM,
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
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProgressSection(
          theme,
          completionPercentage,
          progressSemanticLabel,
        ),
        const SizedBox(height: AppDimens.spaceS),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
          child: _buildProgressSection(
            theme,
            completionPercentage,
            progressSemanticLabel,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildActionButtons(theme),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
    ThemeData theme,
    String completionPercentage,
    String progressSemanticLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Learning Progress', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppDimens.spaceXS),
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
    );
  }

  List<Widget> _buildActionButtons(ThemeData theme) {
    return [
      if (onExportData != null)
        Tooltip(
          message: 'Export learning data',
          child: TextButton.icon(
            onPressed: onExportData,
            icon: const Icon(Icons.download, size: AppDimens.iconS),
            label: const Text('Export'),
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
        ),
      if (onSettingsPressed != null) ...[
        const SizedBox(width: AppDimens.spaceS),
        Tooltip(
          message: 'Settings',
          child: IconButton(
            onPressed: onSettingsPressed,
            icon: const Icon(Icons.settings_outlined, size: AppDimens.iconM),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
      if (onFeedbackPressed != null) ...[
        const SizedBox(width: AppDimens.spaceS),
        Tooltip(
          message: 'Send feedback',
          child: IconButton(
            onPressed: onFeedbackPressed,
            icon: const Icon(Icons.feedback_outlined, size: AppDimens.iconM),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
      if (onHelpPressed != null) ...[
        const SizedBox(width: AppDimens.spaceS),
        Tooltip(
          message: 'Help',
          child: IconButton(
            onPressed: onHelpPressed,
            icon: const Icon(Icons.help_outline, size: AppDimens.iconM),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    ];
  }
}
