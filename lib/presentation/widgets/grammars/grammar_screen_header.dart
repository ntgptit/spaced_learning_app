// lib/presentation/widgets/modules/grammar/grammar_screen_header.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

class GrammarScreenHeader extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? moduleName;
  final int grammarCount;
  final bool isSearchMode;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  const GrammarScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.moduleName,
    this.grammarCount = 0,
    this.isSearchMode = false,
    this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  State<GrammarScreenHeader> createState() => _GrammarScreenHeaderState();
}

class _GrammarScreenHeaderState extends State<GrammarScreenHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  Widget _buildHeaderIcon(ColorScheme colorScheme) {
    return Container(
      width: AppDimens.avatarSizeXL,
      height: AppDimens.avatarSizeXL,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: AppDimens.shadowRadiusL,
            offset: const Offset(0, AppDimens.shadowOffsetM),
          ),
        ],
      ),
      child: Icon(
        widget.isSearchMode ? Icons.search_rounded : Icons.auto_stories_rounded,
        color: colorScheme.onPrimary,
        size: AppDimens.iconXL,
      ),
    );
  }

  Widget _buildHeaderContent(ThemeData theme, ColorScheme colorScheme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: AppDimens.spaceXS),
            Text(
              widget.subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (widget.moduleName != null) ...[
            const SizedBox(height: AppDimens.spaceS),
            _buildModuleBadge(theme, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingM,
        vertical: AppDimens.paddingXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.book_outlined,
            size: AppDimens.iconXS,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            widget.moduleName!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ColorScheme colorScheme) {
    if (widget.onRefresh == null) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: widget.isRefreshing
          ? SizedBox(
              width: AppDimens.iconL,
              height: AppDimens.iconL,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            )
          : IconButton(
              key: const ValueKey('refresh-button'),
              onPressed: widget.onRefresh,
              icon: Icon(
                Icons.refresh_rounded,
                color: colorScheme.primary,
                size: AppDimens.iconL,
              ),
              tooltip: 'Refresh grammar list',
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                padding: const EdgeInsets.all(AppDimens.paddingM),
              ),
            ),
    );
  }

  Widget _buildStatsInfo(ThemeData theme, ColorScheme colorScheme) {
    if (widget.grammarCount == 0) return const SizedBox.shrink();

    return SLCard(
      type: SLCardType.filled,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
      margin: const EdgeInsets.only(top: AppDimens.spaceL),
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.8,
      ),
      child: Row(
        children: [
          Icon(
            Icons.rule_rounded,
            color: colorScheme.primary,
            size: AppDimens.iconM,
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.grammarCount} Grammar ${widget.grammarCount == 1 ? 'Rule' : 'Rules'}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  widget.isSearchMode
                      ? 'Search results'
                      : 'Available for learning',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildHeaderIcon(colorScheme),
                      const SizedBox(width: AppDimens.spaceL),
                      _buildHeaderContent(theme, colorScheme),
                      const SizedBox(width: AppDimens.spaceM),
                      _buildActionButton(colorScheme),
                    ],
                  ),
                  _buildStatsInfo(theme, colorScheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Extension for header variations
extension GrammarScreenHeaderVariations on GrammarScreenHeader {
  /// Creates a compact version for smaller screens
  static Widget compact({
    required String title,
    String? moduleName,
    int grammarCount = 0,
    VoidCallback? onRefresh,
    bool isRefreshing = false,
  }) {
    return GrammarScreenHeader(
      title: title,
      moduleName: moduleName,
      grammarCount: grammarCount,
      onRefresh: onRefresh,
      isRefreshing: isRefreshing,
    );
  }

  /// Creates a search results version
  static Widget searchResults({
    required String title,
    required int resultsCount,
    VoidCallback? onRefresh,
  }) {
    return GrammarScreenHeader(
      title: title,
      subtitle:
          'Found $resultsCount ${resultsCount == 1 ? 'result' : 'results'}',
      grammarCount: resultsCount,
      isSearchMode: true,
      onRefresh: onRefresh,
    );
  }
}
