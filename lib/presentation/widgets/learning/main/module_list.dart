// lib/presentation/widgets/learning/main/module_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_empty_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/module_card.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/module_list_header.dart';

class ModuleList extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (modules.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppDimens.paddingXXXL),
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: modules.length + 1,
        // Adding header
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
    return SlEmptyStateWidget(
      title: 'No Modules Available',
      message: 'Try different filters or check back later',
      icon: Icons.search_off_rounded,
      buttonText: 'Change Filters',
      onButtonPressed: () {
        if (scrollController != null) {
          scrollController!.animateTo(
            0,
            duration: const Duration(milliseconds: AppDimens.durationM),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }
}
