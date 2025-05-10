import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';

extension ProgressDetailExtension on ProgressDetail {
  int get completedRepetitions =>
      repetitions.where((r) => r.status == RepetitionStatus.completed).length;

  int get totalRepetitions => repetitions.length;

  double get clampedPercentComplete => percentComplete.clamp(0, 100);

  bool get isOverdue =>
      nextStudyDate != null && nextStudyDate!.isBefore(DateTime.now());

  String get formattedStartDate => firstLearningDate != null
      ? DateFormat.yMMMd().format(firstLearningDate!)
      : 'Not started';

  String get formattedNextDate => nextStudyDate != null
      ? DateFormat.yMMMd().format(nextStudyDate!)
      : 'Not scheduled';
}

class ProgressHeaderWidget extends ConsumerWidget {
  final ProgressDetail progress;
  final VoidCallback onCycleCompleteDialogRequested;

  const ProgressHeaderWidget({
    super.key,
    required this.progress,
    required this.onCycleCompleteDialogRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(theme),
            const SizedBox(height: 16),
            _buildProgressSection(theme),
            const SizedBox(height: 16),
            _buildCycleInfoSection(context, ref, theme),
            const SizedBox(height: 16),
            _buildDatesSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.menu_book_rounded,
            size: 28,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            progress.moduleTitle ?? 'Learning Module',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final progressValue = progress.clampedPercentComplete / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Progress',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ProgressBar(value: progressValue, colorScheme: colorScheme),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Card(
              color: colorScheme.primaryContainer,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${progress.clampedPercentComplete.toInt()}%',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCycleInfoSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;
    final cycleInfo = ref.watch(getCycleInfoProvider(progress.cyclesStudied));
    final cycleColor = CycleFormatter.getColor(progress.cyclesStudied, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: cycleColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                CycleFormatter.getIcon(progress.cyclesStudied),
                color: cycleColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cycle: ${CycleFormatter.getDisplayName(progress.cyclesStudied)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cycleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: cycleColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${progress.completedRepetitions} / ${progress.totalRepetitions}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cycleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: cycleColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cycleInfo,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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

  Widget _buildDatesSection(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: DateInfoBlock(
                  label: 'Start Date',
                  value: progress.formattedStartDate,
                  icon: Icons.calendar_today_outlined,
                  color: colorScheme.primary,
                  theme: theme,
                ),
              ),
              VerticalDivider(
                width: 24,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: DateInfoBlock(
                  label: 'Next Review',
                  value: progress.formattedNextDate,
                  icon: Icons.event_note,
                  color: progress.isOverdue
                      ? colorScheme.error
                      : colorScheme.secondary,
                  isHighlighted: progress.isOverdue,
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double value;
  final ColorScheme colorScheme;

  const ProgressBar({
    super.key,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            tween: Tween(begin: 0, end: value),
            builder: (context, animatedValue, child) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * animatedValue,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class DateInfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeData theme;
  final bool isHighlighted;

  const DateInfoBlock({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isHighlighted
                      ? colorScheme.error
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
