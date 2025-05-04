import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/cycle_group_card.dart';

class StatusSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color containerColor;
  final Color textColor;
  final Map<String, List<Repetition>> cycleGroups;
  final bool isHistory;
  final CycleStudied currentCycleStudied;
  final Future<void> Function(String)? onMarkCompleted;
  final Future<void> Function(String, DateTime, bool)? onReschedule;

  const StatusSection({
    super.key,
    required this.title,
    required this.icon,
    required this.containerColor,
    required this.textColor,
    required this.cycleGroups,
    required this.isHistory,
    required this.currentCycleStudied,
    this.onMarkCompleted,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sortedKeys = cycleGroups.keys.toList();
    if (isHistory) {
      sortedKeys.sort((a, b) {
        final cycleNumA = int.tryParse(a.replaceAll('Cycle ', '')) ?? 0;
        final cycleNumB = int.tryParse(b.replaceAll('Cycle ', '')) ?? 0;
        return cycleNumB.compareTo(cycleNumA); // Descending order
      });
    }

    // Sử dụng màu từ color scheme theo Material 3
    final titleIconColor = isHistory
        ? colorScheme.primary.withValues(alpha: AppDimens.opacityVeryHigh)
        : textColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingS),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    border: Border.all(
                      color: textColor.withValues(alpha: AppDimens.opacitySemi),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: titleIconColor,
                    size: AppDimens.iconM,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isHistory
                        ? colorScheme.primary.withValues(
                            alpha: AppDimens.opacityVeryHigh,
                          )
                        : textColor,
                  ),
                ),
              ],
            ),
          ),
          ...sortedKeys.map(
            (key) => CycleGroupCard(
              cycleKey: key,
              repetitions: cycleGroups[key]!,
              isHistory: isHistory,
              currentCycleStudied: currentCycleStudied,
              onMarkCompleted: onMarkCompleted,
              onReschedule: onReschedule,
            ),
          ),
        ],
      ),
    );
  }
}
