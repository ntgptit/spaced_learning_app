// import 'package:flutter/material.dart';
// import 'package:spaced_learning_app/core/theme/app_dimens.dart';

// class FooterProgressSection extends StatelessWidget {
//   final int totalModules;
//   final int completedModules;

//   const FooterProgressSection({
//     super.key,
//     required this.totalModules,
//     required this.completedModules,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final completionPercentage = _calculateCompletionPercentage();
//     final progressSemanticLabel = _buildProgressSemanticLabel(
//       completionPercentage,
//     );
//     final double percent = double.tryParse(completionPercentage) ?? 0.0;

//     Color progressColor;
//     if (percent >= 75) {
//       progressColor = colorScheme.tertiary;
//     } else if (percent >= 50) {
//       progressColor = colorScheme.primary;
//     } else if (percent >= 25) {
//       progressColor = colorScheme.secondary;
//     } else {
//       progressColor = colorScheme.error;
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Learning Progress',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: colorScheme.onSurface,
//               ),
//             ),
//             Text(
//               '$completionPercentage%',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: progressColor,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: AppDimens.spaceS),
//         Semantics(
//           label: progressSemanticLabel,
//           child: ExcludeSemantics(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(AppDimens.radiusXS),
//               child: LinearProgressIndicator(
//                 value: percent / 100,
//                 backgroundColor: colorScheme.surfaceContainerHighest,
//                 valueColor: AlwaysStoppedAnimation<Color>(progressColor),
//                 minHeight: AppDimens.lineProgressHeight,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: AppDimens.spaceS),
//         RichText(
//           text: TextSpan(
//             style: theme.textTheme.bodySmall,
//             children: [
//               TextSpan(
//                 text: 'Completed: ',
//                 style: TextStyle(color: colorScheme.onSurfaceVariant),
//               ),
//               TextSpan(
//                 text: '$completedModules of $totalModules modules',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: colorScheme.primary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _calculateCompletionPercentage() {
//     return totalModules > 0
//         ? (completedModules / totalModules * 100).toStringAsFixed(1)
//         : '0.0';
//   }

//   String _buildProgressSemanticLabel(String completionPercentage) {
//     return 'Completed $completedModules of $totalModules modules, $completionPercentage percent complete';
//   }
// }
