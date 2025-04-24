import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

import '../learning/main/module_card.dart';

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
          if (book.description != null && book.description!.isNotEmpty) ...[
            Text('Description', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppDimens.spaceM),
            Text(book.description!),
            const SizedBox(height: AppDimens.spaceXL),
          ],

          Text('Book Details', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppDimens.spaceM),
          _buildDetailItem(context, 'Author', book.author ?? 'Unknown'),
          _buildDetailItem(
            context,
            'Published',
            book.publishedAt != null
                ? _formatDate(book.publishedAt!)
                : 'Not published',
          ),
          _buildDetailItem(
            context,
            'Last Updated',
            book.updatedAt != null
                ? _formatDate(book.updatedAt!)
                : 'Not updated',
          ),
          if (book.modules.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceL),
            Text('Featured Modules', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppDimens.spaceM),
            _buildFeaturedModules(context, book.modules, colorScheme),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedModules(
    BuildContext context,
    List<ModuleInfo> modules,
    ColorScheme colorScheme,
  ) {
    // Only show first 3 modules as featured
    final featuredModules = modules.take(3).toList();

    return Column(
      children: featuredModules.map((module) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
          child: ModuleCard(
            title: module.title,
            subtitle: 'Module ${module.moduleNo}',
            onTap: () {
              if (module.id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid module ID')),
                );
                return;
              }

              GoRouter.of(context).push('/modules/${module.id}');
            },
            leading: CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Text(
                module.moduleNo.toString(),
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class BookModulesTab extends StatelessWidget {
  final String bookId;
  final List<ModuleSummary>? modules;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  const BookModulesTab({
    super.key,
    required this.bookId,
    this.modules,
    this.isLoading = false,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: ErrorDisplay(message: errorMessage!, onRetry: onRetry),
      );
    }

    final moduleList = modules ?? [];
    if (moduleList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.book_outlined,
                size: 64,
                color: colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: AppDimens.spaceL),
              Text(
                'No modules available',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.spaceM),
              Text(
                'This book doesn\'t have any modules yet.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      itemCount: moduleList.length,
      itemBuilder: (context, index) {
        final module = moduleList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
          child: ModuleCard(
            title: module.title,
            subtitle: 'Module ${module.moduleNo}',
            onTap: () => _navigateToModule(context, module),
            leading: CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Text(
                module.moduleNo.toString(),
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
            trailing: module.isCompleted == true
                ? Icon(Icons.check_circle, color: colorScheme.tertiary)
                : null,
          ),
        );
      },
    );
  }

  void _navigateToModule(BuildContext context, ModuleSummary module) {
    if (module.id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid module ID')));
      return;
    }

    GoRouter.of(context).push('/books/$bookId/modules/${module.id}');
  }
}
