import 'package:flutter/material.dart';

class LearningAppBar extends StatelessWidget {
  final bool isScrolled;
  final VoidCallback onRefresh;
  final VoidCallback onHelp;

  const LearningAppBar({
    super.key,
    required this.isScrolled,
    required this.onRefresh,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      title: const Text('Learning Progress'),
      pinned: true,
      floating: true,
      elevation: isScrolled ? 4 : 0,
      shadowColor: Colors.black26,
      backgroundColor:
          isScrolled
              ? colorScheme.surface
              : colorScheme.surface.withOpacity(0.95),
      foregroundColor: colorScheme.onSurface,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh data',
          onPressed: onRefresh,
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Help',
          onPressed: onHelp,
        ),
      ],
    );
  }
}
