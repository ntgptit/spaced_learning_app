import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/screens/books/book_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

/// Screen displaying a list of available books
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
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final bookViewModel = context.read<BookViewModel>();

    // Load categories for filtering
    await bookViewModel.loadCategories();
    setState(() {
      _categories = bookViewModel.categories;
    });

    // Load books
    await bookViewModel.loadBooks();
  }

  void _applyFilters() {
    final bookViewModel = context.read<BookViewModel>();

    bookViewModel.filterBooks(
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

    final bookViewModel = context.read<BookViewModel>();
    bookViewModel.loadBooks();
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

    final bookViewModel = context.read<BookViewModel>();
    await bookViewModel.searchBooks(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final bookViewModel = context.watch<BookViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(
        child: Text('Please log in to browse books'),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search books...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchBooks('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: _searchBooks,
                ),

                // Filter row
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Filter button
                      OutlinedButton.icon(
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filter'),
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                      ),

                      // Active filters
                      if (_selectedCategory != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_selectedCategory),
                          onDeleted: () {
                            setState(() {
                              _selectedCategory = null;
                            });
                            _applyFilters();
                          },
                        ),
                      ],

                      if (_selectedStatus != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_formatStatus(_selectedStatus!)),
                          onDeleted: () {
                            setState(() {
                              _selectedStatus = null;
                            });
                            _applyFilters();
                          },
                        ),
                      ],

                      if (_selectedDifficulty != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_formatDifficulty(_selectedDifficulty!)),
                          onDeleted: () {
                            setState(() {
                              _selectedDifficulty = null;
                            });
                            _applyFilters();
                          },
                        ),
                      ],

                      // Reset filters
                      if (_selectedCategory != null ||
                          _selectedStatus != null ||
                          _selectedDifficulty != null) ...[
                        const SizedBox(width: 8),
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

          // Books list
          Expanded(
            child: _buildBooksList(
              bookViewModel,
              _isSearching ? 'Search results' : 'Available Books',
            ),
          ),
        ],
      ),
      floatingActionButton: authViewModel.currentUser?.roles?.contains('ADMIN') == true
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to book creation screen
                Navigator.of(context).pushNamed('/books/create');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Build the books list with header
  Widget _buildBooksList(BookViewModel viewModel, String title) {
    if (viewModel.isLoading) {
      return const Center(
        child: AppLoadingIndicator(),
      );
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
            const Icon(
              Icons.book,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching
                  ? 'No books found matching your search'
                  : 'No books available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: _loadData,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Extra padding for FAB
        itemCount: viewModel.books.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '$title (${viewModel.books.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          final book = viewModel.books[index - 1];
          return BookCard(
            book: book,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(bookId: book.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Show filter options in a bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filter Books',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Difficulty
                  Text(
                    'Difficulty',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final difficulty in DifficultyLevel.values)
                        ChoiceChip(
                          label: Text(_formatDifficulty(difficulty)),
                          selected: _selectedDifficulty == difficulty,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDifficulty = selected ? difficulty : null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Apply button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: const Text('Apply Filters'),
                  ),
                  const SizedBox(height: 8),

                  // Reset button
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

  /// Format status enum to user-friendly string
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

  /// Format difficulty enum to user-friendly string
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
}),

                  // Categories
                  void Text(
                    'Category',
                    style = Theme.of(context).textTheme.titleMedium,
                  ),
                  void SizedBox(height = 8),
                  void Wrap(
                    spacing = 8,
                    children = [
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
                  void SizedBox(height = 16),

                  // Status
                  void Text(
                    'Status',
                    style = Theme.of(context).textTheme.titleMedium,
                  ),
                  void SizedBox(height = 8),
                  void Wrap(
                    spacing = 8,
                    children = [
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
                  void SizedBox(height = 16
