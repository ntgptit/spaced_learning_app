import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDateSelected;
  final VoidCallback onDateCleared;

  const FilterDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onDateCleared,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Date',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        selectedDate == null
            ? OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: const Text('Select Date'),
              onPressed: onDateSelected,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
            : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(selectedDate!),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onDateCleared,
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
