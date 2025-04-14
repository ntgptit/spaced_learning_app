import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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
            color: colorScheme.onSurface.withOpacity(AppDimens.opacityHigh),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        // Đặt chiều cao cố định cho container chứa button
        SizedBox(
          height: 48, // Đảm bảo chiều cao cố định
          child:
              selectedDate == null
                  ? OutlinedButton.icon(
                    icon: const Icon(
                      Icons.calendar_today,
                      size: AppDimens.iconS,
                    ),
                    label: const Text('Select Date'),
                    onPressed: onDateSelected,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        48,
                      ), // Đảm bảo chiều cao đủ
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingL,
                        vertical: AppDimens.paddingM,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                    ),
                  )
                  : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingL,
                      vertical: AppDimens.paddingM - 1, // Điều chỉnh cho border
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.primary, width: 2),
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AppDimens.iconS,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppDimens.spaceS),
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
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusS,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimens.paddingXS),
                            child: Icon(
                              Icons.close,
                              size: AppDimens.iconS,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }
}
