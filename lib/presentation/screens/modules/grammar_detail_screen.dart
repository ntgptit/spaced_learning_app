// lib/presentation/screens/modules/grammar_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/grammar_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/grammars/grammar_content_section.dart';
import 'package:spaced_learning_app/presentation/widgets/grammars/grammar_header.dart';

class GrammarDetailScreen extends ConsumerStatefulWidget {
  final String grammarId;
  final String moduleId; // Keep moduleId for navigation context

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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Load data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Loads grammar details
  Future<void> _loadData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await ref
          .read(selectedGrammarProvider.notifier)
          .loadGrammarDetails(widget.grammarId);
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grammarAsync = ref.watch(selectedGrammarProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBarWithBack(
        title: grammarAsync.valueOrNull?.grammarPattern ?? 'Grammar Rule',
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _isRefreshing
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : const Icon(Icons.refresh, key: ValueKey('refresh')),
            ),
            onPressed: _isRefreshing ? null : _loadData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About grammar rules',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: grammarAsync.when(
          data: (grammar) {
            // Guard clause for null grammar
            if (grammar == null) {
              return _buildErrorState(
                context,
                'Grammar rule not found. It might have been removed.',
              );
            }

            // Display grammar details
            return RefreshIndicator(
              onRefresh: _loadData,
              color: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(AppDimens.paddingL),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        GrammarHeader(grammar: grammar),
                        const SizedBox(height: AppDimens.spaceL),
                        GrammarContentSection(grammar: grammar),
                        const SizedBox(height: AppDimens.spaceXXL),
                        _buildActionButtons(context),
                        // Extra space at the bottom for better scrolling experience
                        const SizedBox(height: AppDimens.spaceXXL),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(
            context,
            'Failed to load grammar details: ${error.toString()}',
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  // Loading state with skeleton loader
  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSkeletonHeader(),
              const SizedBox(height: AppDimens.spaceL),
              _buildSkeletonContent(),
            ]),
          ),
        ),
      ],
    );
  }

  // Skeleton loader for header
  Widget _buildSkeletonHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title skeleton
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        // Subtitle skeleton
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 16,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
        ),
        const SizedBox(height: AppDimens.spaceL),
        // Info card skeleton
        Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
          ),
        ),
      ],
    );
  }

  // Skeleton loader for content
  Widget _buildSkeletonContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: List.generate(
        3,
        (index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title skeleton
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Container(
                  width: 120,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),
            // Content skeleton
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),
          ],
        ),
      ),
    );
  }

  // Error state
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: SLErrorView(
          message: message,
          onRetry: _loadData,
          icon: Icons.error_outline_rounded,
        ),
      ),
    );
  }

  // Floating action button
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _startPractice(context),
      icon: const Icon(Icons.school_rounded),
      label: const Text('Practice'),
      elevation: 4,
    );
  }

  // Start practice function (placeholder)
  void _startPractice(BuildContext context) {
    // Here you would navigate to a practice screen or show a modal
    final grammar = ref.read(selectedGrammarProvider).valueOrNull;
    if (grammar == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Practice mode for "${grammar.grammarPattern}" coming soon!',
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  // Show info dialog
  void _showInfoDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: colorScheme.primary),
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
            const SizedBox(height: AppDimens.spaceM),
            _buildInfoItem(
              icon: Icons.format_quote,
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
              icon: Icons.format_list_bulleted,
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
      ),
    );
  }

  // Helper for info dialog items
  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimens.iconS, color: colorScheme.primary),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  // Builds action buttons for navigation
  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SLCard(
      elevation: AppDimens.elevationXS,
      backgroundColor: colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
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
          const SizedBox(height: AppDimens.spaceM),
          Text(
            'Continue exploring grammar rules or return to your module',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Button to go back to the list of grammars for the current module
              Expanded(
                child: SLButton(
                  text: 'More Grammar',
                  type: SLButtonType.outline,
                  prefixIcon: Icons.list_alt,
                  onPressed: () => GoRouter.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppDimens.spaceL),
              // Button to go back to the module detail screen
              Expanded(
                child: SLButton(
                  text: 'Back to Module',
                  type: SLButtonType.primary,
                  prefixIcon: Icons.arrow_back,
                  onPressed: () {
                    // Navigate back to module detail
                    if (GoRouter.of(context).canPop()) {
                      GoRouter.of(context).pop(); // Pop GrammarDetailScreen
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop(); // Pop ModuleGrammarScreen
                      }
                    } else {
                      // Fallback if stack is not as expected
                      GoRouter.of(context).go('/modules/${widget.moduleId}');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
