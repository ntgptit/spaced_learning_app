// lib/presentation/widgets/common/dialog/sl_multi_select_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A dialog that allows the user to select multiple items from a list.
class SlMultiSelectDialog<T> extends ConsumerStatefulWidget {
  final String title;
  final List<T> items;
  final List<T> initialSelection;
  final String Function(T) itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final String confirmText;
  final String cancelText;
  final String? searchHint;
  final bool enableSearch;
  final String? emptySearchText;
  final Widget? emptySearchWidget;
  final Widget? icon;
  final bool showSelectedCount;
  final String Function(int)? selectedCountBuilder;
  final bool isDismissible;
  final bool showDividers;
  final String? selectAllText;
  final String? clearAllText;

  const SlMultiSelectDialog({
    super.key,
    required this.title,
    required this.items,
    required this.initialSelection,
    required this.itemLabelBuilder,
    this.itemBuilder,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.searchHint = 'Search',
    this.enableSearch = true,
    this.emptySearchText = 'No items found',
    this.emptySearchWidget,
    this.icon,
    this.showSelectedCount = true,
    this.selectedCountBuilder,
    this.isDismissible = true,
    this.showDividers = true,
    this.selectAllText,
    this.clearAllText,
  });

  @override
  ConsumerState<SlMultiSelectDialog<T>> createState() => _SlMultiSelectDialogState<T>();
}

class _SlMultiSelectDialogState<T> extends ConsumerState<SlMultiSelectDialog<T>> {
  late List<T> _selectedItems;
  late List<T> _filteredItems;
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _selectedItems = List<T>.from(widget.initialSelection);
    _filteredItems = List<T>.from(widget.items);
    _searchController = TextEditingController();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredItems = List<T>.from(widget.items);
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredItems = widget.items.where((item) {
        final label = widget.itemLabelBuilder(item).toLowerCase();
        return label.contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  void _toggleItem(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedItems = List<T>.from(widget.items);
    });
  }

  void _clearAll() {
    setState(() {
      _selectedItems = [];
    });
  }

  String _getSelectedCountText() {
    if (widget.selectedCountBuilder != null) {
      return widget.selectedCountBuilder!(_selectedItems.length);
    }
    return '${_selectedItems.length} selected';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingL,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingL,
        0,
      ),
      title: Row(
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: AppDimens.spaceM),
          ],
          Expanded(
            child: Text(
              widget.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.showSelectedCount && _selectedItems.isNotEmpty)
            Chip(
              label: Text(
                _getSelectedCountText(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingXS,
              ),
            ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.enableSearch) ...[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingM,
                    vertical: AppDimens.paddingS,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceM),
            ],
            if (widget.selectAllText != null || widget.clearAllText != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.selectAllText != null)
                    TextButton(
                      onPressed: _selectAll,
                      child: Text(widget.selectAllText!),
                    ),
                  if (widget.clearAllText != null) ...[
                    const SizedBox(width: AppDimens.spaceXS),
                    TextButton(
                      onPressed: _clearAll,
                      child: Text(widget.clearAllText!),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppDimens.spaceXS),
            ],
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: widget.emptySearchWidget ??
                          Text(
                            widget.emptySearchText!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                    )
                  : ListView.separated(
                      itemCount: _filteredItems.length,
                      separatorBuilder: (context, index) => widget.showDividers
                          ? const Divider(height: 1)
                          : const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected = _selectedItems.contains(item);
                        
                        if (widget.itemBuilder != null) {
                          return InkWell(
                            onTap: () => _toggleItem(item),
                            child: Row(
                              children: [
                                Expanded(child: widget.itemBuilder!(item)),
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _toggleItem(item),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (_) => _toggleItem(item),
                          title: Text(
                            widget.itemLabelBuilder(item),
                            style: theme.textTheme.bodyLarge,
                          ),
                          activeColor: colorScheme.primary,
                          checkColor: colorScheme.onPrimary,
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingS,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            widget.cancelText,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selectedItems),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: Text(widget.confirmText),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
    );
  }

  /// Show the multi-select dialog
  static Future<List<T>?> show<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    List<T> initialSelection = const [],
    required String Function(T) itemLabelBuilder,
    Widget Function(T)? itemBuilder,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    String? searchHint = 'Search',
    bool enableSearch = true,
    String? emptySearchText = 'No items found',
    Widget? emptySearchWidget,
    Widget? icon,
    bool showSelectedCount = true,
    String Function(int)? selectedCountBuilder,
    bool isDismissible = true,
    bool showDividers = true,
    String? selectAllText,
    String? clearAllText,
  }) {
    return showDialog<List<T>>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => SlMultiSelectDialog<T>(
        title: title,
        items: items,
        initialSelection: initialSelection,
        itemLabelBuilder: itemLabelBuilder,
        itemBuilder: itemBuilder,
        confirmText: confirmText,
        cancelText: cancelText,
        searchHint: searchHint,
        enableSearch: enableSearch,
        emptySearchText: emptySearchText,
        emptySearchWidget: emptySearchWidget,
        icon: icon,
        showSelectedCount: showSelectedCount,
        selectedCountBuilder: selectedCountBuilder,
        isDismissible: isDismissible,
        showDividers: showDividers,
        selectAllText: selectAllText,
        clearAllText: clearAllText,
      ),
    );
  }

  /// Convenience method to select multiple strings
  static Future<List<String>?> showStrings(
    BuildContext context, {
    required String title,
    required List<String> items,
    List<String> initialSelection = const [],
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return show<String>(
      context,
      title: title,
      items: items,
      initialSelection: initialSelection,
      itemLabelBuilder: (item) => item,
      confirmText: confirmText,
      cancelText: cancelText,
      selectAllText: 'Select All',
      clearAllText: 'Clear All',
    );
  }

  /// Convenience method to select multiple categories
  static Future<List<String>?> showCategories(
    BuildContext context, {
    required String title,
    required List<String> categories,
    List<String> initialSelection = const [],
    String confirmText = 'Apply',
    String cancelText = 'Cancel',
  }) {
    return show<String>(
      context,
      title: title,
      items: categories,
      initialSelection: initialSelection,
      itemLabelBuilder: (item) => item,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: const Icon(Icons.category_outlined),
      selectAllText: 'Select All',
      clearAllText: 'Clear',
    );
  }
}
