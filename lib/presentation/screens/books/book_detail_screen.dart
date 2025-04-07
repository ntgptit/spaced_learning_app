// lib/presentation/screens/books/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
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
        backgroundColor: AppColors.lightBackground,
        actions: [
          // Admin actions
          if (authViewModel.currentUser?.roles?.contains('ADMIN') == true)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit' && book != null) {
                  // Cập nhật sử dụng GoRouter
                  GoRouter.of(context).push('/books/edit/${book.id}');
                } else if (value == 'delete' && book != null) {
                  _showDeleteConfirmation(context, book);
                }
              },
              itemBuilder:
                  (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: AppColors.accentPurple,
                        ),
                        title: Text('Edit Book'),
                        textColor: AppColors.textPrimaryLight,
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: AppColors.lightError,
                        ),
                        title: Text('Delete Book'),
                        textColor: AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
              color: AppColors.lightSurface,
            ),
        ],
      ),
      backgroundColor: AppColors.lightBackground,
      body: _buildBody(theme, book, moduleViewModel),
      floatingActionButton:
          authViewModel.currentUser?.roles?.contains('ADMIN') == true &&
                  book != null
              ? FloatingActionButton(
                onPressed: () {
                  // Cập nhật sử dụng GoRouter
                  GoRouter.of(context).push('/modules/create/${book.id}');
                },
                backgroundColor: AppColors.lightPrimary,
                child: const Icon(Icons.add, color: AppColors.lightOnPrimary),
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
          backgroundColor: AppColors.lightErrorContainer,
          textColor: AppColors.lightOnErrorContainer,
        ),
      );
    }

    if (book == null) {
      return const Center(
        child: Text(
          'Book not found',
          style: TextStyle(color: AppColors.textPrimaryLight),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.lightPrimary,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Book header
          _buildBookHeader(theme, book),
          const SizedBox(height: 16),

          // Book description
          if (book.description != null && book.description!.isNotEmpty) ...[
            Text(
              'Description',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.description!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Modules section
          Text(
            'Modules',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
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
        statusColor = AppColors.successLight;
        break;
      case BookStatus.draft:
        statusColor = AppColors.warningLight;
        break;
      case BookStatus.archived:
        statusColor = AppColors.neutralMedium;
        break;
    }

    // Determine difficulty color and text
    Color difficultyColor;
    String difficultyText = 'Unknown';

    if (book.difficultyLevel != null) {
      switch (book.difficultyLevel!) {
        case DifficultyLevel.beginner:
          difficultyColor = AppColors.successLight;
          difficultyText = 'Beginner';
          break;
        case DifficultyLevel.intermediate:
          difficultyColor = AppColors.accentPurple;
          difficultyText = 'Intermediate';
          break;
        case DifficultyLevel.advanced:
          difficultyColor = AppColors.accentOrange;
          difficultyText = 'Advanced';
          break;
        case DifficultyLevel.expert:
          difficultyColor = AppColors.lightError;
          difficultyText = 'Expert';
          break;
      }
    } else {
      difficultyColor = AppColors.neutralMedium;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                book.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimaryLight,
                ),
              ),
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
                backgroundColor: AppColors.lightSurfaceVariant,
                labelStyle: const TextStyle(color: AppColors.textPrimaryLight),
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
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  TextSpan(
                    text: book.modules.length.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
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
        backgroundColor: AppColors.lightErrorContainer,
        textColor: AppColors.lightOnErrorContainer,
      );
    }

    if (viewModel.modules.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                'No modules available for this book',
                style: TextStyle(color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 8),
              AppButton(
                text: 'Refresh',
                type: AppButtonType.outline,
                onPressed: () => viewModel.loadModulesByBookId(widget.bookId),
                textColor: AppColors.accentOrange,
                borderColor: AppColors.lightOutline,
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
      color: AppColors.lightSurface,
      child: InkWell(
        onTap: () {
          // Sử dụng đường dẫn tương đối thay vì tuyệt đối
          // GoRouter.of(context).push('modules/${module.id}');
          // Hoặc sử dụng đường dẫn tuyệt đối đảm bảo vẫn nằm trong tab Books
          GoRouter.of(
            context,
          ).push('/books/${widget.bookId}/modules/${module.id}');
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
                    decoration: const BoxDecoration(
                      color: AppColors.lightPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      module.moduleNo.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.lightOnPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Module title and metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (module.wordCount != null && module.wordCount! > 0)
                          Text(
                            '${module.wordCount} words',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Arrow indicator
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.iconSecondaryLight,
                  ),
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
            backgroundColor: AppColors.lightSurface,
            title: const Text(
              'Delete Book',
              style: TextStyle(color: AppColors.textPrimaryLight),
            ),
            content: Text(
              'Are you sure you want to delete "${book.name}"? This action cannot be undone.',
              style: const TextStyle(color: AppColors.textSecondaryLight),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.accentPurple),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final bookViewModel = context.read<BookViewModel>();
                  final success = await bookViewModel.deleteBook(book.id);

                  if (success && context.mounted) {
                    // Cập nhật sử dụng GoRouter
                    GoRouter.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Book deleted successfully',
                          style: TextStyle(color: AppColors.onSuccessLight),
                        ),
                        backgroundColor: AppColors.successLight,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.lightError),
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
