// // lib/presentation/widgets/progress/score_input_dialog_content.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:spaced_learning_app/core/theme/app_dimens.dart';
// import 'package:spaced_learning_app/core/theme/theme_extensions.dart';
//
// class ScoreInputDialogContent extends ConsumerStatefulWidget {
//   final ValueNotifier<double> scoreNotifier;
//
//   const ScoreInputDialogContent({super.key, required this.scoreNotifier});
//
//   @override
//   ConsumerState<ScoreInputDialogContent> createState() =>
//       _ScoreInputDialogContentState();
// }
//
// class _ScoreInputDialogContentState
//     extends ConsumerState<ScoreInputDialogContent>
//     with SingleTickerProviderStateMixin {
//   late double _currentScore;
//   late TextEditingController _controller;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentScore = widget.scoreNotifier.value.clamp(0.0, 100.0);
//     _controller = TextEditingController(text: _currentScore.toInt().toString());
//     _controller.addListener(_onTextChanged);
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: AppDimens.durationM),
//     );
//
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.removeListener(_onTextChanged);
//     _controller.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _updateScore(double newScore) {
//     final clampedScore = newScore.clamp(0.0, 100.0);
//     if (_currentScore != clampedScore) {
//       setState(() {
//         _currentScore = clampedScore;
//         widget.scoreNotifier.value = _currentScore;
//
//         final scoreInt = clampedScore.toInt();
//         final textValue = scoreInt.toString();
//         if (_controller.text != textValue) {
//           // Lưu vị trí selection hiện tại
//           final currentSelection = _controller.selection;
//
//           // Cập nhật text
//           _controller.text = textValue;
//
//           // Xử lý selection một cách an toàn
//           if (currentSelection.isValid && textValue.isNotEmpty) {
//             try {
//               final newBaseOffset = currentSelection.baseOffset.clamp(
//                 0,
//                 textValue.length,
//               );
//               final newExtentOffset = currentSelection.extentOffset.clamp(
//                 0,
//                 textValue.length,
//               );
//
//               _controller.selection = TextSelection(
//                 baseOffset: newBaseOffset,
//                 extentOffset: newExtentOffset,
//               );
//             } catch (e) {
//               // Log lỗi để debug thay vì bỏ qua
//               debugPrint('Error updating text selection: $e');
//
//               // Đặt lại selection về cuối text
//               _controller.selection = TextSelection.collapsed(
//                 offset: textValue.length,
//               );
//             }
//           } else {
//             // Nếu selection không hợp lệ, đặt lại selection về cuối text
//             _controller.selection = TextSelection.collapsed(
//               offset: textValue.length,
//             );
//           }
//         }
//       });
//     }
//   }
//
//   void _onTextChanged() {
//     final value = double.tryParse(_controller.text);
//     if (value != null && value != _currentScore) {
//       _updateScore(value);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final textTheme = theme.textTheme;
//
//     final scoreColor = Theme.of(context).getScoreColor(_currentScore);
//     final scoreTextStyle = textTheme.displaySmall?.copyWith(
//       fontWeight: FontWeight.bold,
//       color: scoreColor,
//     );
//
//     return FadeTransition(
//       opacity: _animation,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildHeader(theme, colorScheme),
//             const SizedBox(height: AppDimens.spaceL),
//             _buildScoreDisplay(scoreTextStyle, scoreColor),
//             const SizedBox(height: AppDimens.spaceS),
//             _buildSlider(colorScheme),
//             _buildExactScore(theme, colorScheme),
//             const SizedBox(height: AppDimens.spaceL),
//             _buildQuickOptions(colorScheme, textTheme),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
//     return Container(
//       padding: const EdgeInsets.all(AppDimens.paddingM),
//       decoration: BoxDecoration(
//         color: colorScheme.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(AppDimens.radiusM),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.info_outline,
//             color: colorScheme.primary,
//             size: AppDimens.iconM,
//           ),
//           const SizedBox(width: AppDimens.spaceM),
//           Expanded(
//             child: Text(
//               'Enter the score from your test on Quizlet or another tool:',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: colorScheme.onSurface,
//                 // Tăng độ tương phản từ onSurfaceVariant
//                 fontWeight:
//                     FontWeight.w500, // Tăng độ tương phản với fontWeight
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScoreDisplay(TextStyle? scoreTextStyle, Color scoreColor) {
//     return Container(
//       height: AppDimens.iconXXL * 2,
//       decoration: BoxDecoration(
//         // Tăng độ tương phản của nền bằng cách giảm độ trong suốt
//         color: scoreColor.withValues(alpha: AppDimens.opacitySemi),
//         borderRadius: BorderRadius.circular(AppDimens.radiusL),
//         // Thêm border để tăng tương phản
//         border: Border.all(
//           color: scoreColor.withValues(alpha: AppDimens.opacityHigh),
//           width: 1.5,
//         ),
//       ),
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '${_currentScore.toInt()}',
//               style: scoreTextStyle?.copyWith(
//                 // Đảm bảo text luôn sáng đối với nền sẫm của score
//                 color: _getBetterContrastTextColor(scoreColor),
//                 fontSize: 48, // Size lớn hơn để tăng khả năng đọc
//                 shadows: [
//                   Shadow(
//                     color: Colors.black.withValues(alpha: 0.2),
//                     blurRadius: 2,
//                     offset: const Offset(1, 1),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               '%',
//               style: scoreTextStyle?.copyWith(
//                 // Đảm bảo text luôn sáng đối với nền sẫm của score
//                 color: _getBetterContrastTextColor(scoreColor),
//                 fontSize: 36,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black.withValues(alpha: 0.2),
//                     blurRadius: 2,
//                     offset: const Offset(1, 1),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Hàm này giúp chọn màu text có độ tương phản tốt với màu nền
//   Color _getBetterContrastTextColor(Color backgroundColor) {
//     // Tính độ sáng của màu
//     final brightness = backgroundColor.computeLuminance();
//     // Nếu màu nền tối, trả về màu text sáng
//     return brightness > 0.5 ? Colors.black : Colors.white;
//   }
//
//   Widget _buildSlider(ColorScheme colorScheme) {
//     final sliderColor = _getScoreColor(colorScheme, _currentScore);
//
//     return SliderTheme(
//       data: SliderThemeData(
//         activeTrackColor: sliderColor,
//         thumbColor: sliderColor,
//         // Tăng kích thước của thumb để dễ nhìn và tương tác hơn
//         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
//         // Tăng kích thước của overlay để thấy rõ khi tương tác
//         overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
//         overlayColor: sliderColor.withValues(alpha: AppDimens.opacityMedium),
//         // Tăng độ dày của track để dễ nhìn hơn
//         trackHeight: 8,
//         // Tạo độ tương phản cho inactive track
//         inactiveTrackColor: colorScheme.surfaceContainerHighest,
//       ),
//       child: Slider(
//         value: _currentScore,
//         min: 0,
//         max: 100,
//         divisions: 100,
//         label: '${_currentScore.toInt()}%',
//         onChanged: _updateScore,
//       ),
//     );
//   }
//
//   Widget _buildExactScore(ThemeData theme, ColorScheme colorScheme) {
//     final scoreColor = _getScoreColor(colorScheme, _currentScore);
//     // Tính background dựa trên độ sáng của scoreColor
//     final backgroundColor = scoreColor.computeLuminance() > 0.5
//         ? scoreColor.withValues(alpha: 0.2) // chữ màu sáng → nền nhạt hơn
//         : scoreColor.withValues(alpha: 0.1); // chữ màu tối  → nền nhạt hơn
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppDimens.paddingS,
//         vertical: AppDimens.paddingM,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Exact score: ',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: colorScheme.onSurface,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: AppDimens.spaceS),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppDimens.paddingS,
//               ),
//               decoration: BoxDecoration(
//                 color: backgroundColor, // dùng màu nền đã tính
//                 borderRadius: BorderRadius.circular(AppDimens.radiusM),
//                 border: Border.all(color: scoreColor, width: 2),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 2,
//                     offset: const Offset(0, 1),
//                   ),
//                 ],
//               ),
//               child: IntrinsicWidth(
//                 child: TextField(
//                   controller: _controller,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: false,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLength: 3,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     // để không đè lên container
//                     suffixText: '%',
//                     counterText: '',
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: AppDimens.paddingM,
//                     ),
//                     border: InputBorder.none,
//                     suffixStyle: TextStyle(
//                       color: scoreColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   style: TextStyle(
//                     color: scoreColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuickOptions(ColorScheme colorScheme, TextTheme textTheme) {
//     final scoreOptions = [0, 25, 50, 75, 100];
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: scoreOptions.map((score) {
//         final isSelected = _currentScore.round() == score;
//         return _ScoreButton(
//           score: score,
//           isSelected: isSelected,
//           onTap: () => _updateScore(score.toDouble()),
//           colorScheme: colorScheme,
//           textTheme: textTheme,
//         );
//       }).toList(),
//     );
//   }
//
//   Color _getScoreColor(ColorScheme colorScheme, double score) {
//     // Tăng độ tương phản bằng cách sử dụng các màu mạnh hơn
//     if (score >= 90) return Colors.green.shade700; // Đậm hơn
//     if (score >= 75) return colorScheme.primary;
//     if (score >= 60) return colorScheme.secondary;
//     if (score >= 40) return Colors.orange.shade700; // Đậm hơn
//     return colorScheme.error;
//   }
// }
//
// class _ScoreButton extends StatelessWidget {
//   final int score;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final ColorScheme colorScheme;
//   final TextTheme textTheme;
//
//   const _ScoreButton({
//     required this.score,
//     required this.isSelected,
//     required this.onTap,
//     required this.colorScheme,
//     required this.textTheme,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final color = _getScoreColor(score);
//     // Tăng độ đậm của background khi được chọn
//     final bgColor = isSelected ? color : colorScheme.surfaceContainerHighest;
//     // Đảm bảo text luôn có màu tương phản tốt với background
//     final fgColor = isSelected ? _getContrastTextColor(color) : color;
//
//     // Border đậm hơn để tăng độ tương phản
//     final border = isSelected
//         ? null
//         : Border.all(
//             color: color,
//             width: 2.0, // Tăng độ dày để dễ nhìn hơn
//           );
//
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(AppDimens.radiusM),
//         child: Container(
//           width: AppDimens.iconXL + AppDimens.spaceS,
//           height: AppDimens.iconXL + AppDimens.spaceS,
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(AppDimens.radiusM),
//             border: border,
//             // Tăng độ rõ nét của shadow khi được chọn
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: color.withValues(alpha: AppDimens.opacityHigh),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                       spreadRadius: 1,
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Center(
//             child: Text(
//               '$score%',
//               textAlign: TextAlign.center,
//               style: textTheme.labelLarge?.copyWith(
//                 color: fgColor,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
//                 fontSize: 16, // Tăng font size để dễ đọc hơn
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Color _getScoreColor(int score) {
//     // Tăng độ tương phản bằng cách sử dụng các màu mạnh hơn
//     if (score >= 90) return Colors.green.shade700;
//     if (score >= 75) return colorScheme.primary;
//     if (score >= 60) return colorScheme.secondary;
//     if (score >= 40) return Colors.orange.shade700;
//     return colorScheme.error;
//   }
//
//   // Hàm này giúp chọn màu text có độ tương phản tốt với màu nền
//   Color _getContrastTextColor(Color backgroundColor) {
//     // Tính độ sáng của màu
//     final brightness = backgroundColor.computeLuminance();
//     // Nếu màu nền tối, trả về màu text sáng và ngược lại
//     return brightness > 0.5 ? Colors.black : Colors.white;
//   }
// }
