import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/books/filter_chip.dart';

/// Panel to filter books by category, status, and difficulty.
class BookFilterPanel extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final BookStatus? selectedStatus;
  final DifficultyLevel? selectedDifficulty;
  final ValueChanged<String?>? onCategorySelected;
  final ValueChanged<BookStatus?>? onStatusSelected;
  final ValueChanged<DifficultyLevel?>? onDifficultySelected;
  final VoidCallback? onFiltersApplied;
  final VoidCallback? onFilterCleared;

  const BookFilterPanel({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.selectedStatus,
    this.selectedDifficulty,
    this.onCategorySelected,
    this.onStatusSelected,
    this.onDifficultySelected,
    this.onFiltersApplied,
    this.onFilterCleared,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingS,
        AppDimens.paddingL,
        AppDimens.paddingL,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.radiusL),
          bottomRight: Radius.circular(AppDimens.radiusL),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active filters + Clear All
          if (selectedCategory != null ||
              selectedStatus != null ||
              selectedDifficulty != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.paddingM),
              child: Wrap(
                spacing: AppDimens.spaceS,
                runSpacing: AppDimens.spaceS,
                children: [
                  if (selectedCategory != null)
                    FilterChipWidget(
                      label: selectedCategory!,
                      color: cs.primary,
                      textColor: cs.onPrimary,
                      onDeleted: () => onCategorySelected?.call(null),
                    ),
                  if (selectedStatus != null)
                    FilterChipWidget(
                      label: _formatStatus(selectedStatus!),
                      color: cs.primary,
                      textColor: cs.onPrimary,
                      onDeleted: () => onStatusSelected?.call(null),
                    ),
                  if (selectedDifficulty != null)
                    FilterChipWidget(
                      label: _formatDifficulty(selectedDifficulty!),
                      color: cs.primary,
                      textColor: cs.onPrimary,
                      onDeleted: () => onDifficultySelected?.call(null),
                    ),
                  OutlinedButton.icon(
                    onPressed: onFilterCleared,
                    icon: Icon(
                      Icons.clear_all,
                      color: cs.primary,
                      size: AppDimens.iconS,
                    ),
                    label: const Text('Clear All'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.primary,
                      side: BorderSide(color: cs.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingM,
                        vertical: AppDimens.paddingXS,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),

          // Category section
          _buildSection(
            theme,
            'Category',
            Icons.category_outlined,
            Wrap(
              spacing: AppDimens.spaceXS,
              runSpacing: AppDimens.spaceXS,
              children: [
                for (final c in categories)
                  ChoiceChip(
                    label: Text(c),
                    selected: selectedCategory == c,
                    onSelected: (sel) =>
                        onCategorySelected?.call(sel ? c : null),
                    selectedColor: cs.primaryContainer,
                    backgroundColor: cs.surfaceContainerHighest,
                    labelStyle: TextStyle(
                      color: selectedCategory == c
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Status section
          _buildSection(
            theme,
            'Status',
            Icons.published_with_changes_outlined,
            Wrap(
              spacing: AppDimens.spaceXS,
              runSpacing: AppDimens.spaceXS,
              children: [
                for (final s in BookStatus.values)
                  ChoiceChip(
                    label: Text(_formatStatus(s)),
                    selected: selectedStatus == s,
                    onSelected: (sel) => onStatusSelected?.call(sel ? s : null),
                    selectedColor: cs.primaryContainer,
                    backgroundColor: cs.surfaceContainerHighest,
                    labelStyle: TextStyle(
                      color: selectedStatus == s
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Difficulty section
          _buildSection(
            theme,
            'Difficulty',
            Icons.signal_cellular_alt_outlined,
            Wrap(
              spacing: AppDimens.spaceXS,
              runSpacing: AppDimens.spaceXS,
              children: [
                for (final d in DifficultyLevel.values)
                  ChoiceChip(
                    label: Text(_formatDifficulty(d)),
                    selected: selectedDifficulty == d,
                    onSelected: (sel) =>
                        onDifficultySelected?.call(sel ? d : null),
                    selectedColor: cs.primaryContainer,
                    backgroundColor: cs.surfaceContainerHighest,
                    labelStyle: TextStyle(
                      color: selectedDifficulty == d
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Apply Filters button
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimens.paddingM),
              child: ElevatedButton.icon(
                onPressed: onFiltersApplied,
                icon: Icon(Icons.check, color: cs.secondary),
                label: const Text('Apply Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    IconData icon,
    Widget content,
  ) {
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cs.primary, size: AppDimens.iconS),
              const SizedBox(width: AppDimens.spaceXS),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXS),
          content,
        ],
      ),
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
