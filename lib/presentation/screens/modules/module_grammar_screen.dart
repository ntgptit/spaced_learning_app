// lib/presentation/screens/modules/module_grammar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart'; // Ensure this import is correct
import 'package:spaced_learning_app/presentation/viewmodels/grammar_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_empty_state.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/grammars/grammar_list_item.dart';

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
    // Load data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Loads the initial data for the screen
  Future<void> _loadData() async {
    // Load module details to get module name for the app bar title
    await ref
        .read(selectedModuleProvider.notifier)
        .loadModuleDetails(widget.moduleId);
    // Load grammars for the current module
    await ref
        .read(grammarsStateProvider.notifier)
        .loadGrammarsByModuleId(widget.moduleId);
  }

  // Performs a search or reloads initial data based on query
  void _performSearch(String query) {
    if (query.isEmpty) {
      // If query is empty, stop searching and load initial module grammars
      if (_isSearching) {
        // Only update state if it was previously searching
        setState(() {
          _isSearching = false;
        });
      }
      ref
          .read(grammarsStateProvider.notifier)
          .loadGrammarsByModuleId(widget.moduleId);
      return;
    }

    // If query is not empty, start searching
    if (!_isSearching) {
      // Only update state if it wasn't previously searching
      setState(() {
        _isSearching = true;
      });
    }
    ref.read(grammarsStateProvider.notifier).searchGrammars(query);
  }

  // Navigates to the grammar detail screen
  void _navigateToGrammarDetail(BuildContext context, String grammarId) {
    // Get module details to construct the correct route with bookId
    final module = ref.read(selectedModuleProvider).valueOrNull;
    // Guard clause for null module or bookId
    if (module == null || module.bookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Module information not available')),
      );
      return;
    }
    // Navigate to grammar detail screen
    context.push(
      '/books/${module.bookId}/modules/${widget.moduleId}/grammars/$grammarId',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch module and grammar states
    final moduleAsync = ref.watch(selectedModuleProvider);
    final grammarsAsync = ref.watch(grammarsStateProvider);

    final moduleName = moduleAsync.valueOrNull?.title ?? 'Module';
    final screenTitle = _isSearching ? 'Search Results' : '$moduleName Grammar';

    return Scaffold(
      appBar: AppBarWithBack(
        title: screenTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData, // Reloads initial data
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
                  _buildGrammarList(grammars, theme, colorScheme, context),
              loading: () => const Center(child: SLLoadingIndicator()),
              error: (error, stack) => Center(
                child: SLErrorView(
                  message: error.toString(),
                  onRetry: _loadData, // Retries loading initial data
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the search bar widget
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
                    _performSearch(''); // Clears search and reloads data
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
        onChanged: _performSearch, // Performs search on text change
      ),
    );
  }

  // Builds the list of grammar rules
  Widget _buildGrammarList(
    List<GrammarSummary> grammars,
    ThemeData theme,
    ColorScheme colorScheme,
    BuildContext navContext, // Pass context for navigation
  ) {
    if (grammars.isEmpty) {
      return SLEmptyState(
        icon: _isSearching ? Icons.search_off : Icons.menu_book_outlined,
        title: _isSearching
            ? 'No grammar rules found'
            : 'No grammar rules available',
        message: _isSearching
            ? 'Try different search terms or clear the search.'
            : 'This module doesn\'t have any grammar rules yet. Try refreshing.',
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
            onTap: () => _navigateToGrammarDetail(navContext, grammar.id),
          );
        },
      ),
    );
  }
}
