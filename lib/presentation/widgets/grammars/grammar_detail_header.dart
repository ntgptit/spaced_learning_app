// lib/presentation/widgets/modules/grammar/detail/grammar_detail_header.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

class GrammarDetailHeader extends StatefulWidget {
  final GrammarDetail grammar;
  final bool showAnimation;

  const GrammarDetailHeader({
    super.key,
    required this.grammar,
    this.showAnimation = true,
  });

  @override
  State<GrammarDetailHeader> createState() => _GrammarDetailHeaderState();
}

class _GrammarDetailHeaderState extends State<GrammarDetailHeader>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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
      _fadeController.dispose();
    }
    super.dispose();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  void _startAnimations() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeController.forward();
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _slideController.forward();
          }
        });
      }
    });
  }

  Widget _buildGrammarIcon(ColorScheme colorScheme) {
    return Container(
      width: AppDimens.avatarSizeXL + 8,
      height: AppDimens.avatarSizeXL + 8,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: AppDimens.shadowRadiusL,
            offset: const Offset(0, AppDimens.shadowOffsetM),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_stories_rounded,
        color: colorScheme.onPrimary,
        size: AppDimens.iconXXL,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.grammar.grammarPattern,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
            height: 1.1,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.grammar.moduleName != null &&
            widget.grammar.moduleName!.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceS),
          _buildModuleInfo(theme, colorScheme),
        ],
      ],
    );
  }

  Widget _buildModuleInfo(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingM,
        vertical: AppDimens.paddingXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_rounded,
            size: AppDimens.iconS,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            'Module: ${widget.grammar.moduleName}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, ColorScheme colorScheme) {
    return SLCard(
      type: SLCardType.filled,
      padding: const EdgeInsets.all(AppDimens.paddingL),
      backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
      elevation: AppDimens.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: colorScheme.onPrimaryContainer,
              size: AppDimens.iconM,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grammar Learning Tip',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  'Understanding this grammar pattern will enhance your communication skills and comprehension. Practice with the examples below.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGrammarIcon(colorScheme),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(child: _buildTitle(theme, colorScheme)),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXL),
        _buildInfoCard(theme, colorScheme),
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
      animation: Listenable.merge([_slideController, _fadeController]),
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

// Extension for header variations
extension GrammarDetailHeaderVariations on GrammarDetailHeader {
  /// Creates a static version without animations
  static Widget static(GrammarDetail grammar) {
    return GrammarDetailHeader(grammar: grammar, showAnimation: false);
  }

  /// Creates an animated version with custom delay
  static Widget animated(GrammarDetail grammar, {bool showAnimation = true}) {
    return GrammarDetailHeader(grammar: grammar, showAnimation: showAnimation);
  }
}
