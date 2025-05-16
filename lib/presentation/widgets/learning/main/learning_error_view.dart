// lib/presentation/widgets/learning/main/learning_error_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_error_state_widget.dart';

class LearningErrorView extends ConsumerWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const LearningErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SlErrorStateWidget(
      title: 'Could not load learning data',
      message: errorMessage,
      icon: Icons.error_outline,
      onRetry: onRetry,
      retryText: 'Try Again',
    );
  }
}
