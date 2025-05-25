// lib/presentation/widgets/modules/grammar/grammar_list_section.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_empty_state.dart';

import 'modern_grammar_list_item.dart';

typedef GrammarItemTapCallback = void Function(String grammarId);

class GrammarListSection extends StatelessWidget {
  final List<GrammarSummary> grammars;
  final GrammarItemTapCallback onGrammarTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;
  final bool isSearchMode;
  final bool isLoading;
  final String? emptySearchMessage;
  final String? emptyDefaultMessage;

  const GrammarListSection({
    super.key,
    required this.grammars,
    required this.onGrammarTap,
    this.onRefresh,
    this.onRetry,
    this.isSearchMode = false,
    this.isLoading = false,
    this.emptySearchMessage,
    this.emptyDefaultMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (grammars.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildGrammarList();
  }

  Widget _buildLoadingState() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      child: SLEmptyState(
        icon: isSearchMode
            ? Icons.search_off_rounded
            : Icons.menu_book_outlined,
        title: isSearchMode
            ? 'No grammar rules found'
            : 'No grammar rules available',
        message: isSearchMode
            ? (emptySearchMessage ??
                  'Try different search terms or clear the search.')
            : (emptyDefaultMessage ??
                  'This module doesn\'t have any grammar rules yet.'),
        buttonText: isSearchMode ? 'Clear Search' : 'Refresh',
        onButtonPressed: isSearchMode ? onRetry : onRefresh,
      ),
    );
  }

  Widget _buildGrammarList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        0,
        AppDimens.paddingL,
        AppDimens.paddingXXL,
      ),
      sliver: SliverList.separated(
        itemCount: grammars.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimens.spaceM),
        itemBuilder: (context, index) {
          final grammar = grammars[index];
          return _buildGrammarItem(grammar, index);
        },
      ),
    );
  }

  Widget _buildGrammarItem(GrammarSummary grammar, int index) {
    return ModernGrammarListItem(
      grammar: grammar,
      onTap: () => onGrammarTap(grammar.id),
      animationDelay: Duration(milliseconds: index * 50),
    );
  }
}

// Extension for better state handling
extension GrammarListSectionExtensions on GrammarListSection {
  /// Creates a refreshable version with RefreshIndicator
  Widget buildWithRefreshIndicator({
    required Future<void> Function() onRefresh,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(slivers: [this]),
    );
  }

  /// Creates version with search results animation
  Widget buildWithSearchAnimation({required AnimationController controller}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeOutQuart,
                  ),
                ),
            child: this,
          ),
        );
      },
    );
  }
}
