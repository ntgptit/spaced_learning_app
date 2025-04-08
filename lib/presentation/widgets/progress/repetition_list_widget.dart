import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Verwijder AppColors import indien niet meer nodig
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Aangenomen dat dit bestaat
import 'package:spaced_learning_app/domain/models/progress.dart'; // Zorg voor correct pad
import 'package:spaced_learning_app/domain/models/repetition.dart'; // Zorg voor correct pad
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart'; // Zorg voor correct pad
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Aangenomen thema-bewust
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart'; // Aangenomen thema-bewust
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart'; // Aangenomen thema-bewust
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart'; // Al aangepast

// Definieer M3ColorPair opnieuw indien nodig, of importeer van een gedeelde plek
typedef M3ColorPair = ({Color container, Color onContainer});

class RepetitionListWidget extends StatefulWidget {
  final String progressId;
  final CycleStudied currentCycleStudied;
  final Future<void> Function(String) onMarkCompleted;
  final Future<void> Function(String) onMarkSkipped;
  final Future<void> Function(String, DateTime) onReschedule;
  final Future<void> Function() onReload;

  const RepetitionListWidget({
    super.key,
    required this.progressId,
    required this.currentCycleStudied,
    required this.onMarkCompleted,
    required this.onMarkSkipped,
    required this.onReschedule,
    required this.onReload,
  });

  @override
  State<RepetitionListWidget> createState() => _RepetitionListWidgetState();
}

class _RepetitionListWidgetState extends State<RepetitionListWidget> {
  @override
  Widget build(BuildContext context) {
    // Haal thema-informatie op
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Consumer<RepetitionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimens.paddingXL),
              child: AppLoadingIndicator(), // Gebruikt thema-kleuren (aanname)
            ),
          );
        }

        if (viewModel.errorMessage != null) {
          return ErrorDisplay(
            message: viewModel.errorMessage!,
            onRetry: () {
              viewModel.loadRepetitionsByProgressId(widget.progressId);
            },
            compact: true, // Aanname: ErrorDisplay gebruikt thema
          );
        }

        if (viewModel.repetitions.isEmpty) {
          // Geef thema door aan empty state indien nodig (AppButton gebruikt het al)
          return _buildEmptyState(context);
        }

        // Data voorbereiden (logica ongewijzigd)
        final repetitions = List<Repetition>.from(viewModel.repetitions);
        final notStarted =
            repetitions
                .where((r) => r.status == RepetitionStatus.notStarted)
                .toList();
        final completed =
            repetitions
                .where((r) => r.status == RepetitionStatus.completed)
                .toList();
        final skipped =
            repetitions
                .where((r) => r.status == RepetitionStatus.skipped)
                .toList();

        final notStartedByCycle = _groupRepetitionsByCycle(notStarted);
        final completedByCycle = _groupRepetitionsByCycle(completed);
        final skippedByCycle = _groupRepetitionsByCycle(skipped);

        // Definieer M3 Kleurparen voor secties
        final pendingColors = (
          container: colorScheme.primaryContainer, // Of inversePrimary
          onContainer: colorScheme.onPrimaryContainer,
        );
        final completedColors = (
          container: colorScheme.tertiaryContainer, // M3 Succes mapping
          onContainer: colorScheme.onTertiaryContainer,
        );
        final skippedColors = (
          container: colorScheme.secondaryContainer, // M3 Warning mapping
          onContainer: colorScheme.onSecondaryContainer,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notStarted.isNotEmpty)
              _buildStatusSection(
                context, // Doorgeven voor thema binnenin
                'Pending',
                pendingColors, // Geef paar door
                notStartedByCycle,
                false, // isHistory
              ),
            if (completed.isNotEmpty)
              _buildStatusSection(
                context,
                'Completed',
                completedColors, // Geef paar door
                completedByCycle,
                true, // isHistory
              ),
            if (skipped.isNotEmpty)
              _buildStatusSection(
                context,
                'Skipped',
                skippedColors, // Geef paar door
                skippedByCycle,
                true, // isHistory
              ),
          ],
        );
      },
    );
  }

  Map<String, List<Repetition>> _groupRepetitionsByCycle(
    List<Repetition> repetitions,
  ) {
    // Grouping logic remains the same
    final Map<String, List<Repetition>> groupedByCycle = {};
    repetitions.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });

    int cycleIndex = 1;
    int currentGroupCount = 0;
    String currentKey = '';
    int repIndex = 0;

    while (repIndex < repetitions.length) {
      final rep = repetitions[repIndex];
      if (currentGroupCount < 5) {
        if (currentGroupCount == 0) {
          currentKey = 'Cycle $cycleIndex';
          groupedByCycle[currentKey] = [];
        }
        groupedByCycle[currentKey]!.add(rep);
        currentGroupCount++;
        repIndex++;
      } else {
        cycleIndex++;
        currentGroupCount = 0;
        // Start new cycle without incrementing repIndex
      }
    }

    // Sort repetitions within each cycle by order
    for (final key in groupedByCycle.keys) {
      groupedByCycle[key]!.sort(
        (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
      );
    }
    return groupedByCycle;
  }

  Widget _buildStatusSection(
    BuildContext context,
    String title,
    M3ColorPair colors, // Ontvangt M3 paar
    Map<String, List<Repetition>> cycleGroups,
    bool isHistory,
  ) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();

    // Haal textTheme hier op
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: AppDimens.spaceL,
            bottom: AppDimens.spaceS,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
          decoration: BoxDecoration(
            color: colors.container, // Gebruik container kleur uit paar
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          child: Text(
            title,
            // Gebruik textTheme en onContainer kleur
            style: textTheme.titleSmall?.copyWith(
              // Of labelLarge?
              color: colors.onContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Geef context door voor thema toegang in _buildCycleGroup
        for (final entry in cycleGroups.entries)
          _buildCycleGroup(context, entry.key, entry.value, isHistory),
      ],
    );
  }

  Widget _buildCycleGroup(
    BuildContext context,
    String cycleKey,
    List<Repetition> repetitions,
    bool isHistory,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isCurrentCycle = _isCurrentCycle(repetitions);
    final cycleNumber = int.tryParse(cycleKey.replaceAll('Cycle ', '')) ?? 1;
    final cycleName =
        isCurrentCycle
            ? widget.currentCycleStudied
            : _mapNumberToCycleStudied(cycleNumber);

    // Haal M3 Kleurpaar voor cycle badge op
    final cycleColors = _getCycleColors(cycleName, colorScheme);

    // Kleurpaar voor 'Current' badge
    final currentBadgeColors = (
      container: colorScheme.tertiaryContainer, // Bv. Tertiary voor highlight
      onContainer: colorScheme.onTertiaryContainer,
    );

    return Container(
      margin: const EdgeInsets.only(
        left: AppDimens.paddingM, // Inspringen van cycle groep
        bottom: AppDimens.spaceL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: AppDimens.spaceS),
            child: Row(
              children: [
                // Cycle Name Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                    vertical: AppDimens.paddingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: cycleColors.container, // Gebruik thema-kleur
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                  child: Text(
                    _formatCycleStudied(cycleName),
                    // Gebruik textTheme en thema-kleur
                    style: textTheme.labelSmall?.copyWith(
                      // labelSmall is passend
                      color: cycleColors.onContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 'Current' Badge (indien van toepassing)
                if (isCurrentCycle) ...[
                  const SizedBox(width: AppDimens.spaceS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingXS,
                      vertical: AppDimens.paddingXXS,
                    ),
                    decoration: BoxDecoration(
                      color:
                          currentBadgeColors.container, // Gebruik thema-kleur
                      borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                    ),
                    child: Text(
                      'Current',
                      // Gebruik textTheme en thema-kleur
                      style: textTheme.labelSmall?.copyWith(
                        color: currentBadgeColors.onContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Repetition Cards (deze gebruiken al thema)
          for (final repetition in repetitions)
            RepetitionCard(
              repetition: repetition,
              isHistory: isHistory,
              // Callbacks ongewijzigd, maar gebruiken nu geen hardcoded kleuren meer intern
              onMarkCompleted:
                  isHistory
                      ? null
                      : () => widget.onMarkCompleted(repetition.id),
              onSkip:
                  isHistory ? null : () => widget.onMarkSkipped(repetition.id),
              onReschedule:
                  isHistory
                      ? null
                      : () => _showReschedulePicker(context, repetition.id),
            ),
        ],
      ),
    );
  }

  bool _isCurrentCycle(List<Repetition> repetitions) {
    // Logic remains the same
    if (repetitions.isEmpty) {
      return false;
    }
    // Check if any repetition in this group is 'notStarted'
    // AND if the overall module's current cycle (passed via widget)
    // is not the very first one (meaning reviews have started).
    return repetitions.any((r) => r.status == RepetitionStatus.notStarted) &&
        widget.currentCycleStudied != CycleStudied.firstTime;
  }

  CycleStudied _mapNumberToCycleStudied(int number) {
    // Logic remains the same
    switch (number) {
      case 1:
        return CycleStudied.firstTime;
      case 2:
        return CycleStudied.firstReview;
      case 3:
        return CycleStudied.secondReview;
      case 4:
        return CycleStudied.thirdReview;
      default:
        return CycleStudied.moreThanThreeReviews;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    // AppButton wordt verondersteld thema-bewust te zijn
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXL),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No review schedule found for this module',
              style:
                  Theme.of(context).textTheme.bodyMedium, // Gebruik thema stijl
            ),
            const SizedBox(height: AppDimens.spaceM),
            AppButton(
              text: 'Create Review Schedule',
              type: AppButtonType.primary, // Aanname: AppButton gebruikt thema
              onPressed: () async {
                final viewModel = context.read<RepetitionViewModel>();
                await viewModel.createDefaultSchedule(widget.progressId);
                await widget.onReload(); // Reload data after creation
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReschedulePicker(
    BuildContext context,
    String repetitionId,
  ) async {
    // showDatePicker is van nature thema-bewust
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(), // Kan niet in het verleden plannen
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ), // Bv. max 1 jaar vooruit
    );

    if (date != null && context.mounted) {
      await widget.onReschedule(repetitionId, date);
    }
  }

  String _formatCycleStudied(CycleStudied cycle) {
    // Logic remains the same
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'Initial';
      case CycleStudied.firstReview:
        return 'Review 1';
      case CycleStudied.secondReview:
        return 'Review 2';
      case CycleStudied.thirdReview:
        return 'Review 3';
      case CycleStudied.moreThanThreeReviews:
        return 'Review 4+';
    }
  }

  // --- VERVANGEN: Gebruik ColorScheme voor Cycle Kleuren ---
  M3ColorPair _getCycleColors(CycleStudied cycle, ColorScheme colorScheme) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return (
          // Bv. Primary
          container: colorScheme.primaryContainer,
          onContainer: colorScheme.onPrimaryContainer,
        );
      case CycleStudied.firstReview:
        return (
          // Bv. Secondary
          container: colorScheme.secondaryContainer,
          onContainer: colorScheme.onSecondaryContainer,
        );
      case CycleStudied.secondReview:
        return (
          // Bv. Tertiary
          container: colorScheme.tertiaryContainer,
          onContainer: colorScheme.onTertiaryContainer,
        );
      case CycleStudied.thirdReview:
        return (
          // Bv. Een subtielere Surface variant
          container: colorScheme.surfaceContainerHighest,
          onContainer: colorScheme.onSurfaceVariant,
        );
      case CycleStudied.moreThanThreeReviews:
        return (
          // Nog subtieler
          container: colorScheme.surfaceContainerHigh,
          onContainer: colorScheme.onSurfaceVariant,
        );
    }
  }

  // --- Einde Vervanging ---
}
