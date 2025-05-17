import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/utils/debouncer.dart';

part 'sl_search_field.g.dart';

// Provider for the search query
@riverpod
class SearchQuery extends _$SearchQuery {
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  String build(String searchId) => '';

  void setQuery(String query) {
    state = query;
  }

  void setQueryDebounced(String query, Function(String) callback) {
    _debouncer.run(() {
      state = query;
      callback(query);
    });
  }

  void clearQuery() {
    state = '';
  }
}

// Provider for search suggestions
@riverpod
class SearchSuggestions extends _$SearchSuggestions {
  @override
  List<dynamic> build(String searchId) => [];

  void setSuggestions(List<dynamic> suggestions) {
    state = suggestions;
  }

  void clearSuggestions() {
    state = [];
  }
}

class SlSearchField<T> extends ConsumerStatefulWidget {
  final String searchId;
  final String? hint;
  final String? label;
  final IconData? prefixIcon;
  final IconData searchIcon;
  final IconData clearIcon;
  final Function(String) onSearch;
  final Future<List<T>> Function(String query)? onSuggestions;
  final Widget Function(T suggestion)? suggestionBuilder;
  final Function(T suggestion)? onSuggestionSelected;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final bool autofocus;
  final bool showClearButton;
  final EdgeInsetsGeometry? contentPadding;
  final int minSearchLength;
  final int debounceTime;
  final bool autoDispose;

  const SlSearchField({
    super.key,
    required this.searchId,
    this.hint,
    this.label,
    this.prefixIcon,
    this.searchIcon = Icons.search,
    this.clearIcon = Icons.clear,
    required this.onSearch,
    this.onSuggestions,
    this.suggestionBuilder,
    this.onSuggestionSelected,
    this.onClear,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.fillColor,
    this.borderColor,
    this.borderRadius = AppDimens.radiusM,
    this.autofocus = false,
    this.showClearButton = true,
    this.contentPadding,
    this.minSearchLength = 2,
    this.debounceTime = 300,
    this.autoDispose = true,
  });

  @override
  ConsumerState<SlSearchField<T>> createState() => _SlSearchFieldState<T>();
}

class _SlSearchFieldState<T> extends ConsumerState<SlSearchField<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late Debouncer _debouncer;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _debouncer = Debouncer(milliseconds: widget.debounceTime);

    _focusNode.addListener(_onFocusChange);

    // Initialize with existing query if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentQuery = ref.read(searchQueryProvider(widget.searchId));
      if (currentQuery.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = currentQuery;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);

    if (widget.autoDispose) {
      if (widget.controller == null) {
        _controller.dispose();
      }
      if (widget.focusNode == null) {
        _focusNode.dispose();
      }
      _debouncer.dispose();
    }

    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.onSuggestions != null) {
      setState(() {
        _showSuggestions = true;
      });
      _loadSuggestions(_controller.text);
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider(widget.searchId).notifier).setQuery(query);

    if (query.length >= widget.minSearchLength) {
      _debouncer.run(() {
        widget.onSearch(query);
        _loadSuggestions(query);
      });
    } else if (query.isEmpty) {
      if (widget.onClear != null) {
        widget.onClear!();
      }
      ref
          .read(searchSuggestionsProvider(widget.searchId).notifier)
          .clearSuggestions();
    }
  }

  Future<void> _loadSuggestions(String query) async {
    if (widget.onSuggestions != null &&
        query.length >= widget.minSearchLength) {
      final suggestions = await widget.onSuggestions!(query);
      if (mounted) {
        ref
            .read(searchSuggestionsProvider(widget.searchId).notifier)
            .setSuggestions(suggestions);
      }
    }
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(searchQueryProvider(widget.searchId).notifier).clearQuery();
    ref
        .read(searchSuggestionsProvider(widget.searchId).notifier)
        .clearSuggestions();

    if (widget.onClear != null) {
      widget.onClear!();
    } else {
      widget.onSearch('');
    }

    setState(() {
      _showSuggestions = false;
    });
  }

  void _onSuggestionSelected(T suggestion) {
    if (widget.onSuggestionSelected != null) {
      widget.onSuggestionSelected!(suggestion);
      setState(() {
        _showSuggestions = false;
      });
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final suggestions =
        ref.watch(searchSuggestionsProvider(widget.searchId)) as List<T>;
    final hasSuggestions = suggestions.isNotEmpty && _showSuggestions;

    final effectiveFillColor =
        widget.fillColor ?? colorScheme.surfaceContainerLowest;
    final effectiveBorderColor = widget.borderColor ?? colorScheme.outline;
    final effectiveContentPadding =
        widget.contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingM,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.paddingS,
              bottom: AppDimens.paddingXS,
            ),
            child: Text(
              widget.label!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          autofocus: widget.autofocus,
          style: widget.style ?? theme.textTheme.bodyMedium,
          decoration:
              widget.decoration ??
              InputDecoration(
                hintText: widget.hint ?? 'Search...',
                filled: true,
                fillColor: effectiveFillColor,
                contentPadding: effectiveContentPadding,
                prefixIcon: Icon(
                  widget.prefixIcon ?? widget.searchIcon,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimens.iconM,
                ),
                suffixIcon:
                    _controller.text.isNotEmpty && widget.showClearButton
                    ? IconButton(
                        icon: Icon(
                          widget.clearIcon,
                          color: colorScheme.onSurfaceVariant,
                          size: AppDimens.iconM,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: effectiveBorderColor,
                    width: AppDimens.outlineButtonBorderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: effectiveBorderColor,
                    width: AppDimens.outlineButtonBorderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: AppDimens.outlineButtonBorderWidth * 1.5,
                  ),
                ),
              ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              widget.onSearch(value);
            }
            _focusNode.unfocus();
          },
        ),
        if (hasSuggestions && widget.suggestionBuilder != null) ...[
          Container(
            margin: const EdgeInsets.only(top: AppDimens.spaceXS),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: effectiveBorderColor,
                width: AppDimens.outlineButtonBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return InkWell(
                  onTap: () => _onSuggestionSelected(suggestion),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.paddingS,
                      horizontal: AppDimens.paddingM,
                    ),
                    child: widget.suggestionBuilder!(suggestion),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
