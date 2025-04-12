import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_cover.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_detail_tabs.dart';
import 'package:spaced_learning_app/presentation/widgets/books/info_chip.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _loadData();
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
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    final colorScheme = theme.colorScheme;

    if (bookViewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Details')),
        body: const Center(child: AppLoadingIndicator()),
      );
    }

    if (bookViewModel.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Details')),
        body: Center(
          child: ErrorDisplay(
            message: bookViewModel.errorMessage!,
            onRetry: _loadData,
          ),
        ),
      );
    }

    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Details')),
        body: const Center(child: Text('Book not found')),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              _buildFlexibleAppBar(
                theme,
                colorScheme,
                book,
                authViewModel,
                innerBoxIsScrolled,
              ),
            ],
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(icon: Icon(Icons.info_outline), text: 'Overview'),
                Tab(icon: Icon(Icons.view_module_outlined), text: 'Modules'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BookOverviewTab(book: book),

                  BookModulesTab(
                    bookId: widget.bookId,
                    viewModel: moduleViewModel,
                    onRetry:
                        () =>
                            moduleViewModel.loadModulesByBookId(widget.bookId),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildFlexibleAppBar(
    ThemeData theme,
    ColorScheme colorScheme,
    BookDetail book,
    AuthViewModel authViewModel,
    bool innerBoxIsScrolled,
  ) {
    final statusColor = _getStatusColor(book.status);
    final difficultyData = _getDifficultyData(theme, book.difficultyLevel);

    return SliverAppBar(
      expandedHeight: AppDimens.bannerHeight - 20,
      floating: false,
      pinned: true,
      forceElevated: _isScrolled || innerBoxIsScrolled,
      backgroundColor:
          _isScrolled
              ? theme.appBarTheme.backgroundColor
              : colorScheme.surfaceContainerHigh,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => GoRouter.of(context).pop(),
        color: _isScrolled ? null : colorScheme.onSurfaceVariant,
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        expandedTitleScale: 1.0,
        title:
            _isScrolled
                ? Padding(
                  padding: const EdgeInsets.only(left: 56.0, right: 56.0),
                  child: Text(
                    book.name,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
                : const SizedBox.shrink(),
        background: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.paddingL,
            kToolbarHeight,
            AppDimens.paddingL,
            AppDimens.paddingL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'book-${book.id}',
                    child: BookCover(book: book.toSummary(), theme: theme),
                  ),
                  const SizedBox(width: AppDimens.spaceL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.name,
                          style: theme.textTheme.headlineSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimens.spaceS),
                        Row(
                          children: [
                            InfoChipWidget(
                              label: _formatStatus(book.status),
                              backgroundColor: statusColor.withValues(
                                alpha: 0.2,
                              ),
                              textColor: statusColor,
                            ),
                            if (book.difficultyLevel != null) ...[
                              const SizedBox(width: AppDimens.spaceXS),
                              InfoChipWidget(
                                label: difficultyData.text,
                                backgroundColor: difficultyData.color
                                    .withValues(alpha: 0.2),
                                textColor: difficultyData.color,
                              ),
                            ],
                          ],
                        ),
                        if (book.category != null) ...[
                          const SizedBox(height: AppDimens.spaceXS),
                          InfoChipWidget(
                            label: book.category!,
                            backgroundColor: colorScheme.tertiaryContainer,
                            textColor: colorScheme.onTertiaryContainer,
                            icon: Icons.category_outlined,
                          ),
                        ],
                        const SizedBox(height: AppDimens.spaceS),
                        Row(
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              size: AppDimens.iconS,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppDimens.spaceXXS),
                            Text(
                              '${book.modules.length} ${book.modules.length == 1 ? 'module' : 'modules'}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        return (color: theme.colorScheme.tertiary, text: 'Intermediate');
      case DifficultyLevel.advanced:
        return (color: theme.colorScheme.secondary, text: 'Advanced');
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
