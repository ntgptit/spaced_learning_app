import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_filter_panel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/common_book.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  String? _selectedCategory;
  List<String> _categories = [];
  BookStatus? _selectedStatus;
  DifficultyLevel? _selectedDifficulty;
  bool _isFilterExpanded = false;
  bool _isScrolled = false;

  // Animation controllers
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());

    // Initialize animations
    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );

    // Listen to scroll to handle app bar elevation
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 0;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final bookViewModel = context.read<BookViewModel>();
    try {
      await bookViewModel.loadCategories();
      if (mounted) {
        setState(() {
          _categories = bookViewModel.categories;
        });
      }
      await bookViewModel.loadBooks();
    } catch (e) {
      final errorMessage =
          e is AppException
              ? e.message
              : 'An unexpected error occurred while loading data. Please try again.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            margin: const EdgeInsets.all(AppDimens.paddingL),
          ),
        );
      }
    }
  }

  void _applyFilters() {
    context.read<BookViewModel>().filterBooks(
      status: _selectedStatus,
      difficultyLevel: _selectedDifficulty,
      category: _selectedCategory,
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedStatus = null;
      _selectedDifficulty = null;
    });
    context.read<BookViewModel>().loadBooks();
  }

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return _loadData();
    }
    setState(() {
      _isSearching = true;
    });
    await context.read<BookViewModel>().searchBooks(query);
  }

  void _toggleFilterPanel() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });

    if (_isFilterExpanded) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final bookViewModel = context.watch<BookViewModel>();
    final isSmallScreen = mediaQuery.size.width < AppDimens.breakpointS;

    if (authViewModel.currentUser == null) {
      return _buildLoginPrompt(theme);
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              _buildAppBar(theme, colorScheme, innerBoxIsScrolled),
            ],
        body: Column(
          children: [
            _buildSearchAndFilterBar(theme, colorScheme, isSmallScreen),

            // Filter panel - Animated
            AnimatedBuilder(
              animation: _filterAnimation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _filterAnimation,
                  child: child,
                );
              },
              child:
                  _isFilterExpanded
                      ? BookFilterPanel(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        selectedStatus: _selectedStatus,
                        selectedDifficulty: _selectedDifficulty,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _applyFilters();
                        },
                        onStatusSelected: (status) {
                          setState(() {
                            _selectedStatus = status;
                          });
                          _applyFilters();
                        },
                        onDifficultySelected: (difficulty) {
                          setState(() {
                            _selectedDifficulty = difficulty;
                          });
                          _applyFilters();
                        },
                        onFiltersApplied: () {
                          _applyFilters();
                          _toggleFilterPanel();
                        },
                        onFilterCleared: _resetFilters,
                      )
                      : const SizedBox.shrink(),
            ),

            // Book list
            Expanded(
              child: _buildBooksList(
                bookViewModel,
                theme,
                _isSearching ? 'Search results' : 'Books Library',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          authViewModel.currentUser?.roles?.contains('ADMIN') == true
              ? FloatingActionButton.extended(
                onPressed: () => GoRouter.of(context).push('/books/create'),
                label: const Text('Add Book'),
                icon: const Icon(Icons.add),
                elevation: 4,
              )
              : null,
    );
  }

  Widget _buildLoginPrompt(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: AppDimens.iconXXL,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'Please log in to browse books',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).go('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Log In'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingXL,
                  vertical: AppDimens.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(
    ThemeData theme,
    ColorScheme colorScheme,
    bool innerBoxIsScrolled,
  ) {
    return SliverAppBar(
      title: const Text('Books'),
      floating: true,
      pinned: true,
      snap: false,
      forceElevated: _isScrolled || innerBoxIsScrolled,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => GoRouter.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_outlined),
          onPressed: _loadData,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isSmallScreen,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingM,
        AppDimens.paddingL,
        AppDimens.paddingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow:
            _isScrolled
                ? [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Row(
        children: [
          // Search field with expansion animation
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: AppDimens.textFieldHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _searchBooks('');
                            },
                          )
                          : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingM,
                    vertical: AppDimens.paddingS,
                  ),
                ),
                onChanged: _searchBooks,
              ),
            ),
          ),

          // Filter button with indicator
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.paddingM),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Material(
                  color:
                      _isFilterExpanded
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                  child: InkWell(
                    onTap: _toggleFilterPanel,
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimens.paddingM),
                      child: Icon(
                        _isFilterExpanded
                            ? Icons.filter_list
                            : Icons.filter_alt_outlined,
                        color:
                            _isFilterExpanded
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                if (_selectedCategory != null ||
                    _selectedStatus != null ||
                    _selectedDifficulty != null)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _getActiveFilterCount().toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedStatus != null) count++;
    if (_selectedDifficulty != null) count++;
    return count;
  }

  Widget _buildBooksList(
    BookViewModel viewModel,
    ThemeData theme,
    String title,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: viewModel.errorMessage!,
          onRetry: _loadData,
        ),
      );
    }

    if (viewModel.books.isEmpty) {
      return _buildEmptyState(theme);
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.paddingL,
                AppDimens.paddingL,
                AppDimens.paddingL,
                AppDimens.paddingS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$title (${viewModel.books.length})',
                    style: theme.textTheme.titleLarge,
                  ),
                  // View toggle buttons would go here if implementing grid view
                ],
              ),
            ),
          ),

          // Books grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.paddingL,
              0,
              AppDimens.paddingL,
              AppDimens.paddingXXXL,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimens.paddingM,
                crossAxisSpacing: AppDimens.paddingM,
                childAspectRatio: 0.7, // Changed from 0.75 to fix overflow
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final book = viewModel.books[index];
                return BookGridItemWidget(
                  book: book,
                  onTap: () => GoRouter.of(context).push('/books/${book.id}'),
                );
              }, childCount: viewModel.books.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isSearching ? Icons.search_off : Icons.book_outlined,
              size: AppDimens.iconXXL * 2,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
            ),
            const SizedBox(height: AppDimens.spaceXL),
            Text(
              _isSearching
                  ? 'No books found matching your search'
                  : 'No books available',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceL),
            ElevatedButton.icon(
              onPressed:
                  _isSearching
                      ? () {
                        _searchController.clear();
                        _searchBooks('');
                      }
                      : _loadData,
              icon: Icon(_isSearching ? Icons.clear : Icons.refresh),
              label: Text(_isSearching ? 'Clear Search' : 'Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
