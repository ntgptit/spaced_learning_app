// import 'package:flutter/material.dart';
// import 'package:spaced_learning_app/core/theme/app_dimens.dart';

// class FooterActionsSection extends StatelessWidget {
//   final VoidCallback? onHelpPressed;
//   final VoidCallback? onSettingsPressed;
//   final VoidCallback? onFeedbackPressed;

//   const FooterActionsSection({
//     super.key,
//     this.onHelpPressed,
//     this.onSettingsPressed,
//     this.onFeedbackPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         if (onSettingsPressed != null)
//           _buildActionButton(
//             context: context,
//             icon: Icons.settings_outlined,
//             tooltip: 'Settings',
//             onPressed: onSettingsPressed,
//           ),
//         if (onFeedbackPressed != null)
//           _buildActionButton(
//             context: context,
//             icon: Icons.feedback_outlined,
//             tooltip: 'Send feedback',
//             onPressed: onFeedbackPressed,
//           ),
//         if (onHelpPressed != null)
//           _buildActionButton(
//             context: context,
//             icon: Icons.help_outline,
//             tooltip: 'Help',
//             onPressed: onHelpPressed,
//           ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required BuildContext context,
//     required IconData icon,
//     required String tooltip,
//     required VoidCallback? onPressed,
//   }) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingXS),
//       child: Tooltip(
//         message: tooltip,
//         child: IconButton(
//           onPressed: onPressed,
//           icon: Icon(icon),
//           iconSize: AppDimens.iconL,
//           style: IconButton.styleFrom(
//             backgroundColor: colorScheme.surfaceContainerHighest,
//             foregroundColor: colorScheme.onSurface,
//             padding: const EdgeInsets.all(AppDimens.paddingM),
//             fixedSize: const Size(
//               AppDimens.iconXL + AppDimens.paddingL,
//               AppDimens.iconXL + AppDimens.paddingL,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
