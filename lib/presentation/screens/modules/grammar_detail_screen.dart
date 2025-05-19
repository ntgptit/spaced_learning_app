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

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await ref
        .read(selectedGrammarProvider.notifier)
        .loadGrammarDetails(widget.grammarId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final grammarAsync = ref.watch(selectedGrammarProvider);

    return Scaffold(
      appBar: AppBarWithBack(
        title: grammarAsync.valueOrNull?.title ?? 'Grammar Rule',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: grammarAsync.when(
        data: (grammar) {
          if (grammar == null) {
            return Center(
              child: SLErrorView(
                message: 'Grammar rule not found',
                onRetry: _loadData,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GrammarHeader(grammar: grammar),
                GrammarContentSection(grammar: grammar),
                const SizedBox(height: AppDimens.spaceXXL),
                _buildActionButtons(context, colorScheme),
              ],
            ),
          );
        },
        loading: () => const Center(child: SLLoadingIndicator()),
        error: (error, stack) => Center(
          child: SLErrorView(message: error.toString(), onRetry: _loadData),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
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
              SLButton(
                text: 'Module',
                type: SLButtonType.outline,
                prefixIcon: Icons.book,
                onPressed: () =>
                    context.go('/modules/${widget.moduleId}/grammar'),
              ),
              const SizedBox(width: AppDimens.spaceL),
              SLButton(
                text: 'Back to Module',
                type: SLButtonType.primary,
                prefixIcon: Icons.arrow_back,
                onPressed: () => context.go('/books'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
