// lib/presentation/widgets/modules/grammar/modern_grammar_list_item.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

class ModernGrammarListItem extends StatefulWidget {
  final GrammarSummary grammar;
  final VoidCallback onTap;
  final Duration animationDelay;
  final bool showModuleName;

  const ModernGrammarListItem({
    super.key,
    required this.grammar,
    required this.onTap,
    this.animationDelay = Duration.zero,
    this.showModuleName = true,
  });

  @override
  State<ModernGrammarListItem> createState() => _ModernGrammarListItemState();
}

class _ModernGrammarListItemState extends State<ModernGrammarListItem>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  void _startEntryAnimation() {
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  Widget _buildGrammarIcon(ColorScheme colorScheme) {
    return Container(
      width: AppDimens.avatarSizeL,
      height: AppDimens.avatarSizeL,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.secondaryContainer,
            colorScheme.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: AppDimens.shadowRadiusM,
            offset: const Offset(0, AppDimens.shadowOffsetS),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_stories_rounded,
        color: colorScheme.onSecondaryContainer,
        size: AppDimens.iconL,
      ),
    );
  }

  Widget _buildGrammarContent(ThemeData theme, ColorScheme colorScheme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.grammar.grammarPattern,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.showModuleName &&
              widget.grammar.moduleName != null &&
              widget.grammar.moduleName!.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceXS),
            Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: AppDimens.iconXS,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Expanded(
                  child: Text(
                    widget.grammar.moduleName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionIndicator(ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(AppDimens.paddingS),
      decoration: BoxDecoration(
        color: _isPressed
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: AppDimens.iconS,
        color: _isPressed ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _scaleController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: widget.onTap,
                child: SLCard(
                  type: SLCardType.filled,
                  padding: const EdgeInsets.all(AppDimens.paddingL),
                  margin: EdgeInsets.zero,
                  backgroundColor: colorScheme.surfaceContainerLowest,
                  elevation: _isPressed
                      ? AppDimens.elevationM
                      : AppDimens.elevationXS,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    side: BorderSide(
                      color: _isPressed
                          ? colorScheme.primary.withValues(alpha: 0.3)
                          : colorScheme.outlineVariant.withValues(alpha: 0.5),
                      width: _isPressed ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildGrammarIcon(colorScheme),
                      const SizedBox(width: AppDimens.spaceL),
                      _buildGrammarContent(theme, colorScheme),
                      const SizedBox(width: AppDimens.spaceM),
                      _buildActionIndicator(colorScheme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Extension for grammar list item variations
extension ModernGrammarListItemVariations on ModernGrammarListItem {
  /// Creates a compact version for smaller screens
  static Widget compact({
    required GrammarSummary grammar,
    required VoidCallback onTap,
  }) {
    return ModernGrammarListItem(
      grammar: grammar,
      onTap: onTap,
      showModuleName: false,
    );
  }

  /// Creates a detailed version with extra information
  static Widget detailed({
    required GrammarSummary grammar,
    required VoidCallback onTap,
    Duration animationDelay = Duration.zero,
  }) {
    return ModernGrammarListItem(
      grammar: grammar,
      onTap: onTap,
      animationDelay: animationDelay,
      showModuleName: true,
    );
  }
}
