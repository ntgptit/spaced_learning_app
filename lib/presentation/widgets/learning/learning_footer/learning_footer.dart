import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/footer_actions_section.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/footer_progress_section.dart';

class LearningFooter extends StatefulWidget {
  final int totalModules;
  final int completedModules;
  final VoidCallback? onHelpPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onFeedbackPressed;

  const LearningFooter({
    super.key,
    required this.totalModules,
    required this.completedModules,
    this.onHelpPressed,
    this.onSettingsPressed,
    this.onFeedbackPressed,
  });

  @override
  State<LearningFooter> createState() => _LearningFooterState();
}

class _LearningFooterState extends State<LearningFooter> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
          // Drag handle
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Optional: arrow indicator
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            curve: Curves.easeInOut,
            child: ClipRect(
              child: Visibility(
                visible: _isExpanded,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child:
                      isSmallScreen
                          ? _buildSmallScreenLayout()
                          : _buildWideScreenLayout(),
                ),
              ),
            ),
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
          totalModules: widget.totalModules,
          completedModules: widget.completedModules,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FooterActionsSection(
            onHelpPressed: widget.onHelpPressed,
            onSettingsPressed: widget.onSettingsPressed,
            onFeedbackPressed: widget.onFeedbackPressed,
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
            totalModules: widget.totalModules,
            completedModules: widget.completedModules,
          ),
        ),
        FooterActionsSection(
          onHelpPressed: widget.onHelpPressed,
          onSettingsPressed: widget.onSettingsPressed,
          onFeedbackPressed: widget.onFeedbackPressed,
        ),
      ],
    );
  }
}
