import 'package:flutter/material.dart';

/// Screen providing information about the spaced repetition learning method
class SpacedRepetitionInfoScreen extends StatelessWidget {
  const SpacedRepetitionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Spaced Repetition Method')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            theme,
            'Understanding the Spaced Repetition Cycle',
            isMainTitle: true,
          ),
          _buildSection(
            theme,
            'What is Spaced Repetition?',
            'Spaced Repetition is a learning technique based on scientific research, '
                'designed to optimize memory retention through scheduled reviews with increasing intervals.',
          ),
          _buildSection(
            theme,
            'What is a Study Cycle?',
            'In this app, each study cycle consists of 5 reviews. You must complete all 5 repetitions '
                'before moving to the next cycle. Each cycle reinforces knowledge deeper into your long-term memory.',
          ),
          _buildCyclesSection(theme),
          _buildSection(
            theme,
            'The Spaced Repetition Algorithm',
            'This app uses an advanced spaced repetition algorithm that takes into account various factors like: '
                'number of words in the module, learning progress, current cycle, and number of completed repetitions '
                'to calculate the optimal time between reviews.',
          ),
          _buildFormulaSection(theme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme,
    String title, {
    bool isMainTitle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              isMainTitle
                  ? theme.textTheme.headlineSmall
                  : theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(content, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCyclesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Study Cycles', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        _buildCycleItem(
          theme,
          'First Cycle',
          'This is your first time studying this module. Complete the first 5 review sessions.',
        ),
        _buildCycleItem(
          theme,
          'First Review Cycle',
          'After completing the first cycle, you will move into the first review cycle with 5 new reviews.',
        ),
        _buildCycleItem(
          theme,
          'Second Review Cycle',
          'Review intervals become longer to challenge your memory retention.',
        ),
        _buildCycleItem(
          theme,
          'Third Review Cycle',
          'By this point, the knowledge should be well embedded in your long-term memory.',
        ),
        _buildCycleItem(
          theme,
          'More than 3 Cycles',
          'You’ve mastered this module! Further reviews are just for retention.',
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCycleItem(ThemeData theme, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 12, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calculation Formula', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'The interval between repetitions is calculated using the formula:\n\n'
            '- Base Interval = Word Factor × Min(31, Cycle × Review Factor) × Progress Factor\n\n'
            'And the factors are defined as:\n'
            '- Word Factor: depends on the number of words in the module\n'
            '- Cycle: based on the current study cycle\n'
            '- Review Factor: increases with each repetition\n'
            '- Progress Factor: based on completion percentage',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
