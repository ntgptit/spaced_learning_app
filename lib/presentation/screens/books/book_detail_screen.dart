// lib/presentation/screens/books/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/module_card.dart';

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
      appBar: _buildAppBar(theme, book, authViewModel),
      body: _buildBody(theme, book, moduleViewModel),
      floatingActionButton: _buildFloatingActionButton(authViewModel, book),
    );
  }

  AppBar _buildAppBar(
    ThemeData theme,
    BookDetail? book,
    AuthViewModel authViewModel,
  ) {
    return AppBar(
      title: Text(book?.name ?? 'Book Details'),
      actions: [
        if (authViewModel.currentUser?.roles?.contains('ADMIN') == true)
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuSelection(value, book),
            itemBuilder: (context) => _buildPopupMenuItems(theme),
          ),
      ],
    );
  }

  List<PopupMenuItem<String>> _buildPopupMenuItems(ThemeData theme) {
    return [
      PopupMenuItem<String>(
        value: 'edit',
        child: ListTile(
          leading: Icon(Icons.edit, color: theme.colorScheme.primary),
          title: const Text('Edit Book'),
        ),
      ),
      PopupMenuItem<String>(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete, color: theme.colorScheme.error),
          title: const Text('Delete Book'),
        ),
      ),
    ];
  }

  Widget _buildBody(
    ThemeData theme,
    BookDetail? book,
    ModuleViewModel moduleViewModel,
  ) {
    final bookViewModel = context.watch<BookViewModel>();

    if (bookViewModel.isLoading)
      return const Center(child: AppLoadingIndicator());
    if (bookViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: bookViewModel.errorMessage!,
          onRetry: _loadData,
        ),
      );
    }
    if (book == null) return const Center(child: Text('Book not found'));

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildBookHeader(theme, book),
          const SizedBox(height: 16),
          if (book.description?.isNotEmpty == true) ...[
            Text('Description', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(book.description!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
          ],
          Text('Modules', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildModulesList(moduleViewModel),
        ],
      ),
    );
  }

  Widget _buildBookHeader(ThemeData theme, BookDetail book) {
    final statusColor = _getStatusColor(book.status);
    final difficultyData = _getDifficultyData(theme, book.difficultyLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(book.name, style: theme.textTheme.headlineMedium),
            ),
            _buildStatusChip(theme, book.status, statusColor),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (book.category != null) Chip(label: Text(book.category!)),
            _buildDifficultyChip(theme, difficultyData),
            _buildModulesCount(theme, book.modules.length),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(
    ThemeData theme,
    BookStatus status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _formatStatus(status),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(
    ThemeData theme,
    ({Color color, String text}) data,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        data.text,
        style: theme.textTheme.bodySmall?.copyWith(color: data.color),
      ),
    );
  }

  Widget _buildModulesCount(ThemeData theme, int count) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Modules: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: count.toString(), style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  // Tiếp tục từ đoạn code trước
  Widget _buildModulesList(ModuleViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
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
        return ModuleCard(
          module: module,
          onTap:
              () => GoRouter.of(
                context,
              ).push('/books/${widget.bookId}/modules/${module.id}'),
          // onStudyPressed:
          //     () => GoRouter.of(
          //       context,
          //     ).push('/books/${widget.bookId}/modules/${module.id}/study'),
        );
      },
    );
  }

  FloatingActionButton? _buildFloatingActionButton(
    AuthViewModel authViewModel,
    BookDetail? book,
  ) {
    return authViewModel.currentUser?.roles?.contains('ADMIN') == true &&
            book != null
        ? FloatingActionButton(
          onPressed:
              () => GoRouter.of(context).push('/modules/create/${book.id}'),
          child: const Icon(Icons.add),
        )
        : null;
  }

  void _handleMenuSelection(String value, BookDetail? book) {
    if (book == null) return;
    if (value == 'edit') {
      GoRouter.of(context).push('/books/edit/${book.id}');
    } else if (value == 'delete') {
      _showDeleteConfirmation(context, book);
    }
  }

  void _showDeleteConfirmation(BuildContext context, BookDetail book) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Book'),
            content: Text(
              'Are you sure you want to delete "${book.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final bookViewModel = context.read<BookViewModel>();
                  final success = await bookViewModel.deleteBook(book.id);
                  if (success && context.mounted) {
                    GoRouter.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Book deleted successfully'),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }

  Color _getStatusColor(BookStatus status) {
    switch (status) {
      case BookStatus.published:
        return Colors.green;
      case BookStatus.draft:
        return Colors.orange;
      case BookStatus.archived:
        return Colors.grey;
    }
  }

  ({Color color, String text}) _getDifficultyData(
    ThemeData theme,
    DifficultyLevel? level,
  ) {
    if (level == null) return (color: Colors.grey, text: 'Unknown');
    switch (level) {
      case DifficultyLevel.beginner:
        return (color: Colors.green, text: 'Beginner');
      case DifficultyLevel.intermediate:
        return (color: Colors.red, text: 'Intermediate');
      case DifficultyLevel.advanced:
        return (color: Colors.amber, text: 'Advanced');
      case DifficultyLevel.expert:
        return (color: theme.colorScheme.error, text: 'Expert');
    }
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
}
