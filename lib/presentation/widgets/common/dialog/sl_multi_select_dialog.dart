// lib/presentation/widgets/common/dialog/sl_multi_select_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/input/sl_text_field.dart';

part 'sl_multi_select_dialog.g.dart';

// Item model for SlMultiSelectDialog
class SlMultiSelectItem<T> {
  final String label;
  final T value;
  final Widget? leading;
  final bool enabled;

  SlMultiSelectItem({
    required this.label,
    required this.value,
    this.leading,
    this.enabled = true,
  });
}

// Provider for selected items in dialog
@riverpod
class DialogSelections extends _$DialogSelections {
  @override
  List<dynamic> build(String dialogId) => [];

  void setInitialSelections(List<dynamic> selections) {
    state = List<dynamic>.from(selections);
  }

  void toggleItem(dynamic item) {
    final updatedList = List<dynamic>.from(state);
    if (updatedList.contains(item)) {
      updatedList.remove(item);
    } else {
      updatedList.add(item);
    }
    state = updatedList;
  }

  void selectAll(List<dynamic> items) {
    state = List<dynamic>.from(items);
  }

  void clearAll() {
    state = [];
  }
}

// Provider for search query
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build(String dialogId) => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

// Provider for filtered items based on search
@riverpod
List<SlMultiSelectItem> filteredItems(
  FilteredItemsRef ref,
  String dialogId,
  List<SlMultiSelectItem> allItems,
) {
  final searchQuery = ref.watch(searchQueryProvider(dialogId));

  if (searchQuery.isEmpty) {
    return allItems;
  }

  final queryLower = searchQuery.toLowerCase();
  return allItems
      .where((item) => item.label.toLowerCase().contains(queryLower))
      .toList();
}

/// A dialog that allows users to select multiple items from a list.
class SlMultiSelectDialog<T> extends ConsumerStatefulWidget {
  final String dialogId;
  final String title;
  final List<SlMultiSelectItem<T>> items;
  final List<T> initialSelection;
  final Widget Function(BuildContext, SlMultiSelectItem<T>, bool isSelected)?
  itemBuilder;
  final String confirmText;
  final String cancelText;
  final String? searchHintText;
  final bool enableSearch;
  final String? emptySearchText;
  final Widget? emptySearchWidget;
  final Widget? titleIcon;
  final bool showSelectedCount;
  final String Function(int count)? selectedCountBuilder;
  final bool isDismissible;
  final bool showDividers;
  final String? selectAllText;
  final String? clearAllText;
  final double? maxHeightFraction;

  const SlMultiSelectDialog({
    super.key,
    required this.dialogId,
    required this.title,
    required this.items,
    this.initialSelection = const [],
    this.itemBuilder,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.searchHintText = 'Search items...',
    this.enableSearch = true,
    this.emptySearchText = 'No items found.',
    this.emptySearchWidget,
    this.titleIcon,
    this.showSelectedCount = true,
    this.selectedCountBuilder,
    this.isDismissible = true,
    this.showDividers = true,
    this.selectAllText,
    this.clearAllText,
    this.maxHeightFraction = 0.7,
  });

  @override
  ConsumerState<SlMultiSelectDialog<T>> createState() =>
      _SlMultiSelectDialogState<T>();

  /// Factory for a standard multi-select dialog
  factory SlMultiSelectDialog.standard({
    required String dialogId,
    required String title,
    required List<SlMultiSelectItem<T>> items,
    List<T> initialSelection = const [],
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool enableSearch = true,
  }) {
    return SlMultiSelectDialog<T>(
      dialogId: dialogId,
      title: title,
      items: items,
      initialSelection: initialSelection,
      confirmText: confirmText,
      cancelText: cancelText,
      enableSearch: enableSearch,
    );
  }

  /// Factory for a compact multi-select dialog
  factory SlMultiSelectDialog.compact({
    required String dialogId,
    required String title,
    required List<SlMultiSelectItem<T>> items,
    List<T> initialSelection = const [],
    Widget? titleIcon,
  }) {
    return SlMultiSelectDialog<T>(
      dialogId: dialogId,
      title: title,
      items: items,
      initialSelection: initialSelection,
      maxHeightFraction: 0.5,
      titleIcon: titleIcon,
      showSelectedCount: true,
      enableSearch: false,
    );
  }

  /// Factory for a dialog with item selection management
  factory SlMultiSelectDialog.withManagement({
    required String dialogId,
    required String title,
    required List<SlMultiSelectItem<T>> items,
    List<T> initialSelection = const [],
    String? selectAllText = 'Select All',
    String? clearAllText = 'Clear All',
  }) {
    return SlMultiSelectDialog<T>(
      dialogId: dialogId,
      title: title,
      items: items,
      initialSelection: initialSelection,
      selectAllText: selectAllText,
      clearAllText: clearAllText,
      enableSearch: true,
    );
  }

  /// Show the multi-select dialog with the given parameters
  static Future<List<T>?> show<T>(
    BuildContext context,
    WidgetRef ref, {
    required String dialogId,
    required String title,
    required List<SlMultiSelectItem<T>> items,
    List<T> initialSelection = const [],
    Widget Function(BuildContext, SlMultiSelectItem<T>, bool isSelected)?
    itemBuilder,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    String? searchHintText = 'Search items...',
    bool enableSearch = true,
    String? emptySearchText = 'No items found.',
    Widget? emptySearchWidget,
    Widget? titleIcon,
    bool showSelectedCount = true,
    String Function(int count)? selectedCountBuilder,
    bool isDismissible = true,
    bool showDividers = true,
    String? selectAllText,
    String? clearAllText,
    double? maxHeightFraction,
  }) {
    // Initialize dialog selections with initial selection
    ref
        .read(dialogSelectionsProvider(dialogId).notifier)
        .setInitialSelections(initialSelection);

    // Reset search query
    ref.read(searchQueryProvider(dialogId).notifier).clear();

    return showDialog<List<T>>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => SlMultiSelectDialog<T>(
        dialogId: dialogId,
        title: title,
        items: items,
        initialSelection: initialSelection,
        itemBuilder: itemBuilder,
        confirmText: confirmText,
        cancelText: cancelText,
        searchHintText: searchHintText,
        enableSearch: enableSearch,
        emptySearchText: emptySearchText,
        emptySearchWidget: emptySearchWidget,
        titleIcon: titleIcon,
        showSelectedCount: showSelectedCount,
        selectedCountBuilder: selectedCountBuilder,
        isDismissible: isDismissible,
        showDividers: showDividers,
        selectAllText: selectAllText,
        clearAllText: clearAllText,
        maxHeightFraction: maxHeightFraction,
      ),
    );
  }
}

class _SlMultiSelectDialogState<T>
    extends ConsumerState<SlMultiSelectDialog<T>> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Initialize selections after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dialogSelectionsProvider(widget.dialogId).notifier)
          .setInitialSelections(widget.initialSelection);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleItem(T value) {
    final item = widget.items.firstWhere((item) => item.value == value);
    if (!item.enabled) return;

    ref
        .read(dialogSelectionsProvider(widget.dialogId).notifier)
        .toggleItem(value);
  }

  void _selectAll() {
    final availableItems = widget.items
        .where((item) => item.enabled)
        .map((item) => item.value)
        .toList();

    ref
        .read(dialogSelectionsProvider(widget.dialogId).notifier)
        .selectAll(availableItems);
  }

  void _clearAll() {
    ref.read(dialogSelectionsProvider(widget.dialogId).notifier).clearAll();
  }

  String _getSelectedCountText(List<T> selectedItems) {
    if (widget.selectedCountBuilder != null) {
      return widget.selectedCountBuilder!(selectedItems.length);
    }
    final count = selectedItems.length;
    return '$count ${count == 1 ? "item" : "items"} selected';
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider(widget.dialogId).notifier).setQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    // Get selected items from provider
    final List<dynamic> selectedItemsDynamic = ref.watch(
      dialogSelectionsProvider(widget.dialogId),
    );
    final List<T> selectedItems = selectedItemsDynamic.whereType<T>().toList();

    // Get filtered items based on search
    final List<SlMultiSelectItem> filteredItemsResult = ref.watch(
      filteredItemsProvider(
        widget.dialogId,
        widget.items.cast<SlMultiSelectItem>(),
      ),
    );

    // Cast back to specific type for type safety
    final List<SlMultiSelectItem<T>> filteredItems = filteredItemsResult
        .whereType<SlMultiSelectItem<T>>()
        .toList();

    final bool canSelectAll =
        widget.selectAllText != null &&
        widget.items.any((item) => item.enabled);

    final bool canClearAll =
        widget.clearAllText != null && selectedItems.isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
      surfaceTintColor: colorScheme.surfaceTint,
      titlePadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingS,
      ),
      contentPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.all(AppDimens.paddingL),
      actionsAlignment: MainAxisAlignment.end,

      title: Row(
        children: [
          if (widget.titleIcon != null) ...[
            widget.titleIcon!,
            const SizedBox(width: AppDimens.spaceS),
          ],
          Expanded(
            child: Text(
              widget.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (widget.showSelectedCount && selectedItems.isNotEmpty)
            Chip(
              label: Text(
                _getSelectedCountText(selectedItems),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              backgroundColor: colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingXS,
              ),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * (widget.maxHeightFraction ?? 0.7),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.enableSearch)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingM,
                ),
                child: SLTextField(
                  controller: _searchController,
                  hint: widget.searchHintText,
                  prefixIcon: Icons.search,
                  size: SlTextFieldSize.medium,
                  fillColor: colorScheme.surfaceContainerHigh,
                  onChanged: _onSearchChanged,
                ),
              ),
            if (canSelectAll || canClearAll)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingXS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canSelectAll)
                      SlButton(
                        text: widget.selectAllText!,
                        onPressed: _selectAll,
                        variant: SlButtonVariant.text,
                        size: SlButtonSize.small,
                      ),
                    if (canSelectAll && canClearAll)
                      const SizedBox(width: AppDimens.spaceS),
                    if (canClearAll)
                      SlButton(
                        text: widget.clearAllText!,
                        onPressed: _clearAll,
                        variant: SlButtonVariant.text,
                        size: SlButtonSize.small,
                      ),
                  ],
                ),
              ),
            if (widget.showDividers &&
                (widget.enableSearch || canSelectAll || canClearAll))
              const Divider(height: 1),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child:
                          widget.emptySearchWidget ??
                          Padding(
                            padding: const EdgeInsets.all(AppDimens.paddingL),
                            child: Text(
                              widget.emptySearchText!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.paddingS,
                      ),
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) => widget.showDividers
                          ? const Divider(
                              height: 1,
                              indent: AppDimens.paddingL,
                              endIndent: AppDimens.paddingL,
                            )
                          : const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = selectedItems.contains(item.value);

                        if (widget.itemBuilder != null) {
                          return InkWell(
                            onTap: item.enabled
                                ? () => _toggleItem(item.value)
                                : null,
                            child: widget.itemBuilder!(
                              context,
                              item,
                              isSelected,
                            ),
                          );
                        }

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: item.enabled
                              ? (_) => _toggleItem(item.value)
                              : null,
                          title: Text(
                            item.label,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: item.enabled
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface.withOpacity(0.38),
                            ),
                          ),
                          secondary: item.leading,
                          activeColor: colorScheme.primary,
                          checkColor: colorScheme.onPrimary,
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingL,
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          enabled: item.enabled,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        SlButton(
          text: widget.cancelText,
          onPressed: () => Navigator.of(context).pop(),
          variant: SlButtonVariant.text,
        ),
        SlButton(
          text: widget.confirmText,
          onPressed: () => Navigator.of(context).pop(selectedItems),
          variant: SlButtonVariant.filled,
        ),
      ],
    );
  }
}
