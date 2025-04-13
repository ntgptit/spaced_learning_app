import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/footer_actions_section.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/footer_progress_section.dart';

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
    final isSmallScreen = size.width < 600; // AppDimens.breakpointS

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
                    ? _buildSmallScreenLayout()
                    : _buildWideScreenLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FooterProgressSection(
          totalModules: totalModules,
          completedModules: completedModules,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FooterActionsSection(
            onExportData: onExportData,
            onHelpPressed: onHelpPressed,
            onSettingsPressed: onSettingsPressed,
            onFeedbackPressed: onFeedbackPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      children: [
        Expanded(
          child: FooterProgressSection(
            totalModules: totalModules,
            completedModules: completedModules,
          ),
        ),
        FooterActionsSection(
          onExportData: onExportData,
          onHelpPressed: onHelpPressed,
          onSettingsPressed: onSettingsPressed,
          onFeedbackPressed: onFeedbackPressed,
        ),
      ],
    );
  }
}
