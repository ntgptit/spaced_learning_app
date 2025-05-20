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
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
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

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  // Loads grammar details
  Future<void> _loadData() async {
    await ref
        .read(selectedGrammarProvider.notifier)
        .loadGrammarDetails(widget.grammarId);
  }

  @override
  Widget build(BuildContext context) {
    final grammarAsync = ref.watch(selectedGrammarProvider);

    return Scaffold(
      appBar: AppBarWithBack(
        title: grammarAsync.valueOrNull?.title ?? 'Grammar Rule',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData, // Reloads grammar details
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: grammarAsync.when(
        data: (grammar) {
          // Guard clause for null grammar
          if (grammar == null) {
            return Center(
              child: SLErrorView(
                message: 'Grammar rule not found. It might have been removed.',
                onRetry: _loadData,
              ),
            );
          }

          // Display grammar details
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GrammarHeader(grammar: grammar),
                const SizedBox(height: AppDimens.spaceL),
                GrammarContentSection(grammar: grammar),
                const SizedBox(height: AppDimens.spaceXXL),
                _buildActionButtons(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: SLLoadingIndicator()),
        error: (error, stack) => Center(
          child: SLErrorView(
            message: 'Failed to load grammar details: ${error.toString()}',
            onRetry: _loadData,
          ),
        ),
      ),
    );
  }

  // Builds action buttons for navigation
  Widget _buildActionButtons(BuildContext context) {
    return SLCard(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Continue Learning',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.spaceM),
          Text(
            'Would you like to review more grammar rules or return to the module?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimens.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button to go back to the list of grammars for the current module
              SLButton(
                text: 'More Grammar',
                type: SLButtonType.outline,
                prefixIcon: Icons.list_alt,
                onPressed: () => GoRouter.of(
                  context,
                ).pop(), // Simply pop to go back to grammar list
              ),
              const SizedBox(width: AppDimens.spaceL),
              // Button to go back to the module detail screen
              SLButton(
                text: 'Back to Module',
                type: SLButtonType.primary,
                prefixIcon: Icons.arrow_back,
                // Navigate up two levels: from grammar-detail -> grammar-list -> module-detail
                onPressed: () {
                  // This assumes the grammar list was pushed onto the module detail.
                  // If module detail is not in stack, adjust navigation (e.g., using context.go to specific module path).
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
            ],
          ),
        ],
      ),
    );
  }
}
