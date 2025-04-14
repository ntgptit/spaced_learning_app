import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class FilterBookSelector extends StatelessWidget {
  final String selectedBook;
  final List<String> books;
  final Function(String?) onBookChanged;

  const FilterBookSelector({
    super.key,
    required this.selectedBook,
    required this.books,
    required this.onBookChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasBookFilter = selectedBook != 'All';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Book',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(AppDimens.opacityHigh),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  hasBookFilter
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(AppDimens.opacitySemi),
              width: hasBookFilter ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBook,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: hasBookFilter ? colorScheme.primary : null,
                size: AppDimens.iconL,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingL,
                vertical: AppDimens.paddingS,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              items:
                  books
                      .map(
                        (book) => DropdownMenuItem(
                          value: book,
                          child: Text(
                            book,
                            style: TextStyle(
                              color:
                                  book == selectedBook && book != 'All'
                                      ? colorScheme.primary
                                      : null,
                              fontWeight:
                                  book == selectedBook && book != 'All'
                                      ? FontWeight.bold
                                      : null,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: onBookChanged,
            ),
          ),
        ),
      ],
    );
  }
}
