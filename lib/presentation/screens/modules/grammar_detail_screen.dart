// lib/presentation/screens/modules/grammar_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/grammar_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/grammar/detail/grammar_detail_actions.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/grammar/detail/grammar_detail_content.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/grammar/detail/grammar_detail_fab.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/grammar/detail/grammar_detail_header.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/grammar/detail/grammar_loading_skeleton.dart';

import '../../widgets/grammars/grammar_detail_actions.dart';
import '../../widgets/grammars/grammar_detail_content.dart';
import '../../widgets/grammars/grammar_detail_fab.dart';
import '../../widgets/grammars/grammar_detail_header.dart';

class GrammarDetailScreen extends ConsumerStatefulWidget {
  final String grammarId;
  final String moduleId;

  const GrammarDetailScreen({
    super.key,
    required this.grammarId,
    required this.moduleId,
  });

  @override
  ConsumerState<GrammarDetailScreen> createState() =>
      _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _performDataLoad();
      if (mounted) {
        _fadeController.forward();
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          _slideController.forward();
        }
      }
    });
  }

  Future<void> _performDataLoad() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      await ref
          .read(selectedGrammarProvider.notifier)
          .loadGrammarDetails(widget.grammarId);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _performDataLoad();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Grammar rule refreshed'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      );
    }
  }

  void _showInfoDialog() {
    showDialog(context: context, builder: (context) => _buildInfoDialog());
  }

  @override
  Widget build(BuildContext context) {
    final grammarAsync = ref.watch(selectedGrammarProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(grammarAsync.valueOrNull?.grammarPattern),
      body: grammarAsync.when(
        data: (grammar) => _buildGrammarContent(grammar),
        loading: () => const GrammarLoadingSkeleton(),
        error: (error, stack) => _buildErrorContent(error),
      ),
      floatingActionButton: grammarAsync.maybeWhen(
        data: (grammar) => grammar != null ? const GrammarDetailFAB() : null,
        orElse: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(String? grammarPattern) {
    return AppBarWithBack(
      title: grammarPattern ?? 'Grammar Rule',
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isRefreshing
              ? const Padding(
                  padding: EdgeInsets.all(AppDimens.paddingM),
                  child: SizedBox(
                    width: AppDimens.iconM,
                    height: AppDimens.iconM,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  key: const ValueKey('refresh'),
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _handleRefresh,
                  tooltip: 'Refresh',
                ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: _showInfoDialog,
          tooltip: 'About grammar rules',
        ),
      ],
    );
  }

  Widget _buildGrammarContent(grammar) {
    if (grammar == null) {
      return _buildErrorContent(
        'Grammar rule not found. It might have been removed.',
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    GrammarDetailHeader(grammar: grammar),
                    const SizedBox(height: AppDimens.spaceXL),
                    GrammarDetailContent(grammar: grammar),
                    const SizedBox(height: AppDimens.spaceXXL),
                    GrammarDetailActions(
                      moduleId: widget.moduleId,
                      onNavigateBack: () => _navigateBack(),
                    ),
                    const SizedBox(height: AppDimens.spaceXXXL),
                    // Extra space for FAB
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: SLErrorView(
          message: 'Failed to load grammar details: ${error.toString()}',
          onRetry: _handleRefresh,
          icon: Icons.error_outline_rounded,
        ),
      ),
    );
  }

  Widget _buildInfoDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      title: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: colorScheme.primary),
          const SizedBox(width: AppDimens.spaceM),
          const Text('About Grammar Rules'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grammar rules are essential patterns that help structure language. Each rule consists of:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimens.spaceL),
          _buildInfoItem(
            icon: Icons.format_quote_rounded,
            text: 'Pattern - The basic form of the rule',
            theme: theme,
            colorScheme: colorScheme,
          ),
          _buildInfoItem(
            icon: Icons.article_outlined,
            text: 'Definition - What the rule means',
            theme: theme,
            colorScheme: colorScheme,
          ),
          _buildInfoItem(
            icon: Icons.architecture_outlined,
            text: 'Structure - How to form the pattern',
            theme: theme,
            colorScheme: colorScheme,
          ),
          _buildInfoItem(
            icon: Icons.format_list_bulleted_rounded,
            text: 'Examples - How the rule is used',
            theme: theme,
            colorScheme: colorScheme,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: TextStyle(color: colorScheme.primary)),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimens.iconS, color: colorScheme.primary),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  void _navigateBack() {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
      if (GoRouter.of(context).canPop()) {
        GoRouter.of(context).pop();
      }
      return;
    }

    // Fallback navigation
    GoRouter.of(context).go('/modules/${widget.moduleId}');
  }
}
