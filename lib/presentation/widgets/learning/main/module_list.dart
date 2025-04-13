import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/module_card.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/module_list_header.dart';

class ModuleList extends StatelessWidget {
  final List<dynamic> modules;
  final ScrollController? scrollController;
  final VoidCallback onRefresh;

  const ModuleList({
    super.key,
    required this.modules,
    this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (modules.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100), // Extra space for footer
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: modules.length + 1, // Adding header
        itemBuilder: (context, index) {
          if (index == 0) {
            return const ModuleListHeader();
          }

          final moduleIndex = index - 1;
          final module = modules[moduleIndex];
          return ModuleCard(module: module, index: moduleIndex);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No modules found',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or check back later',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                if (scrollController != null) {
                  scrollController!.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
              icon: const Icon(Icons.filter_alt),
              label: const Text('Change filters'),
            ),
          ],
        ),
      ),
    );
  }
}
