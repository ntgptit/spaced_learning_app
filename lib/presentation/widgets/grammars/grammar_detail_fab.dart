// lib/presentation/widgets/modules/grammar/detail/grammar_detail_fab.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';

class GrammarDetailFAB extends StatefulWidget {
  final GrammarDetail grammar;
  final VoidCallback? onPracticePressed;
  final VoidCallback? onBookmarkPressed;
  final bool isBookmarked;
  final bool showAnimation;
  final bool isExtended;

  const GrammarDetailFAB({
    super.key,
    required this.grammar,
    this.onPracticePressed,
    this.onBookmarkPressed,
    this.isBookmarked = false,
    this.showAnimation = true,
    this.isExtended = true,
  });

  @override
  State<GrammarDetailFAB> createState() => _GrammarDetailFABState();
}

class _GrammarDetailFABState extends State<GrammarDetailFAB>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _rotationController;
  late AnimationController _expandController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _expandAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.showAnimation) {
      _startEntryAnimation();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _rotationController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeOutCubic),
    );
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _rotationController.forward();
      _expandController.forward();
    } else {
      _rotationController.reverse();
      _expandController.reverse();
    }
  }

  Widget _buildMainFAB(ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: widget.isExtended
          ? widget.onPracticePressed
          : _toggleExpansion,
      heroTag: 'grammar_practice_fab',
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: AppDimens.elevationL,
      icon: widget.isExtended
          ? const Icon(Icons.school_rounded)
          : AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14159,
            child: Icon(
              _isExpanded ? Icons.close_rounded : Icons.more_vert_rounded,
            ),
          );
        },
      ),
      label: widget.isExtended ? const Text('Practice') : const Text('Actions'),
    );
  }

  Widget _buildSecondaryFAB({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool isActive = false,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: 'grammar_${tooltip.toLowerCase()}_fab',
      backgroundColor: isActive
          ? colorScheme.primaryContainer
          : colorScheme.secondaryContainer,
      foregroundColor: isActive
          ? colorScheme.onPrimaryContainer
          : colorScheme.onSecondaryContainer,
      elevation: AppDimens.elevationM,
      mini: true,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }

  Widget _buildExpandedActions(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bookmark FAB
        if (widget.onBookmarkPressed != null) ...[
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _expandAnimation.value,
                child: Opacity(
                  opacity: _expandAnimation.value,
                  child: _buildSecondaryFAB(
                    icon: widget.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    tooltip: widget.isBookmarked
                        ? 'Remove Bookmark'
                        : 'Bookmark',
                    onPressed: widget.onBookmarkPressed,
                    colorScheme: colorScheme,
                    isActive: widget.isBookmarked,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimens.spaceM),
        ],

        // Practice FAB
        if (widget.onPracticePressed != null) ...[
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _expandAnimation.value,
                child: Opacity(
                  opacity: _expandAnimation.value,
                  child: _buildSecondaryFAB(
                    icon: Icons.school_rounded,
                    tooltip: 'Practice Grammar',
                    onPressed: widget.onPracticePressed,
                    colorScheme: colorScheme,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimens.spaceM),
        ],
      ],
    );
  }

  Widget _buildFABContent(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isExtended && _isExpanded)
          _buildExpandedActions(colorScheme),
        _buildMainFAB(colorScheme),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    if (!widget.showAnimation) {
      return _buildFABContent(colorScheme);
    }

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildFABContent(colorScheme),
          ),
        );
      },
    );
  }
}

// Custom FAB Speed Dial for Grammar Actions
class GrammarFABSpeedDial extends StatefulWidget {
  final GrammarDetail grammar;
  final List<GrammarFABAction> actions;
  final bool showAnimation;

  const GrammarFABSpeedDial({
    super.key,
    required this.grammar,
    required this.actions,
    this.showAnimation = true,
  });

  @override
  State<GrammarFABSpeedDial> createState() => _GrammarFABSpeedDialState();
}

class _GrammarFABSpeedDialState extends State<GrammarFABSpeedDial>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget _buildActionButton(GrammarFABAction action, int index) {
    return ScaleTransition(
      scale: _expandAnimation,
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimens.spaceM + (index * 8)),
        child: FloatingActionButton(
          heroTag: 'grammar_action_${action.label}',
          onPressed: () {
            action.onPressed();
            _toggle();
          },
          backgroundColor: action.backgroundColor,
          foregroundColor: action.foregroundColor,
          mini: true,
          tooltip: action.label,
          child: Icon(action.icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.actions
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final action = entry.value;
          return _buildActionButton(action, index);
        }),
        FloatingActionButton(
          heroTag: 'grammar_main_fab',
          onPressed: _toggle,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 3.14159,
                child: Icon(
                  _isExpanded ? Icons.close_rounded : Icons.school_rounded,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Grammar FAB Action Model
class GrammarFABAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GrammarFABAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });
}

// Extension for FAB variations
extension GrammarDetailFABVariations on GrammarDetailFAB {
  /// Creates a simple practice-only FAB
  static Widget practiceOnly({
    required GrammarDetail grammar,
    required VoidCallback onPracticePressed,
    bool showAnimation = true,
  }) {
    return GrammarDetailFAB(
      grammar: grammar,
      onPracticePressed: onPracticePressed,
      showAnimation: showAnimation,
      isExtended: true,
    );
  }

  /// Creates a multi-action FAB
  static Widget multiAction({
    required GrammarDetail grammar,
    VoidCallback? onPracticePressed,
    VoidCallback? onBookmarkPressed,
    bool isBookmarked = false,
    bool showAnimation = true,
  }) {
    return GrammarDetailFAB(
      grammar: grammar,
      onPracticePressed: onPracticePressed,
      onBookmarkPressed: onBookmarkPressed,
      isBookmarked: isBookmarked,
      showAnimation: showAnimation,
      isExtended: false,
    );
  }
}
