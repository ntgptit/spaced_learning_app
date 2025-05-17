// lib/presentation/widgets/common/dialog/sl_multi_select_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton

import '../input/sl_text_field.dart'; // Assuming SLTextField for search

// Item model for SlMultiSelectDialog
class SlMultiSelectItem<T> {
  final String label;
  final T value;
  final Widget? leading; // Optional leading widget (e.g., an icon)
  final bool enabled;

  SlMultiSelectItem({
    required this.label,
    required this.value,
    this.leading,
    this.enabled = true,
  });
}

class SlMultiSelectDialog<T> extends ConsumerStatefulWidget {
  final String title;
  final List<SlMultiSelectItem<T>> items;
  final List<T> initialSelection;

  // final String Function(T) itemLabelBuilder; // Replaced by SlMultiSelectItem.label
  final Widget Function(BuildContext, SlMultiSelectItem<T>, bool isSelected)?
  itemBuilder; // More flexible item builder
  final String confirmText;
  final String cancelText;
  final String? searchHintText;
  final bool enableSearch;
  final String? emptySearchText;
  final Widget? emptySearchWidget;
  final Widget? titleIcon; // Changed from IconData
  final bool showSelectedCount;
  final String Function(int count)? selectedCountBuilder;
  final bool isDismissible;
  final bool showDividers;
  final String? selectAllText;
  final String? clearAllText;
  final double? maxHeightFraction;

  const SlMultiSelectDialog({
    super.key,
    required this.title,
    required this.items,
    this.initialSelection = const [],
    // required this.itemLabelBuilder,
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
    this.selectAllText, // e.g., "Select All"
    this.clearAllText, // e.g., "Clear All"
    this.maxHeightFraction =
        0.7, // Default max height as a fraction of screen height
  });

  @override
  ConsumerState<SlMultiSelectDialog<T>> createState() =>
      _SlMultiSelectDialogState<T>();
}

class _SlMultiSelectDialogState<T>
    extends ConsumerState<SlMultiSelectDialog<T>> {
  late List<T> _selectedItems;
  late List<SlMultiSelectItem<T>> _filteredItems;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _selectedItems = List<T>.from(widget.initialSelection);
    _filteredItems = List<SlMultiSelectItem<T>>.from(widget.items);
    _searchController = TextEditingController();
    if (widget.enableSearch) {
      _searchController.addListener(_filterItems);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredItems = List<SlMultiSelectItem<T>>.from(widget.items);
      });
      return;
    }
    setState(() {
      _filteredItems = widget.items.where((item) {
        return item.label.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleItem(T itemValue) {
    final item = widget.items.firstWhere((i) => i.value == itemValue);
    if (!item.enabled) return;

    setState(() {
      if (_selectedItems.contains(itemValue)) {
        _selectedItems.remove(itemValue);
      } else {
        _selectedItems.add(itemValue);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedItems = widget.items
          .where((item) => item.enabled)
          .map((item) => item.value)
          .toList();
    });
  }

  void _clearAll() {
    setState(() {
      _selectedItems.clear();
    });
  }

  String _getSelectedCountText() {
    if (widget.selectedCountBuilder != null) {
      return widget.selectedCountBuilder!(_selectedItems.length);
    }
    final count = _selectedItems.length;
    return '$count ${count == 1 ? "item" : "items"} selected';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    final bool canSelectAll =
        widget.selectAllText != null &&
        widget.items.any((item) => item.enabled);
    final bool canClearAll =
        widget.clearAllText != null && _selectedItems.isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL), // M3 shape
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
      // Content will have its own padding
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
          if (widget.showSelectedCount && _selectedItems.isNotEmpty)
            Chip(
              label: Text(
                _getSelectedCountText(),
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
                  prefixIcon: Icons.search_rounded,
                  size: SlTextFieldSize.medium,
                  // THIS LINE SHOULD NOW WORK
                  fillColor: colorScheme.surfaceContainerHigh,
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
                      SLButton(
                        text: widget.selectAllText!,
                        onPressed: _selectAll,
                        type: SLButtonType.text,
                        size: SLButtonSize.small,
                      ),
                    if (canSelectAll && canClearAll)
                      const SizedBox(width: AppDimens.spaceS),
                    if (canClearAll)
                      SLButton(
                        text: widget.clearAllText!,
                        onPressed: _clearAll,
                        type: SLButtonType.text,
                        size: SLButtonSize.small,
                      ),
                  ],
                ),
              ),
            if (widget.showDividers &&
                (widget.enableSearch || canSelectAll || canClearAll))
              const Divider(height: 1),
            Expanded(
              child: _filteredItems.isEmpty
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
                      itemCount: _filteredItems.length,
                      separatorBuilder: (context, index) => widget.showDividers
                          ? const Divider(
                              height: 1,
                              indent: AppDimens.paddingL,
                              endIndent: AppDimens.paddingL,
                            )
                          : const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected = _selectedItems.contains(item.value);

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
                                  : colorScheme.onSurface.withValues(
                                      alpha: 0.38,
                                    ),
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
        SLButton(
          text: widget.cancelText,
          onPressed: () => Navigator.of(context).pop(), // Pops with null
          type: SLButtonType.text,
        ),
        SLButton(
          text: widget.confirmText,
          onPressed: () => Navigator.of(context).pop(_selectedItems),
          type: SLButtonType.primary,
        ),
      ],
    );
  }

  /// Show the multi-select dialog
  static Future<List<T>?> show<T>(
    BuildContext context, {
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
    return showDialog<List<T>>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => SlMultiSelectDialog<T>(
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
