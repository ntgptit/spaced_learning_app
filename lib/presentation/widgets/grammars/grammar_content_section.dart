// lib/presentation/widgets/grammars/grammar_content_section.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

class GrammarContentSection extends StatelessWidget {
  final GrammarDetail grammar;

  const GrammarContentSection({super.key, required this.grammar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Definition Section
        if (grammar.definition != null && grammar.definition!.isNotEmpty) ...[
          _buildSection(
            title: 'Definition',
            content: grammar.definition!,
            icon: Icons.article_outlined,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.primary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Structure Section
        if (grammar.structure != null && grammar.structure!.isNotEmpty) ...[
          _buildSection(
            title: 'Structure',
            content: grammar.structure!,
            icon: Icons.architecture_outlined,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.tertiary,
            isStructure: true, // Special formatting for structure
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Conjugation Section
        if (grammar.conjugation != null && grammar.conjugation!.isNotEmpty) ...[
          _buildSection(
            title: 'Conjugation',
            content: grammar.conjugation!,
            icon: Icons.compare_arrows_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.secondary,
            isConjugation: true, // Special formatting for conjugation tables
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Examples Section
        if (grammar.examples != null && grammar.examples!.isNotEmpty) ...[
          _buildSection(
            title: 'Examples',
            content: grammar.examples!,
            icon: Icons.format_quote_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.primary,
            isList: true, // Assume examples are a list
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Common Phrases Section
        if (grammar.commonPhrases != null &&
            grammar.commonPhrases!.isNotEmpty) ...[
          _buildSection(
            title: 'Common Phrases',
            content: grammar.commonPhrases!,
            icon: Icons.chat_bubble_outline_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.tertiary,
            isList: true, // Assume common phrases are a list
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Notes Section
        if (grammar.notes != null && grammar.notes!.isNotEmpty) ...[
          _buildSection(
            title: 'Usage Notes',
            content: grammar.notes!,
            icon: Icons.lightbulb_outline_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.secondary,
          ),
        ],
      ],
    );
  }

  // Helper widget to build each content section
  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color iconColor,
    bool isList = false,
    bool isNumbered = false,
    bool isStructure = false,
    bool isConjugation = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (Icon and Title)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingS),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppDimens.iconM + 2, color: iconColor),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Content Card with formatted content
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainerLowest,
          elevation: AppDimens.elevationNone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          applyOuterShadow: false,
          child: _buildFormattedContent(
            content: content,
            theme: theme,
            colorScheme: colorScheme,
            isList: isList,
            isNumbered: isNumbered,
            isStructure: isStructure,
            isConjugation: isConjugation,
          ),
        ),
      ],
    );
  }

  // Format content based on type
  Widget _buildFormattedContent({
    required String content,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isList,
    required bool isNumbered,
    required bool isStructure,
    required bool isConjugation,
  }) {
    // Check for multiline content that should be a list
    final lines = content.split('\n');
    final bool isMultiline = lines.length > 1;

    // Detect content format
    final bool shouldBeBulletList =
        isList ||
        _detectBulletList(content) ||
        (isMultiline && _hasBulletListIndicators(lines));

    final bool shouldBeNumberedList =
        isNumbered ||
        _detectNumberedList(content) ||
        (isMultiline && _hasNumberedListIndicators(lines));

    // Special case for structure and conjugation
    if (isStructure) {
      return _buildStructureContent(content, theme, colorScheme);
    }

    if (isConjugation) {
      return _buildConjugationTable(content, theme, colorScheme);
    }

    // If it should be bullet list
    if (shouldBeBulletList) {
      return _buildBulletList(content, theme, colorScheme);
    }

    // If it should be numbered list
    if (shouldBeNumberedList) {
      return _buildNumberedList(content, theme, colorScheme);
    }

    // Regular text with paragraph formatting
    return _buildParagraphText(content, theme, colorScheme);
  }

  // Regular paragraph text with formatting
  Widget _buildParagraphText(
    String content,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final formattedContent = _formatTextWithEmphasis(
      content,
      theme,
      colorScheme,
    );

    return Text(
      content,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
        height: 1.6,
      ),
    );
  }

  // Detect if content appears to be a bullet list
  bool _detectBulletList(String content) {
    // Check for common bullet indicators
    return content.contains('• ') ||
        content.contains('* ') ||
        content.contains('- ') ||
        RegExp(r'^\s*[•\-\*]\s').hasMatch(content);
  }

  // Check if lines have bullet indicators
  bool _hasBulletListIndicators(List<String> lines) {
    int bulletCount = 0;
    for (final line in lines) {
      if (line.trim().startsWith('• ') ||
          line.trim().startsWith('* ') ||
          line.trim().startsWith('- ')) {
        bulletCount++;
      }
    }
    // If at least half the lines look like bullets, it's probably a list
    return bulletCount >= lines.length / 2;
  }

  // Detect if content appears to be a numbered list
  bool _detectNumberedList(String content) {
    // Check for numbered list patterns like "1. " or "1) "
    return RegExp(r'^\s*\d+[\.\)]\s').hasMatch(content) ||
        content.contains(RegExp(r'\n\s*\d+[\.\)]\s'));
  }

  // Check if lines have numbered indicators
  bool _hasNumberedListIndicators(List<String> lines) {
    int numberedCount = 0;
    for (final line in lines) {
      if (RegExp(r'^\s*\d+[\.\)]\s').hasMatch(line)) {
        numberedCount++;
      }
    }
    // If at least half the lines look like numbers, it's probably a list
    return numberedCount >= lines.length / 2;
  }

  // Build bullet point list
  Widget _buildBulletList(
    String content,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final List<String> items = _extractListItems(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        String cleanItem = item.trim();

        // Remove bullet indicators if present
        if (cleanItem.startsWith('• ')) {
          cleanItem = cleanItem.substring(2);
        } else if (cleanItem.startsWith('* ')) {
          cleanItem = cleanItem.substring(2);
        } else if (cleanItem.startsWith('- ')) {
          cleanItem = cleanItem.substring(2);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: Text(
                  cleanItem,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Build numbered list
  Widget _buildNumberedList(
    String content,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final List<String> items = _extractListItems(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final int index = entry.key;
        String item = entry.value.trim();

        // Remove existing numbers if present
        if (RegExp(r'^\d+[\.\)]\s').hasMatch(item)) {
          item = item.replaceFirst(RegExp(r'^\d+[\.\)]\s'), '');
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '${index + 1}.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Text(
                  item,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Extract list items from content
  List<String> _extractListItems(String content) {
    // Split by newlines and filter out empty lines
    final List<String> lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return lines;
  }

  // Format text with emphasis for key elements
  RichText _formatTextWithEmphasis(
    String text,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Identify patterns to emphasize - placeholder for more advanced logic

    // For now, just return the whole text with default style
    return RichText(
      text: TextSpan(
        text: text,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.6,
        ),
      ),
    );
  }

  // Build formatted structure content with patterns highlighted
  Widget _buildStructureContent(
    String content,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Structure content often has patterns that should be highlighted

    final lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        // Check if line contains a pattern definition (look for ":" or "=")
        if (line.contains(':') || line.contains('=')) {
          final parts = line.contains(':') ? line.split(':') : line.split('=');

          if (parts.length >= 2) {
            final label = parts[0].trim();
            final value = parts.sublist(1).join(':').trim();

            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }

        // Format important patterns (often in brackets or quotes)
        if (line.contains('[') && line.contains(']') ||
            line.contains('(') && line.contains(')') ||
            line.contains('"') ||
            line.contains("'")) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
            child: _buildPatternHighlight(line, theme, colorScheme),
          );
        }

        // Default formatting for other lines
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
          child: Text(
            line,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Highlight patterns in structure text
  Widget _buildPatternHighlight(
    String line,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Simple implementation - a more sophisticated version would use RegExp to identify all patterns
    final bool hasSquareBrackets = line.contains('[') && line.contains(']');
    final bool hasRoundBrackets = line.contains('(') && line.contains(')');
    final bool hasQuotes = line.contains('"') || line.contains("'");

    // Simplified version - just add a background to the whole line
    // A more complete implementation would highlight just the patterns
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingS),
      decoration: BoxDecoration(
        color: hasSquareBrackets || hasRoundBrackets
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : (hasQuotes
                  ? colorScheme.tertiaryContainer.withOpacity(0.3)
                  : Colors.transparent),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Text(
        line,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: hasSquareBrackets || hasRoundBrackets || hasQuotes
              ? FontWeight.w500
              : FontWeight.normal,
          height: 1.5,
        ),
      ),
    );
  }

  // Build conjugation table for verb forms, tenses, etc.
  Widget _buildConjugationTable(
    String content,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Try to detect if this is a tabular structure
    final bool looksLikeTable = lines.any(
      (line) =>
          line.contains('\t') ||
          (line.contains('|') && line.split('|').length > 1),
    );

    if (looksLikeTable) {
      return _buildDataTable(lines, theme, colorScheme);
    }

    // Fallback: Format as definition list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        // Try to split on common separators
        List<String> parts = [];
        if (line.contains(':')) {
          parts = line.split(':');
        } else if (line.contains(' - ')) {
          parts = line.split(' - ');
        } else if (line.contains('=')) {
          parts = line.split('=');
        }

        if (parts.length >= 2) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    parts[0].trim(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    parts.sublist(1).join(':').trim(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Default formatting for lines that don't match the pattern
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
          child: Text(
            line,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build a data table from content
  Widget _buildDataTable(
    List<String> lines,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Determine the separator (tab or pipe)
    final String separator = lines.first.contains('|') ? '|' : '\t';

    // Extract header row if present (usually the first line)
    List<String> headers = lines.isNotEmpty
        ? _splitTableRow(lines.first, separator)
        : [];

    // Build rows
    List<List<String>> rows = [];
    for (int i = 1; i < lines.length; i++) {
      if (lines[i].trim().isNotEmpty) {
        rows.add(_splitTableRow(lines[i], separator));
      }
    }

    // If there's no data beyond the header, possibly use the header as first row
    if (rows.isEmpty && headers.isNotEmpty) {
      rows = [headers];
      headers = [];
    }

    // Find the maximum number of columns
    int maxColumns = headers.length;
    for (final row in rows) {
      if (row.length > maxColumns) {
        maxColumns = row.length;
      }
    }

    // Build the table
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
          color: colorScheme.outlineVariant,
          width: 1,
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header row if present
          if (headers.isNotEmpty)
            TableRow(
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              children: headers
                  .map(
                    (header) => TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingM),
                        child: Text(
                          header,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

          // Data rows
          ...rows.map((row) {
            // Pad the row if it has fewer columns than the maximum
            final paddedRow = row.length < maxColumns
                ? [...row, ...List.filled(maxColumns - row.length, '')]
                : row;

            return TableRow(
              children: paddedRow
                  .map(
                    (cell) => TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingM),
                        child: Text(
                          cell,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  // Split a table row into cells, handling the separator
  List<String> _splitTableRow(String line, String separator) {
    // For pipe separator, need to handle empty cells properly
    if (separator == '|') {
      // Remove leading and trailing pipes
      final trimmed = line.trim().startsWith('|')
          ? line.trim().substring(1)
          : line.trim();
      final endTrimmed = trimmed.endsWith('|')
          ? trimmed.substring(0, trimmed.length - 1)
          : trimmed;

      return endTrimmed.split('|').map((cell) => cell.trim()).toList();
    }

    // For tab separator
    return line.split(separator).map((cell) => cell.trim()).toList();
  }
}
