// lib/presentation/widgets/modules/grammar/grammar_search_bar.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class GrammarSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onClearSearch;
  final String hintText;
  final bool isSearching;
  final bool enabled;

  const GrammarSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    this.onClearSearch,
    this.hintText = 'Search grammar rules...',
    this.isSearching = false,
    this.enabled = true,
  });

  @override
  State<GrammarSearchBar> createState() => _GrammarSearchBarState();
}

class _GrammarSearchBarState extends State<GrammarSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    if (_hasFocus == hasFocus) return;

    setState(() {
      _hasFocus = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
      return;
    }
    _animationController.reverse();
  }

  void _handleClearSearch() {
    widget.controller.clear();
    widget.onSearchChanged('');
    widget.onClearSearch?.call();
  }

  Widget _buildPrefixIcon(ColorScheme colorScheme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: widget.isSearching
          ? SizedBox(
              width: AppDimens.iconM,
              height: AppDimens.iconM,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            )
          : Icon(
              Icons.search_rounded,
              color: _hasFocus
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: AppDimens.iconM,
            ),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    final hasText = widget.controller.text.isNotEmpty;

    if (!hasText) return null;

    return AnimatedScale(
      scale: hasText ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        icon: Icon(
          Icons.clear_rounded,
          color: colorScheme.onSurfaceVariant,
          size: AppDimens.iconM,
        ),
        onPressed: widget.enabled ? _handleClearSearch : null,
        tooltip: 'Clear search',
        splashRadius: AppDimens.iconM,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(
          alpha: AppDimens.opacityHigh,
        ),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: _buildPrefixIcon(colorScheme),
      ),
      suffixIcon: _buildSuffixIcon(colorScheme),
      filled: true,
      fillColor: _hasFocus
          ? colorScheme.surfaceContainerLowest
          : colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
      border: _buildBorder(colorScheme, isEnabled: false),
      enabledBorder: _buildBorder(colorScheme, isEnabled: true),
      focusedBorder: _buildBorder(colorScheme, isFocused: true),
      disabledBorder: _buildBorder(colorScheme, isDisabled: true),
    );
  }

  OutlineInputBorder _buildBorder(
    ColorScheme colorScheme, {
    bool isEnabled = false,
    bool isFocused = false,
    bool isDisabled = false,
  }) {
    Color borderColor;
    double borderWidth;

    if (isDisabled) {
      borderColor = colorScheme.onSurface.withValues(
        alpha: AppDimens.opacityDisabled,
      );
      borderWidth = 1.0;
    } else if (isFocused) {
      borderColor = colorScheme.primary;
      borderWidth = 2.0;
    } else if (isEnabled) {
      borderColor = colorScheme.outlineVariant.withValues(
        alpha: AppDimens.opacityHigh,
      );
      borderWidth = 1.0;
    } else {
      borderColor = Colors.transparent;
      borderWidth = 0.0;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Focus(
              onFocusChange: _handleFocusChange,
              child: TextField(
                controller: widget.controller,
                enabled: widget.enabled,
                onChanged: widget.onSearchChanged,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: _buildInputDecoration(theme, colorScheme),
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
              ),
            ),
          );
        },
      ),
    );
  }
}
