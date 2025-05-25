// lib/presentation/widgets/grammars/grammar_detail_actions.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

class GrammarDetailActions extends StatefulWidget {
  final String moduleId;
  final VoidCallback? onBackToGrammarList;
  final VoidCallback? onBackToModule;

  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;
  final bool showAnimation;

  const GrammarDetailActions({
    super.key,
    required this.moduleId,
    this.onBackToGrammarList,
    this.onBackToModule,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
    this.showAnimation = true,
  });

  @override
  State<GrammarDetailActions> createState() => _GrammarDetailActionsState();
}

class _GrammarDetailActionsState extends State<GrammarDetailActions>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _staggerController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.showAnimation) {
      _initializeAnimations();
      _startAnimations();
    }
  }

  @override
  void dispose() {
    if (widget.showAnimation) {
      _slideController.dispose();
      _scaleController.dispose();
      _staggerController.dispose();
    }
    super.dispose();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _slideController.forward();
        _staggerController.forward();
      }
    });
  }

  Widget _buildQuickActionsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on_rounded,
              color: colorScheme.primary,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceM),
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        _buildQuickActionGrid(theme, colorScheme),
      ],
    );
  }

  Widget _buildQuickActionGrid(ThemeData theme, ColorScheme colorScheme) {
    final actions = <_QuickAction>[
      _QuickAction(
        icon: widget.isBookmarked
            ? Icons.bookmark_rounded
            : Icons.bookmark_border_rounded,
        label: widget.isBookmarked ? 'Bookmarked' : 'Bookmark',
        onPressed: widget.onBookmark,
        color: colorScheme.secondary,
        isActive: widget.isBookmarked,
      ),
      _QuickAction(
        icon: Icons.share_rounded,
        label: 'Share',
        onPressed: widget.onShare,
        color: colorScheme.tertiary,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;

        return AnimatedBuilder(
          animation: _staggerController,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue = (_staggerController.value - delay).clamp(
              0.0,
              1.0,
            );

            return Transform.translate(
              offset: Offset(0, 20 * (1 - animationValue)),
              child: Opacity(
                opacity: animationValue,
                child: _buildQuickActionButton(action, theme, colorScheme),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionButton(
    _QuickAction action,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: action.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimens.avatarSizeXL,
                  height: AppDimens.avatarSizeXL,
                  decoration: BoxDecoration(
                    gradient: action.isPrimary
                        ? LinearGradient(
                            colors: [
                              action.color,
                              action.color.withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color: action.isPrimary
                        ? null
                        : (action.isActive
                              ? action.color.withValues(alpha: 0.15)
                              : colorScheme.surfaceContainerHighest),
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    border: Border.all(
                      color: action.isPrimary
                          ? Colors.transparent
                          : (action.isActive
                                ? action.color.withValues(alpha: 0.4)
                                : colorScheme.outlineVariant),
                      width: 1.5,
                    ),
                    boxShadow: action.isPrimary
                        ? [
                            BoxShadow(
                              color: action.color.withValues(alpha: 0.3),
                              blurRadius: AppDimens.shadowRadiusM,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    action.icon,
                    color: action.isPrimary
                        ? colorScheme.onPrimary
                        : (action.isActive
                              ? action.color
                              : colorScheme.onSurfaceVariant),
                    size: AppDimens.iconL,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceM),
                Text(
                  action.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: action.isPrimary || action.isActive
                        ? action.color
                        : colorScheme.onSurfaceVariant,
                    fontWeight: action.isPrimary || action.isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.navigation_rounded,
              color: colorScheme.secondary,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceM),
            Text(
              'Continue Learning',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        Text(
          'Explore more grammar rules or return to your module to continue your learning journey.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),
        _buildNavigationButtons(theme, colorScheme),
      ],
    );
  }

  Widget _buildNavigationButtons(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SLButton(
                text: 'More Grammar',
                type: SLButtonType.outline,
                prefixIcon: Icons.list_alt_rounded,
                onPressed: widget.onBackToGrammarList,
                size: SLButtonSize.large,
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: SLButton(
                text: 'Back to Module',
                type: SLButtonType.secondary,
                prefixIcon: Icons.arrow_back_rounded,
                onPressed: widget.onBackToModule,
                size: SLButtonSize.large,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Quick Actions Card
        SLCard(
          type: SLCardType.filled,
          padding: const EdgeInsets.all(AppDimens.paddingXL),
          backgroundColor: colorScheme.surfaceContainer,
          elevation: AppDimens.elevationS,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: _buildQuickActionsSection(theme, colorScheme),
        ),

        const SizedBox(height: AppDimens.spaceXXL),

        // Navigation Card
        SLCard(
          type: SLCardType.outlined,
          padding: const EdgeInsets.all(AppDimens.paddingXL),
          backgroundColor: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            side: BorderSide(
              color: colorScheme.secondary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: _buildNavigationSection(theme, colorScheme),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!widget.showAnimation) {
      return _buildContent(theme, colorScheme);
    }

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContent(theme, colorScheme),
          ),
        );
      },
    );
  }
}

// Helper class for quick actions
class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool isActive;
  final bool isPrimary;

  const _QuickAction({
    required this.icon,
    required this.label,
    this.onPressed,
    required this.color,
    this.isActive = false,
    this.isPrimary = false,
  });
}
