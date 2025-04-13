import 'package:flutter/material.dart';

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
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  hasBookFilter
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.5),
              width: hasBookFilter ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBook,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: hasBookFilter ? colorScheme.primary : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: BorderRadius.circular(12),
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
