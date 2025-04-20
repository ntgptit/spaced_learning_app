import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/books/metadata_item.dart';
import 'package:spaced_learning_app/presentation/widgets/books/module_card.dart';
import 'package:spaced_learning_app/presentation/widgets/books/stat_item.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class BookOverviewTab extends StatelessWidget {
  final BookDetail book;

  const BookOverviewTab({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (book.description?.isNotEmpty == true) ...[
            _buildSectionTitle(
              theme,
              colorScheme,
              'Description',
              Icons.description_outlined,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.paddingL),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(
                    alpha: AppDimens.opacityMediumHigh,
                  ),
                ),
              ),
              child: Text(
                book.description!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),
          ],

          _buildSectionTitle(
            theme,
            colorScheme,
            'Modules Overview',
            Icons.view_module_outlined,
          ),
          const SizedBox(height: AppDimens.spaceS),
          _buildModuleStats(theme, colorScheme, book),
          const SizedBox(height: AppDimens.spaceL),

          _buildSectionTitle(
            theme,
            colorScheme,
            'Book Details',
            Icons.info_outline,
          ),
          const SizedBox(height: AppDimens.spaceS),
          _buildMetadataCard(theme, colorScheme, book),

          const SizedBox(height: AppDimens.paddingXL),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: AppDimens.iconM, color: colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
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
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityMediumHigh,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StatItemWidget(
              value: totalModules.toString(),
              label: 'Total Modules',
              icon: Icons.menu_book_outlined,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: StatItemWidget(
              value: totalModules > 0
                  ? '${_calculateCompletionPercentage(book)}%'
                  : '0%',
              label: 'Completion',
              icon: Icons.bar_chart_rounded,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: StatItemWidget(
              value: _calculateEstimatedTime(book),
              label: 'Est. Time',
              icon: Icons.access_time,
              color: colorScheme.primary,
            ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityMediumHigh,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetadataItemWidget(
            label: 'Created',
            value: book.createdAt != null
                ? _formatDate(book.createdAt!)
                : 'Unknown',
            icon: Icons.calendar_today_outlined,
          ),
          const Divider(height: AppDimens.spaceXL),
          MetadataItemWidget(
            label: 'Last Updated',
            value: book.updatedAt != null
                ? _formatDate(book.updatedAt!)
                : 'Not updated',
            icon: Icons.update,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _calculateCompletionPercentage(BookDetail book) {
    if (book.modules.isEmpty) return '0';
    final int completedModules = book.modules
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

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      itemCount: viewModel.modules.length,
      itemBuilder: (context, index) {
        final module = viewModel.modules[index];
        return SizedBox(
          height: 105, // Chiều cao cố định là 105 theo yêu cầu
          child: ModuleCardWidget(
            module: module,
            index: index,
            onTap: () {
              final moduleId = module.id;
              GoRouter.of(context).push('/books/$bookId/modules/$moduleId');
            },
          ),
        );
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimens.spaceXXS),
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
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: AppDimens.opacityMedium,
              ),
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
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: AppDimens.opacityHigh,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXL),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
