// lib/presentation/widgets/books/book_detail_tabs.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/common_book.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

/// Tab hiển thị tổng quan về sách
class BookOverviewTab extends StatelessWidget {
  final BookDetail book;

  const BookOverviewTab({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Description
          if (book.description?.isNotEmpty == true) ...[
            _buildSectionTitle(
              theme,
              'Description',
              Icons.description_outlined,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingL),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Text(book.description!, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: AppDimens.spaceXL),
          ],

          // Modules Overview
          _buildSectionTitle(
            theme,
            'Modules Overview',
            Icons.view_module_outlined,
          ),
          const SizedBox(height: AppDimens.spaceS),
          _buildModuleStats(theme, colorScheme, book),
          const SizedBox(height: AppDimens.spaceXL),

          // Book Metadata
          _buildSectionTitle(theme, 'Book Details', Icons.info_outline),
          const SizedBox(height: AppDimens.spaceS),
          _buildMetadataCard(theme, colorScheme, book),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: AppDimens.iconM, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildModuleStats(
    ThemeData theme,
    ColorScheme colorScheme,
    BookDetail book,
  ) {
    final totalModules = book.modules.length;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItemWidget(
                value: totalModules.toString(),
                label: 'Total Modules',
                icon: Icons.menu_book_outlined,
                color: colorScheme.primary,
              ),
              StatItemWidget(
                value:
                    totalModules > 0
                        ? '${_calculateCompletionPercentage(book)}%'
                        : '0%',
                label: 'Completion',
                icon: Icons.bar_chart_rounded,
                color: colorScheme.tertiary,
              ),
              StatItemWidget(
                value: _calculateEstimatedTime(book),
                label: 'Est. Time',
                icon: Icons.access_time,
                color: colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard(
    ThemeData theme,
    ColorScheme colorScheme,
    BookDetail book,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetadataItemWidget(
            label: 'Created',
            value:
                book.createdAt != null
                    ? _formatDate(book.createdAt!)
                    : 'Unknown',
            icon: Icons.calendar_today_outlined,
          ),
          const Divider(height: AppDimens.spaceXL),
          MetadataItemWidget(
            label: 'Last Updated',
            value:
                book.updatedAt != null
                    ? _formatDate(book.updatedAt!)
                    : 'Not updated',
            icon: Icons.update,
          ),
          const Divider(height: AppDimens.spaceXL),
          MetadataItemWidget(
            label: 'ID',
            value: book.id,
            icon: Icons.fingerprint,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateCompletionPercentage(BookDetail book) {
    if (book.modules.isEmpty) return '0';
    // Trong ứng dụng thực, sẽ tính toán dựa trên dữ liệu hoàn thành thực tế
    // Đây chỉ là một giá trị giả định
    return '42';
  }

  String _calculateEstimatedTime(BookDetail book) {
    // Giá trị giả định
    final totalWords = book.modules.fold<int>(
      0,
      (sum, module) => sum + (module.wordCount ?? 0),
    );

    if (totalWords == 0) return '0 min';

    // Giả sử tốc độ đọc trung bình là 200 từ/phút
    final minutes = (totalWords / 200).ceil();

    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hr';
      }
      return '$hours hr $remainingMinutes min';
    }
  }
}

/// Tab hiển thị danh sách modules
class BookModulesTab extends StatelessWidget {
  final String bookId;
  final ModuleViewModel viewModel;
  final VoidCallback onRetry;

  const BookModulesTab({
    super.key,
    required this.bookId,
    required this.viewModel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (viewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(message: viewModel.errorMessage!, onRetry: onRetry),
      );
    }

    if (viewModel.modules.isEmpty) {
      return _buildEmptyModulesState(theme, colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingL,
        horizontal: AppDimens.paddingL,
      ),
      itemCount: viewModel.modules.length,
      itemBuilder: (context, index) {
        final module = viewModel.modules[index];
        return ModuleCardWidget(
          module: module,
          index: index,
          onTap:
              () => GoRouter.of(
                context,
              ).push('/books/$bookId/modules/${module.id}'),
        );
      },
    );
  }

  Widget _buildEmptyModulesState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_module_outlined,
              size: AppDimens.iconXXL,
              color: colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'No modules available for this book',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXL),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
