// lib/presentation/screens/modules/module_grammar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/viewmodels/grammar_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_empty_state.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import '../../widgets/grammars/grammar_list_section.dart';
import '../../widgets/grammars/grammar_screen_header.dart';
import '../../widgets/grammars/grammar_search_bar.dart';

class ModuleGrammarScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const ModuleGrammarScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleGrammarScreen> createState() =>
      _ModuleGrammarScreenState();
}

class _ModuleGrammarScreenState extends ConsumerState<ModuleGrammarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      _animationController.forward();
    });
  }

  Future<void> _loadInitialData() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      await Future.wait([
        ref
            .read(selectedModuleProvider.notifier)
            .loadModuleDetails(widget.moduleId),
        ref
            .read(grammarsStateProvider.notifier)
            .loadGrammarsByModuleId(widget.moduleId),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _handleSearch(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      if (_isSearching) {
        setState(() => _isSearching = false);
        ref
            .read(grammarsStateProvider.notifier)
            .loadGrammarsByModuleId(widget.moduleId);
      }
      return;
    }

    if (!_isSearching) {
      setState(() => _isSearching = true);
    }

    ref.read(grammarsStateProvider.notifier).searchGrammars(trimmedQuery);
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    _handleSearch('');
  }

  void _navigateToGrammarDetail(String grammarId) {
    final module = ref.read(selectedModuleProvider).valueOrNull;

    if (module?.bookId.isEmpty ?? true) {
      _showErrorSnackBar('Module information not available');
      return;
    }

    context.push(
      '/books/${module!.bookId}/modules/${widget.moduleId}/grammars/$grammarId',
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moduleAsync = ref.watch(selectedModuleProvider);
    final grammarsAsync = ref.watch(grammarsStateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(moduleAsync.valueOrNull?.title),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildSearchSection(),
              Expanded(child: _buildContentSection(grammarsAsync)),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String? moduleTitle) {
    final screenTitle = _isSearching
        ? 'Search Results'
        : '${moduleTitle ?? 'Module'} Grammar';

    return AppBarWithBack(
      title: screenTitle,
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
                  onPressed: _loadInitialData,
                  tooltip: 'Refresh',
                ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: AppDimens.elevationS,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: GrammarSearchBar(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _handleSearch,
        onClear: _clearSearch,
        isSearching: _isSearching,
      ),
    );
  }

  Widget _buildContentSection(AsyncValue<List<GrammarSummary>> grammarsAsync) {
    return grammarsAsync.when(
      data: (grammars) => _buildGrammarContent(grammars),
      loading: () => const Center(
        child: SLLoadingIndicator(
          type: LoadingIndicatorType.fadingCircle,
          size: AppDimens.circularProgressSizeL,
        ),
      ),
      error: (error, stack) => Center(
        child: SLErrorView(
          message: 'Failed to load grammar rules: ${error.toString()}',
          onRetry: _loadInitialData,
          icon: Icons.menu_book_outlined,
        ),
      ),
    );
  }

  Widget _buildGrammarContent(List<GrammarSummary> grammars) {
    if (grammars.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: GrammarScreenHeader(
              totalCount: grammars.length,
              isSearching: _isSearching,
              searchQuery: _searchController.text.trim(),
            ),
          ),
          GrammarListSection(
            grammars: grammars,
            onGrammarTap: _navigateToGrammarDetail,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppDimens.spaceXXL)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SLEmptyState(
      icon: _isSearching ? Icons.search_off_rounded : Icons.menu_book_outlined,
      title: _isSearching
          ? 'No grammar rules found'
          : 'No grammar rules available',
      message: _isSearching
          ? 'Try different search terms or clear the search to see all rules.'
          : 'This module doesn\'t have any grammar rules yet. Try refreshing or check back later.',
      buttonText: _isSearching ? 'Clear Search' : 'Refresh',
      onButtonPressed: _isSearching ? _clearSearch : _loadInitialData,
    );
  }
}
