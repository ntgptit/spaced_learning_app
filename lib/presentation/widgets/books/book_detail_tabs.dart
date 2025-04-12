// lib/presentation/widgets/books/book_detail_tabs.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
// Đảm bảo bạn đã import common_book.dart và các file cần thiết khác
import 'package:spaced_learning_app/presentation/widgets/books/metadata_item.dart';
import 'package:spaced_learning_app/presentation/widgets/books/module_card.dart';
import 'package:spaced_learning_app/presentation/widgets/books/stat_item.dart';
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

    // *** Quay lại sử dụng SingleChildScrollView + Column ***
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      physics: const BouncingScrollPhysics(), // Thêm hiệu ứng cuộn nảy nhẹ
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
              width: double.infinity, // Đảm bảo container chiếm đủ rộng
              padding: const EdgeInsets.all(AppDimens.paddingL),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
          // Giữ nguyên _buildModuleStats với Expanded bên trong Row
          _buildModuleStats(theme, colorScheme, book),
          const SizedBox(height: AppDimens.spaceXL),

          // Book Metadata
          _buildSectionTitle(theme, 'Book Details', Icons.info_outline),
          const SizedBox(height: AppDimens.spaceS),
          _buildMetadataCard(theme, colorScheme, book),

          // Thêm một khoảng trống cuối cùng để tránh chạm đáy màn hình
          const SizedBox(height: AppDimens.paddingXL),
        ],
      ),
    );
  }

  // _buildSectionTitle giữ nguyên
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

  // _buildModuleStats giữ nguyên (vẫn dùng Expanded bên trong Row)
  Widget _buildModuleStats(
    ThemeData theme,
    ColorScheme colorScheme,
    BookDetail book,
  ) {
    final totalModules = book.modules.length;

    return Container(
      width: double.infinity, // Đảm bảo container chiếm đủ rộng
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        // Row vẫn là cấu trúc chính
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // StatItem được bọc trong Expanded
            child: StatItemWidget(
              value: totalModules.toString(),
              label: 'Total Modules',
              icon: Icons.menu_book_outlined,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM), // Khoảng cách giữa các item
          Expanded(
            // StatItem được bọc trong Expanded
            child: StatItemWidget(
              value:
                  totalModules > 0
                      ? '${_calculateCompletionPercentage(book)}%'
                      : '0%',
              label: 'Completion',
              icon: Icons.bar_chart_rounded,
              color: colorScheme.tertiary,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM), // Khoảng cách giữa các item
          Expanded(
            // StatItem được bọc trong Expanded
            child: StatItemWidget(
              value: _calculateEstimatedTime(book),
              label: 'Est. Time',
              icon: Icons.access_time,
              color: colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  // _buildMetadataCard giữ nguyên
  Widget _buildMetadataCard(
    ThemeData theme,
    ColorScheme colorScheme,
    BookDetail book,
  ) {
    return Container(
      width: double.infinity, // Đảm bảo container chiếm đủ rộng
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
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

  // Các hàm helper giữ nguyên
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yy').format(date);
  }

  String _calculateCompletionPercentage(BookDetail book) {
    if (book.modules.isEmpty) return '0';
    final int completedModules =
        book.modules
            .where(
              (m) =>
                  (m.progress.isNotEmpty &&
                      m.progress.first.percentComplete == 100.0),
            )
            .length;
    if (book.modules.isEmpty) return '0';
    return ((completedModules / book.modules.length) * 100).toStringAsFixed(0);
  }

  String _calculateEstimatedTime(BookDetail book) {
    final totalWords = book.modules.fold<int>(
      0,
      (sum, module) => sum + (module.wordCount ?? 0),
    );
    if (totalWords == 0) return '0 min';
    final minutes = (totalWords / 200).ceil();
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) return '$hours hr';
      return '$hours hr $remainingMinutes min';
    }
  }
}

// BookModulesTab giữ nguyên như phiên bản trước
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

    // Sử dụng ListView.separated để thêm khoảng cách dễ dàng hơn
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimens.paddingL), // Thêm padding chung
      itemCount: viewModel.modules.length,
      itemBuilder: (context, index) {
        final module = viewModel.modules[index];
        return ModuleCardWidget(
          module: module,
          index: index,
          onTap: () {
            final moduleId = module.id;
            GoRouter.of(context).push('/books/$bookId/modules/$moduleId');
          },
        );
      },
      separatorBuilder:
          (context, index) => const SizedBox(
            height: AppDimens.spaceM,
          ), // Khoảng cách giữa các card
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
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'No modules available for this book yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              'Check back later or add a new module if you have permission.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
