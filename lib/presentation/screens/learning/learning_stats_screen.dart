import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/screens/learning/detailed_learning_stats_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_insights_card.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_stats_card.dart';

class LearningStatsScreen extends StatefulWidget {
  const LearningStatsScreen({super.key});

  @override
  State<LearningStatsScreen> createState() => _LearningStatsScreenState();
}

class _LearningStatsScreenState extends State<LearningStatsScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadData();
      _isInitialized = true;
    }
  }

  Future<void> _loadData() async {
    final viewModel = context.read<LearningStatsViewModel>();
    await viewModel.loadAllStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => _loadData(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final viewModel = context.watch<LearningStatsViewModel>();

    if (viewModel.isLoading) {
      return const Center(
        child: AppProgressIndicator(
          type: ProgressType.circular,
          label: 'Loading statistics...',
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return ErrorDisplay(message: viewModel.errorMessage!, onRetry: _loadData);
    }

    if (viewModel.stats == null) {
      return const Center(child: Text('No statistics available'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LearningStatsCard(
              stats: viewModel.stats!,
              onViewDetailPressed:
                  () => _navigateToDetailedStats(
                    context,
                    'Module Statistics',
                    StatCategory.modules,
                  ),
            ),
            const SizedBox(height: AppDimens.spaceL),
            LearningInsightsCard(
              insights: viewModel.insights,
              title: 'Personal Insights',
            ),
            const SizedBox(height: AppDimens.spaceL),
            _buildCategoryCards(context),
            const SizedBox(height: AppDimens.spaceL),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCards(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingM,
          ),
          child: Text(
            'Detailed Statistics',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimens.spaceL,
          mainAxisSpacing: AppDimens.spaceL,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildCategoryCard(
              context,
              'Modules',
              Icons.auto_stories,
              colorScheme.primary,
              'View detailed module completion statistics',
              () => _navigateToDetailedStats(
                context,
                'Module Statistics',
                StatCategory.modules,
              ),
            ),
            _buildCategoryCard(
              context,
              'Due Sessions',
              Icons.calendar_today,
              colorScheme.secondary,
              'View upcoming and completed sessions',
              () => _navigateToDetailedStats(
                context,
                'Due Sessions',
                StatCategory.dueSessions,
              ),
            ),
            _buildCategoryCard(
              context,
              'Streaks',
              Icons.local_fire_department,
              colorScheme.tertiary,
              'View learning streak information',
              () => _navigateToDetailedStats(
                context,
                'Learning Streaks',
                StatCategory.streaks,
              ),
            ),
            _buildCategoryCard(
              context,
              'Vocabulary',
              Icons.menu_book,
              colorScheme.primaryContainer,
              'View vocabulary learning progress',
              () => _navigateToDetailedStats(
                context,
                'Vocabulary Progress',
                StatCategory.vocabulary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: AppDimens.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: AppDimens.iconXL),
              const SizedBox(height: AppDimens.spaceS),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXS),
              Text(
                description,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetailedStats(
    BuildContext context,
    String title,
    StatCategory category,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                DetailedLearningStatsScreen(title: title, category: category),
      ),
    );
  }
}
