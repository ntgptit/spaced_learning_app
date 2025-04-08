import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Verwijder import AppColors als het niet meer nodig is na refactoring
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Aangenomen dat dit bestaat
import 'package:spaced_learning_app/domain/models/learning_module.dart'; // Zorg voor correct pad
import 'package:spaced_learning_app/presentation/screens/modules/module_detail_screen.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart'; // Zorg voor correct pad

class ModuleDetailsBottomSheet extends StatelessWidget {
  final LearningModule module;
  final String? heroTagPrefix;

  const ModuleDetailsBottomSheet({
    super.key,
    required this.module,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(
      context,
    ); // Krijgt thema (van FlexColorScheme of anderszins)
    final colorScheme = theme.colorScheme; // Haal ColorScheme op
    final textTheme = theme.textTheme; // Haal TextTheme op
    final mediaQuery = MediaQuery.of(context);
    // isDark is niet meer nodig, ColorScheme handelt dit af
    // final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: const Key('module_details_bottom_sheet'),
      // Gebruik M3 aanbevolen kleur voor bottom sheet achtergrond
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow, // Gebruik M3 rol
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusL), // Bovenste hoeken afronden
        ),
        // Schaduw/tint wordt idealiter beheerd door BottomSheetThemeData
        // (geconfigureerd door FlexColorScheme subThemes)
      ),
      // constraints moeten buiten worden ingesteld bij het aanroepen van showModalBottomSheet
      child: Column(
        mainAxisSize: MainAxisSize.min, // Krimpen naar inhoud
        children: [
          _buildDragHandle(colorScheme), // Geef alleen colorScheme door
          Flexible(
            // Toestaan dat inhoud scrollt indien nodig
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppDimens.paddingL,
                right: AppDimens.paddingL,
                bottom:
                    AppDimens.paddingXL +
                    mediaQuery.padding.bottom, // Veilige padding onderaan
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModuleTitle(
                    colorScheme,
                    textTheme,
                  ), // Geef componenten door
                  _buildBookInfo(
                    colorScheme,
                    textTheme,
                  ), // Geef componenten door
                  const Divider(height: AppDimens.paddingXXL),
                  _buildModuleDetailsSection(
                    context,
                    colorScheme,
                    textTheme, // Verwijder isDark
                  ),
                  const Divider(height: AppDimens.paddingXXL),
                  _buildDatesSection(
                    colorScheme,
                    textTheme,
                  ), // Geef componenten door
                  if (module.studyHistory?.isNotEmpty ?? false) ...[
                    const SizedBox(height: AppDimens.spaceXL),
                    _buildStudyHistorySection(
                      colorScheme,
                      textTheme,
                    ), // Geef componenten door
                  ],
                  const SizedBox(height: AppDimens.spaceXL),
                  _buildActionButtons(context), // Context is voldoende
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingM,
        bottom: AppDimens.paddingS,
      ),
      child: Container(
        key: const Key('drag_handle'),
        width: AppDimens.moduleIndicatorSize,
        height: AppDimens.dividerThickness * 2,
        decoration: BoxDecoration(
          // Gebruik M3 rol voor drag handle
          color: colorScheme.onSurfaceVariant.withOpacity(
            0.4,
          ), // Standaard M3 stijl
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
      ),
    );
  }

  Widget _buildModuleTitle(ColorScheme colorScheme, TextTheme textTheme) {
    Widget titleWidget = Text(
      module.subject.isEmpty ? 'Unnamed Module' : module.subject,
      style: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface, // Zorg voor leesbaarheid op surface
      ),
      key: const Key('module_title'),
    );

    if (heroTagPrefix != null) {
      titleWidget = Hero(
        tag: '${heroTagPrefix}_${module.id}',
        child: Material(color: Colors.transparent, child: titleWidget),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingXS),
      child: titleWidget,
    );
  }

  Widget _buildBookInfo(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingS,
        bottom: AppDimens.paddingM,
      ),
      child: Row(
        children: [
          Icon(
            Icons.book_outlined,
            color: colorScheme.primary,
            size: AppDimens.iconS,
            key: const Key('book_icon'),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Text(
              'From: ${module.book.isEmpty ? 'No Book' : module.book}',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              key: const Key('book_info'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String title, {
    IconData icon = Icons.info_outline, // Standaard icoon
    Key? key,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingM),
      child: Row(
        children: [
          Icon(icon, size: AppDimens.iconM, color: colorScheme.primary),
          const SizedBox(width: AppDimens.spaceS),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            key: key,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleDetailsSection(
    BuildContext context, // Behoud context voor MediaQuery
    ColorScheme colorScheme,
    TextTheme textTheme,
    // isDark verwijderd
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          colorScheme,
          textTheme,
          'Module Details',
          key: const Key('details_section_title'),
        ),
        Wrap(
          spacing: AppDimens.spaceL, // Horizontale afstand
          runSpacing: AppDimens.spaceL, // Verticale afstand
          children: [
            _buildDetailItem(
              context, // Doorgeven voor breedteberekening
              colorScheme,
              textTheme,
              // isDark verwijderd
              'Word Count',
              module.wordCount.toString(),
              Icons.text_fields,
              key: const Key('word_count_item'),
            ),
            _buildDetailItem(
              context, // Doorgeven
              colorScheme,
              textTheme,
              // isDark verwijderd
              'Progress',
              '${module.percentage}%',
              Icons.show_chart_outlined,
              progressValue: module.percentage / 100.0,
              key: const Key('progress_item'),
            ),
            if (module.cyclesStudied != null)
              _buildDetailItem(
                context, // Doorgeven
                colorScheme,
                textTheme,
                // isDark verwijderd
                'Cycle',
                CycleFormatter.format(module.cyclesStudied!),
                Icons.autorenew,
                // Haal kleur op via CycleFormatter, maar geef colorScheme door
                // zodat de formatter thema-bewust kan zijn.
                // OF: bepaal kleur hier op basis van cycle en colorScheme.
                color: CycleFormatter.getColor(module.cyclesStudied!, context),
                key: const Key('cycle_item'),
              ),
            if (module.taskCount != null && module.taskCount! > 0)
              _buildDetailItem(
                context, // Doorgeven
                colorScheme,
                textTheme,
                // isDark verwijderd
                'Tasks',
                module.taskCount!.toString(),
                Icons.checklist_outlined,
                key: const Key('tasks_item'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context, // Voor MediaQuery
    ColorScheme colorScheme,
    TextTheme textTheme,
    // isDark verwijderd
    String label,
    String value,
    IconData icon, {
    double? progressValue,
    Color? color, // Optionele override kleur (bijv. van CycleFormatter)
    Key? key,
  }) {
    final effectiveColor =
        color ?? colorScheme.primary; // Gebruik override of primary
    // M3 kleuren voor achtergrond en rand
    final bgColor =
        colorScheme.surfaceContainerLowest; // Zeer subtiele achtergrond
    final borderColor = colorScheme.outlineVariant; // Zeer subtiele rand

    // Responsive breedteberekening
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth =
        screenWidth - (AppDimens.paddingL * 2) - AppDimens.spaceL;
    final itemWidth = availableWidth / 2; // Ca. 2 items per rij

    // --- BELANGRIJKE WIJZIGING: Progress Bar Kleur ---
    Color progressIndicatorColor = colorScheme.error; // Standaard (laagste)
    if (progressValue != null) {
      if (progressValue >= 0.9) {
        // Gebruik Tertiary voor Succes (aanpassen indien nodig)
        progressIndicatorColor = colorScheme.tertiary;
      } else if (progressValue >= 0.7) {
        // Gebruik Secondary voor Waarschuwing (aanpassen indien nodig)
        progressIndicatorColor = colorScheme.secondary;
      }
      // Anders blijft het colorScheme.error
    }
    // --- Einde Wijziging ---

    return Container(
      key: key,
      width: itemWidth,
      constraints: const BoxConstraints(minHeight: AppDimens.thumbnailSizeS),
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: AppDimens.iconS, color: effectiveColor),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant, // Subtiele label kleur
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // Duidelijke waarde kleur
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimens.spaceS),
          // Progress Indicator (indien aanwezig)
          if (progressValue != null)
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor:
                  colorScheme.surfaceContainerHighest, // Track achtergrond
              // GEBRUIK NU DE BEREKENDE THEMA-KLEUR
              valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor),
              borderRadius: BorderRadius.circular(AppDimens.radiusXXS),
              minHeight: AppDimens.lineProgressHeight,
            )
          else
            // Placeholder om hoogte consistent te houden
            const SizedBox(height: AppDimens.lineProgressHeight),
        ],
      ),
    );
  }

  Widget _buildDatesSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          colorScheme,
          textTheme,
          'Important Dates',
          icon: Icons.calendar_month_outlined, // Ander icoon
          key: const Key('dates_section_title'),
        ),
        const SizedBox(height: AppDimens.spaceS),
        if (module.firstLearningDate != null)
          _buildDateItem(
            colorScheme,
            textTheme,
            'First Learning',
            module.firstLearningDate!,
            Icons.play_circle_outline,
            key: const Key('first_learning_date'),
          ),
        if (module.nextStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            colorScheme,
            textTheme,
            'Next Study',
            module.nextStudyDate!,
            Icons.event_available_outlined,
            // Bepaal isDue (vandaag of gisteren)
            isDue:
                DateUtils.isSameDay(module.nextStudyDate, DateTime.now()) ||
                module.nextStudyDate!.isBefore(DateTime.now()),
            key: const Key('next_study_date'),
          ),
        ],
        if (module.lastStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            colorScheme,
            textTheme,
            'Last Study',
            module.lastStudyDate!,
            Icons.history_outlined,
            key: const Key('last_study_date'),
          ),
        ],
      ],
    );
  }

  Widget _buildDateItem(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String label,
    DateTime date,
    IconData icon, {
    bool isDue = false,
    Key? key,
  }) {
    // Gebruik thema kleuren, error indien 'isDue'
    final Color effectiveColor =
        isDue ? colorScheme.error : colorScheme.primary;
    final Color labelColor = colorScheme.onSurfaceVariant;
    final Color dateColor = isDue ? colorScheme.error : colorScheme.onSurface;

    return Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: effectiveColor, size: AppDimens.iconM),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(color: labelColor),
              ),
              Text(
                DateFormat(
                  'EEEE, MMMM d, yyyy',
                ).format(date), // Volledig formaat
                style: textTheme.titleMedium?.copyWith(
                  color: dateColor,
                  fontWeight: isDue ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
        if (isDue)
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.spaceS),
            // Gebruik standaard Chip met M3 error container kleuren
            child: Chip(
              label: const Text('Due'), // Simpel label
              labelStyle: textTheme.labelSmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              backgroundColor: colorScheme.errorContainer,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              side: BorderSide.none,
            ),
          ),
      ],
    );
  }

  Widget _buildStudyHistorySection(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Sorteer en beperk geschiedenis (logica ongewijzigd)
    final studyHistory = List<DateTime>.from(module.studyHistory ?? [])
      ..sort((a, b) => b.compareTo(a));
    final displayHistory = studyHistory.take(7).toList(); // Toon max 7
    final remainingCount = studyHistory.length - displayHistory.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          colorScheme,
          textTheme,
          'Study History',
          icon: Icons.history_edu_outlined, // Ander icoon
          key: const Key('history_section_title'),
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildHistoryItems(
          colorScheme,
          textTheme,
          displayHistory,
        ), // Geef beperkte lijst door
        if (remainingCount > 0) ...[
          const SizedBox(height: AppDimens.spaceS),
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.paddingS),
            child: Text(
              '+ $remainingCount more session${remainingCount > 1 ? 's' : ''}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              key: const Key('more_sessions_text'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryItems(
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<DateTime> displayHistory, // Ontvangt al beperkte lijst
  ) {
    final today = DateUtils.dateOnly(DateTime.now());

    return Wrap(
      key: const Key('history_items'),
      spacing: AppDimens.spaceS,
      runSpacing: AppDimens.spaceS,
      children:
          displayHistory.map((date) {
            final itemDate = DateUtils.dateOnly(date);
            final isToday = itemDate.isAtSameMomentAs(today);

            // Gebruik M3 kleuren consistent
            final Color bgColor;
            final Color fgColor;
            final Border border; // Gebruik Border ipv BorderSide?

            if (isToday) {
              bgColor = colorScheme.primaryContainer;
              fgColor = colorScheme.onPrimaryContainer;
              border = Border.all(color: colorScheme.primary);
            } else {
              bgColor =
                  colorScheme
                      .surfaceContainerHighest; // Iets meer contrast dan Lowest
              fgColor = colorScheme.onSurfaceVariant;
              border = Border.all(
                color: colorScheme.outlineVariant,
              ); // Subtiele rand
            }

            final itemTextStyle = textTheme.labelMedium;

            return Tooltip(
              message: DateFormat('MMMM d, yyyy').format(date),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingM,
                  vertical: AppDimens.paddingXS, // Iets meer verticale padding
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  border: border,
                ),
                child: Text(
                  DateFormat('MMM d').format(date), // Kort formaat
                  style: itemTextStyle?.copyWith(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: fgColor,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // Knoppen gebruiken automatisch de thema's (ElevatedButtonTheme, OutlinedButtonTheme)
    // Deze thema's worden correct geconfigureerd door FlexColorScheme subThemes.
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            key: const Key('close_button'),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            onPressed: () => Navigator.pop(context),
            // Geen expliciete stijl nodig hier
          ),
          const SizedBox(width: AppDimens.spaceM),
          ElevatedButton.icon(
            key: const Key('study_button'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Studying'),
            onPressed: () {
              Navigator.pop(context); // Sluit bottom sheet
              // Navigeer naar detail scherm (logica ongewijzigd)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleDetailScreen(moduleId: module.id),
                ),
              );
            },
            // Geen expliciete stijl nodig hier
          ),
        ],
      ),
    );
  }
}
