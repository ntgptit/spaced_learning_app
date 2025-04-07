import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _selectedCategory;
  List<String> _categories = [];
  BookStatus? _selectedStatus;
  DifficultyLevel? _selectedDifficulty;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final bookViewModel = context.watch<BookViewModel>();

    if (authViewModel.currentUser == null) {
      return Center(
        child: Text(
          'Please log in to browse books',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search books...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _searchBooks('');
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusS),
                    ),
                  ),
                  onChanged: _searchBooks,
                ),
                const SizedBox(height: AppDimens.spaceS),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filter'),
                        onPressed: () => _showFilterBottomSheet(context),
                      ),
                      if (_selectedCategory != null) ...[
                        const SizedBox(width: AppDimens.spaceS),
                        Chip(
                          label: Text(_selectedCategory!),
                          onDeleted: () {
                            setState(() => _selectedCategory = null);
                            _applyFilters();
                          },
                        ),
                      ],
                      if (_selectedStatus != null) ...[
                        const SizedBox(width: AppDimens.spaceS),
                        Chip(
                          label: Text(_formatStatus(_selectedStatus!)),
                          onDeleted: () {
                            setState(() => _selectedStatus = null);
                            _applyFilters();
                          },
                        ),
                      ],
                      if (_selectedDifficulty != null) ...[
                        const SizedBox(width: AppDimens.spaceS),
                        Chip(
                          label: Text(_formatDifficulty(_selectedDifficulty!)),
                          onDeleted: () {
                            setState(() => _selectedDifficulty = null);
                            _applyFilters();
                          },
                        ),
                      ],
                      if (_selectedCategory != null ||
                          _selectedStatus != null ||
                          _selectedDifficulty != null) ...[
                        const SizedBox(width: AppDimens.spaceS),
                        TextButton(
                          onPressed: _resetFilters,
                          child: const Text('Reset'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildBooksList(
              bookViewModel,
              _isSearching ? 'Search results' : 'Available Books',
            ),
          ),
        ],
      ),
      floatingActionButton:
          authViewModel.currentUser?.roles?.contains('ADMIN') == true
              ? FloatingActionButton(
                onPressed:
                    () => Navigator.of(context).pushNamed('/books/create'),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }

  Widget _buildBooksList(BookViewModel viewModel, String title) {
    final theme = Theme.of(context);

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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.book,
              size: AppDimens.iconXXL,
              color: theme.disabledColor,
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              _isSearching
                  ? 'No books found matching your search'
                  : 'No books available',
              style: theme.textTheme.titleMedium,
            ),
            TextButton(onPressed: _loadData, child: const Text('Refresh')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppDimens.paddingXXXL),
        itemCount: viewModel.books.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.paddingL,
                0,
                AppDimens.paddingL,
                AppDimens.paddingS,
              ),
              child: Text(
                '$title (${viewModel.books.length})',
                style: theme.textTheme.titleLarge,
              ),
            );
          }

          final book = viewModel.books[index - 1];
          return BookCard(
            book: book,
            onTap: () => GoRouter.of(context).push('/books/${book.id}'),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusL),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            return Padding(
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filter Books',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  Text('Category', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppDimens.spaceS),
                  Wrap(
                    spacing: AppDimens.spaceS,
                    children: [
                      for (final category in _categories)
                        ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  Text('Status', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppDimens.spaceS),
                  Wrap(
                    spacing: AppDimens.spaceS,
                    children: [
                      for (final status in BookStatus.values)
                        ChoiceChip(
                          label: Text(_formatStatus(status)),
                          selected: _selectedStatus == status,
                          onSelected: (selected) {
                            setState(() {
                              _selectedStatus = selected ? status : null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  Text('Difficulty', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppDimens.spaceS),
                  Wrap(
                    spacing: AppDimens.spaceS,
                    children: [
                      for (final difficulty in DifficultyLevel.values)
                        ChoiceChip(
                          label: Text(_formatDifficulty(difficulty)),
                          selected: _selectedDifficulty == difficulty,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDifficulty =
                                  selected ? difficulty : null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceXL),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: const Text('Apply Filters'),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                        _selectedStatus = null;
                        _selectedDifficulty = null;
                      });
                      Navigator.pop(context);
                      _resetFilters();
                    },
                    child: const Text('Reset All'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatStatus(BookStatus status) {
    switch (status) {
      case BookStatus.published:
        return 'Published';
      case BookStatus.draft:
        return 'Draft';
      case BookStatus.archived:
        return 'Archived';
    }
  }

  String _formatDifficulty(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }
}
