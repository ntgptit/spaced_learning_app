// lib/presentation/widgets/modules/grammar/detail/grammar_detail_actions.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

class GrammarDetailActions extends StatefulWidget {
  final VoidCallback? onBackToGrammarList;
  final VoidCallback? onBackToModule;
  final VoidCallback? onStartPractice;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;
  final bool showAnimation;
  final String moduleId;

  const GrammarDetailActions({
    super.key,
    this.onBackToGrammarList,
    this.onBackToModule,
    this.onStartPractice,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
    this.showAnimation = true,
    required this.moduleId,
  });

  @override
  State<GrammarDetailActions> createState() => _GrammarDetailActionsState();
}

class _GrammarDetailActionsState extends State<GrammarDetailActions>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
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
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  Widget _buildNavigationSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.navigation_rounded,
              color: colorScheme.primary,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Navigation Options',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceS),
        Text(
          'Continue exploring grammar rules or return to your module',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimens.spaceL),
        Row(
          children: [
            Expanded(
              child: SLButton(
                text: 'More Grammar',
                type: SLButtonType.outline,
                prefixIcon: Icons.list_alt_rounded,
                onPressed: widget.onBackToGrammarList,
                size: SLButtonSize.medium,
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: SLButton(
                text: 'Back to Module',
                type: SLButtonType.primary,
                prefixIcon: Icons.school_rounded,
                onPressed: widget.onBackToModule,
                size: SLButtonSize.medium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          icon: widget.isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          label: widget.isBookmarked ? 'Bookmarked' : 'Bookmark',
          onPressed: widget.onBookmark,
          colorScheme: colorScheme,
          isActive: widget.isBookmarked,
        ),
        _buildQuickActionButton(
          icon: Icons.share_rounded,
          label: 'Share',
          onPressed: widget.onShare,
          colorScheme: colorScheme,
        ),
        _buildQuickActionButton(
          icon: Icons.school_rounded,
          label: 'Practice',
          onPressed: widget.onStartPractice,
          colorScheme: colorScheme,
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool isActive = false,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimens.avatarSizeL,
                  height: AppDimens.avatarSizeL,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? colorScheme.primary
                        : (isActive
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest),
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    border: Border.all(
                      color: isPrimary
                          ? Colors.transparent
                          : (isActive
                                ? colorScheme.primary.withValues(alpha: 0.5)
                                : colorScheme.outlineVariant),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? colorScheme.onPrimary
                        : (isActive
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant),
                    size: AppDimens.iconM,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isPrimary
                        ? colorScheme.primary
                        : (isActive
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant),
                    fontWeight: isPrimary || isActive
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPracticeButton(ThemeData theme, ColorScheme colorScheme) {
    if (widget.onStartPractice == null) return const SizedBox.shrink();

    return SLButton(
      text: 'Start Practice Session',
      type: SLButtonType.gradient,
      prefixIcon: Icons.play_arrow_rounded,
      onPressed: widget.onStartPractice,
      size: SLButtonSize.large,
      isFullWidth: true,
      customGradient: LinearGradient(
        colors: [colorScheme.primary, colorScheme.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Quick Actions Section
        SLCard(
          type: SLCardType.outlined,
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDimens.spaceL),
              _buildQuickActions(theme, colorScheme),
            ],
          ),
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Navigation Section
        SLCard(
          type: SLCardType.filled,
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainer,
          elevation: AppDimens.elevationXS,
          child: _buildNavigationSection(theme, colorScheme),
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Practice Button
        _buildPracticeButton(theme, colorScheme),
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

// Extension for action variations
extension GrammarDetailActionsVariations on GrammarDetailActions {
  /// Creates a compact version for smaller screens
  static Widget compact({
    required String moduleId,
    VoidCallback? onBackToGrammarList,
    VoidCallback? onBackToModule,
  }) {
    return GrammarDetailActions(
      moduleId: moduleId,
      onBackToGrammarList: onBackToGrammarList,
      onBackToModule: onBackToModule,
      showAnimation: false,
    );
  }

  /// Creates a full-featured version with all actions
  static Widget full({
    required String moduleId,
    VoidCallback? onBackToGrammarList,
    VoidCallback? onBackToModule,
    VoidCallback? onStartPractice,
    VoidCallback? onBookmark,
    VoidCallback? onShare,
    bool isBookmarked = false,
    bool showAnimation = true,
  }) {
    return GrammarDetailActions(
      moduleId: moduleId,
      onBackToGrammarList: onBackToGrammarList,
      onBackToModule: onBackToModule,
      onStartPractice: onStartPractice,
      onBookmark: onBookmark,
      onShare: onShare,
      isBookmarked: isBookmarked,
      showAnimation: showAnimation,
    );
  }
}
