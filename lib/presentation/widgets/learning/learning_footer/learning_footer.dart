// import 'package:flutter/material.dart';
// import 'package:spaced_learning_app/core/theme/app_dimens.dart';
// import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/footer_actions_section.dart';
// import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/footer_progress_section.dart';

// class LearningFooter extends StatefulWidget {
//   final int totalModules;
//   final int completedModules;
//   final VoidCallback? onHelpPressed;
//   final VoidCallback? onSettingsPressed;
//   final VoidCallback? onFeedbackPressed;

//   const LearningFooter({
//     super.key,
//     required this.totalModules,
//     required this.completedModules,
//     this.onHelpPressed,
//     this.onSettingsPressed,
//     this.onFeedbackPressed,
//   });

//   @override
//   State<LearningFooter> createState() => _LearningFooterState();
// }

// class _LearningFooterState extends State<LearningFooter> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < AppDimens.breakpointS;

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(AppDimens.radiusXXL),
//           topRight: Radius.circular(AppDimens.radiusXXL),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.shadow.withValues(alpha:AppDimens.opacityMedium),
//             blurRadius: AppDimens.shadowRadiusL,
//             offset: const Offset(0, -AppDimens.shadowOffsetM),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Drag handle
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: AppDimens.paddingS,
//                 horizontal: AppDimens.paddingL,
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: AppDimens.spaceS),
//                     width: AppDimens.moduleIndicatorSize,
//                     height: AppDimens.dividerThickness * 2,
//                     decoration: BoxDecoration(
//                       color: colorScheme.outlineVariant,
//                       borderRadius: BorderRadius.circular(AppDimens.radiusXXS),
//                     ),
//                   ),
//                   Icon(
//                     _isExpanded
//                         ? Icons.keyboard_arrow_down
//                         : Icons.keyboard_arrow_up,
//                     size: AppDimens.iconM,
//                     color: colorScheme.onSurfaceVariant,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Expandable content
//           AnimatedContainer(
//             duration: const Duration(milliseconds: AppDimens.durationM),
//             height: _isExpanded ? null : 0,
//             curve: Curves.easeInOut,
//             child: ClipRect(
//               child: Visibility(
//                 visible: _isExpanded,
//                 maintainState: true,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(
//                     AppDimens.paddingL,
//                     0,
//                     AppDimens.paddingL,
//                     AppDimens.paddingL,
//                   ),
//                   child:
//                       isSmallScreen
//                           ? _buildSmallScreenLayout()
//                           : _buildWideScreenLayout(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSmallScreenLayout() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FooterProgressSection(
//           totalModules: widget.totalModules,
//           completedModules: widget.completedModules,
//         ),
//         const SizedBox(height: AppDimens.spaceL),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: FooterActionsSection(
//             onHelpPressed: widget.onHelpPressed,
//             onSettingsPressed: widget.onSettingsPressed,
//             onFeedbackPressed: widget.onFeedbackPressed,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWideScreenLayout() {
//     return Row(
//       children: [
//         Expanded(
//           child: FooterProgressSection(
//             totalModules: widget.totalModules,
//             completedModules: widget.completedModules,
//           ),
//         ),
//         FooterActionsSection(
//           onHelpPressed: widget.onHelpPressed,
//           onSettingsPressed: widget.onSettingsPressed,
//           onFeedbackPressed: widget.onFeedbackPressed,
//         ),
//       ],
//     );
//   }
// }
