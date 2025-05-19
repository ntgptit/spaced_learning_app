import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/grammar_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_empty_state.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/grammars/grammar_list_item.dart';

import '../../../domain/models/grammar.dart';

class ModuleGrammarScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const ModuleGrammarScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleGrammarScreen> createState() =>
      _ModuleGrammarScreenState();
}

class _ModuleGrammarScreenState extends ConsumerState<ModuleGrammarScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await ref
        .read(selectedModuleProvider.notifier)
        .loadModuleDetails(widget.moduleId);
    await ref
        .read(grammarsStateProvider.notifier)
        .loadGrammarsByModuleId(widget.moduleId);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      ref
          .read(grammarsStateProvider.notifier)
          .loadGrammarsByModuleId(widget.moduleId);
      return;
    }

    setState(() {
      _isSearching = true;
    });
    ref.read(grammarsStateProvider.notifier).searchGrammars(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final moduleAsync = ref.watch(selectedModuleProvider);
    final grammarsAsync = ref.watch(grammarsStateProvider);

    final moduleName = moduleAsync.valueOrNull?.title ?? 'Module';
    final screenTitle = _isSearching ? 'Search Grammar' : '$moduleName Grammar';

    return Scaffold(
      appBar: AppBarWithBack(
        title: screenTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(theme, colorScheme),
          Expanded(
            child: grammarsAsync.when(
              data: (grammars) =>
                  _buildGrammarList(grammars, theme, colorScheme),
              loading: () => const Center(child: SLLoadingIndicator()),
              error: (error, stack) => Center(
                child: SLErrorView(
                  message: error.toString(),
                  onRetry: _loadData,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search grammar rules...',
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildGrammarList(
    List<GrammarSummary> grammars,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (grammars.isEmpty) {
      return SLEmptyState(
        icon: _isSearching ? Icons.search_off : Icons.menu_book_outlined,
        title: _isSearching
            ? 'No grammar rules found'
            : 'No grammar rules available',
        message: _isSearching
            ? 'Try different search terms'
            : 'This module doesn\'t have any grammar rules yet',
        buttonText: _isSearching ? 'Clear Search' : 'Refresh',
        onButtonPressed: _isSearching
            ? () {
                _searchController.clear();
                _performSearch('');
              }
            : _loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        itemCount: grammars.length,
        itemBuilder: (context, index) {
          final grammar = grammars[index];
          return GrammarListItem(
            grammar: grammar,
            onTap: () => context.push(
              '/modules/${widget.moduleId}/grammars/${grammar.id}',
            ),
          );
        },
      ),
    );
  }
}
