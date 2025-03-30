import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/screens/modules/module_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

/// Screen displaying detailed book information and modules
class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<BookViewModel>().loadBookDetails(widget.bookId);
    await context.read<ModuleViewModel>().loadModulesByBookId(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookViewModel = context.watch<BookViewModel>();
    final moduleViewModel = context.watch<ModuleViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    final book = bookViewModel.selectedBook;

    return Scaffold(
      appBar: AppBar(
        title: Text(book?.name ?? 'Book Details'),
        actions: [
          // Admin actions
          if (authViewModel.currentUser?.roles?.contains('ADMIN') == true)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit' && book != null) {
                  Navigator.of(
                    context,
                  ).pushNamed('/books/edit', arguments: book.id);
                } else if (value == 'delete' && book != null) {
                  _showDeleteConfirmation(context, book);
                }
              },
              itemBuilder:
                  (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit Book'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete Book'),
                      ),
                    ),
                  ],
            ),
        ],
      ),
      body: _buildBody(theme, book, moduleViewModel),
      floatingActionButton:
          authViewModel.currentUser?.roles?.contains('ADMIN') == true &&
                  book != null
              ? FloatingActionButton(
                onPressed: () {
                  // Navigate to module creation screen with book ID
                  Navigator.of(
                    context,
                  ).pushNamed('/modules/create', arguments: book.id);
                },
                child: const Icon(Icons.add),
              )
              : null,
    );
  }

  /// Build the screen body based on loading state
  Widget _buildBody(
    ThemeData theme,
    BookDetail? book,
    ModuleViewModel moduleViewModel,
  ) {
    final bookViewModel = context.watch<BookViewModel>();

    if (bookViewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (bookViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: bookViewModel.errorMessage!,
          onRetry: _loadData,
        ),
      );
    }

    if (book == null) {
      return const Center(child: Text('Book not found'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Book header
          _buildBookHeader(theme, book),
          const SizedBox(height: 16),

          // Book description
          if (book.description != null && book.description!.isNotEmpty) ...[
            Text('Description', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(book.description!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
          ],

          // Modules section
          Text('Modules', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),

          _buildModulesList(moduleViewModel),
        ],
      ),
    );
  }

  /// Build the book header with status and metadata
  Widget _buildBookHeader(ThemeData theme, BookDetail book) {
    // Determine status color
    Color statusColor;
    switch (book.status) {
      case BookStatus.published:
        statusColor = Colors.green;
        break;
      case BookStatus.draft:
        statusColor = Colors.orange;
        break;
      case BookStatus.archived:
        statusColor = Colors.grey;
        break;
    }

    // Determine difficulty color and text
    Color difficultyColor;
    String difficultyText = 'Unknown';

    if (book.difficultyLevel != null) {
      switch (book.difficultyLevel!) {
        case DifficultyLevel.beginner:
          difficultyColor = Colors.green;
          difficultyText = 'Beginner';
          break;
        case DifficultyLevel.intermediate:
          difficultyColor = Colors.blue;
          difficultyText = 'Intermediate';
          break;
        case DifficultyLevel.advanced:
          difficultyColor = Colors.orange;
          difficultyText = 'Advanced';
          break;
        case DifficultyLevel.expert:
          difficultyColor = Colors.red;
          difficultyText = 'Expert';
          break;
      }
    } else {
      difficultyColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(book.name, style: theme.textTheme.headlineMedium),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _formatStatus(book.status),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Metadata
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (book.category != null) ...[
              Chip(
                label: Text(book.category!),
                backgroundColor: theme.colorScheme.surface,
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: difficultyColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                difficultyText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: difficultyColor,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Modules: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: book.modules.length.toString(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build the list of modules
  Widget _buildModulesList(ModuleViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: AppLoadingIndicator(),
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return ErrorDisplay(
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadModulesByBookId(widget.bookId),
        compact: true,
      );
    }

    if (viewModel.modules.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            children: [
              const Text('No modules available for this book'),
              const SizedBox(height: 8),
              AppButton(
                text: 'Refresh',
                type: AppButtonType.outline,
                onPressed: () => viewModel.loadModulesByBookId(widget.bookId),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.modules.length,
      itemBuilder: (context, index) {
        final module = viewModel.modules[index];
        return _buildModuleCard(module);
      },
    );
  }

  /// Build a card for a single module
  Widget _buildModuleCard(ModuleSummary module) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleDetailScreen(moduleId: module.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module number indicator
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      module.moduleNo.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Module title and metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(module.title, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        if (module.wordCount != null && module.wordCount! > 0)
                          Text(
                            '${module.wordCount} words',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),

                  // Arrow indicator
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show dialog to confirm book deletion
  void _showDeleteConfirmation(BuildContext context, BookDetail book) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Book'),
            content: Text(
              'Are you sure you want to delete "${book.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final bookViewModel = context.read<BookViewModel>();
                  final success = await bookViewModel.deleteBook(book.id);

                  if (success && mounted) {
                    Navigator.of(context).pop(); // Return to books list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Book deleted successfully'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
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
}
