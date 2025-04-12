import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/books/stat_item.dart';

class BookOverviewStatBlock extends StatelessWidget {
  final int totalModules;
  final String completion;
  final String estTime;
  final ColorScheme colorScheme;

  const BookOverviewStatBlock({
    super.key,
    required this.totalModules,
    required this.completion,
    required this.estTime,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 320;
        return Flex(
          direction: isNarrow ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatItemWidget(
              value: totalModules.toString(),
              label: 'Modules',
              icon: Icons.menu_book_outlined,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppDimens.spaceS, width: AppDimens.spaceS),
            StatItemWidget(
              value: completion,
              label: 'Complete',
              icon: Icons.bar_chart,
              color: colorScheme.tertiary,
            ),
            const SizedBox(height: AppDimens.spaceS, width: AppDimens.spaceS),
            StatItemWidget(
              value: estTime,
              label: 'Est. Time',
              icon: Icons.schedule,
              color: colorScheme.secondary,
            ),
          ],
        );
      },
    );
  }
}
