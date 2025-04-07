import 'package:flutter/material.dart';
// Import AppColors nếu bạn muốn dùng màu success thay vì primary cho điểm số
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Dialog content for inputting test scores, styled with AppTheme.
class ScoreInputDialogContent extends StatefulWidget {
  // Chuyển thành StatefulWidget để quản lý Slider và TextField tốt hơn nếu cần
  final double initialScore;
  final ValueChanged<double> onScoreChangedFinal; // Callback khi xác nhận

  const ScoreInputDialogContent({
    super.key,
    required this.initialScore,
    required this.onScoreChangedFinal,
    required double currentScore,
    required TextEditingController controller,
    required Null Function(dynamic newScore) onScoreChanged,
  });

  @override
  State<ScoreInputDialogContent> createState() =>
      _ScoreInputDialogContentState();
}

class _ScoreInputDialogContentState extends State<ScoreInputDialogContent> {
  late double _currentScore;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentScore = widget.initialScore;
    // Khởi tạo controller với giá trị ban đầu, làm tròn nếu cần
    _controller = TextEditingController(text: _currentScore.toInt().toString());
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _updateScore(double newScore) {
    // Clamp score between 0 and 100
    final clampedScore = newScore.clamp(0.0, 100.0);
    if (_currentScore != clampedScore) {
      setState(() {
        _currentScore = clampedScore;
        // Cập nhật TextField, làm tròn thành int để tránh số thập phân không mong muốn
        final scoreInt = clampedScore.toInt();
        final textValue = scoreInt.toString();
        // Chỉ cập nhật nếu text khác để tránh vòng lặp vô hạn
        if (_controller.text != textValue) {
          // Lưu vị trí con trỏ
          final selection = _controller.selection;
          _controller.text = textValue;
          // Khôi phục vị trí con trỏ (nếu hợp lệ)
          try {
            _controller.selection = selection.copyWith(
              baseOffset: selection.baseOffset.clamp(0, textValue.length),
              extentOffset: selection.extentOffset.clamp(0, textValue.length),
            );
          } catch (e) {
            // Bỏ qua lỗi nếu vị trí con trỏ không hợp lệ sau khi thay đổi text
          }
        }
      });
      // Có thể gọi callback ở đây nếu muốn cập nhật ngay lập tức thay vì chỉ khi ấn OK
      // widget.onScoreChangedFinal(clampedScore);
    }
  }

  void _onTextChanged() {
    final value = double.tryParse(_controller.text);
    if (value != null && value != _currentScore) {
      _updateScore(value);
    } else if (_controller.text.isEmpty) {
      // Optionally handle empty text field, maybe reset score or show error?
      // For now, let's keep the score as is until a valid number is entered.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Style cho điểm số lớn, sử dụng theme
    final scoreTextStyle = textTheme.displaySmall?.copyWith(
      // hoặc headlineLarge/Medium
      fontWeight: FontWeight.bold,
      color: colorScheme.primary, // Sử dụng màu primary từ theme
      // Hoặc dùng màu success: color: isDark ? AppColors.successDark : AppColors.successLight,
    );

    return SingleChildScrollView(
      // Thêm SingleChildScrollView để tránh overflow nếu nội dung dài
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch, // Căn chỉnh các thành phần con theo chiều ngang
        children: [
          Text(
            'Enter the score from your test on Quizlet or another tool:',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant, // Đặt màu rõ ràng
            ),
            textAlign: TextAlign.center, // Căn giữa cho đẹp hơn
          ),
          const SizedBox(height: AppDimens.spaceL),
          Text(
            '${_currentScore.toInt()}%', // Hiển thị điểm hiện tại
            style: scoreTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceS), // Giảm khoảng cách một chút
          Slider(
            value: _currentScore,
            min: 0,
            max: 100,
            divisions: 100, // Chia nhỏ hơn để kéo mượt hơn
            label: '${_currentScore.toInt()}%', // Label hiển thị khi kéo
            // Slider sẽ tự lấy màu từ SliderTheme (dùng colorScheme.primary)
            onChanged: _updateScore, // Gọi hàm cập nhật state
          ),
          // const SizedBox(height: AppDimens.spaceM), // Có thể bỏ SizedBox này
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingS,
            ), // Thêm padding cho Row này
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Căn giữa TextField và Text
              children: [
                Text(
                  'Exact score: ',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant, // Đặt màu rõ ràng
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS), // Thêm khoảng cách
                Expanded(
                  child: IntrinsicWidth(
                    // Giúp TextField không chiếm quá nhiều không gian
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ), // Chỉ cho nhập số nguyên
                      textAlign:
                          TextAlign.center, // Căn giữa text trong TextField
                      maxLength: 3, // Giới hạn tối đa 3 ký tự (100)
                      decoration: const InputDecoration(
                        suffixText: '%',
                        counterText: '', // Ẩn bộ đếm ký tự
                        // Để TextField sử dụng border từ inputDecorationTheme chung
                        // Không cần định nghĩa 'border' ở đây nữa
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(AppDimens.radiusS),
                        // ),
                        // Giảm padding để TextField nhỏ gọn hơn
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingS,
                          vertical: AppDimens.paddingXXS,
                        ),
                        isDense: true, // Làm cho TextField nhỏ hơn
                      ),
                      // onChanged đã được xử lý bởi listener của controller
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: AppDimens.spaceL,
          ), // Tăng khoảng cách trước các nút
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Phân bố đều các nút
            children: _buildScoreButtons(
              colorScheme,
              textTheme,
            ), // Truyền theme vào
          ),
          // Có thể thêm nút OK/Cancel ở đây nếu dialog không tự cung cấp
          // const SizedBox(height: AppDimens.spaceL),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          //     ElevatedButton(onPressed: () {
          //        widget.onScoreChangedFinal(_currentScore);
          //        Navigator.pop(context);
          //     }, child: const Text('OK')),
          //   ],
          // )
        ],
      ),
    );
  }

  List<Widget> _buildScoreButtons(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    const scoreOptions = [0, 25, 50, 75, 100];

    return scoreOptions.map((score) {
      // So sánh int để tránh lỗi dấu phẩy động
      final isSelected = _currentScore.round() == score;
      return Flexible(
        // Dùng Flexible để các nút có thể co giãn nếu cần
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXXS,
          ), // Thêm khoảng cách nhỏ giữa các nút
          child: _ScoreButton(
            score: score,
            isSelected: isSelected,
            onTap:
                () => _updateScore(score.toDouble()), // Gọi hàm cập nhật state
            // Truyền colorScheme và textTheme vào _ScoreButton
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
      );
    }).toList();
  }
}

/// A button for quickly selecting predefined scores (Styled with M3)
class _ScoreButton extends StatelessWidget {
  final int score;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme; // Nhận ColorScheme
  final TextTheme textTheme; // Nhận TextTheme

  const _ScoreButton({
    required this.score,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định màu nền và màu chữ dựa trên trạng thái isSelected
    final Color bgColor =
        isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final Color fgColor =
        isSelected
            ? colorScheme.onPrimary
            : colorScheme
                .onSurfaceVariant; // Dùng onSurfaceVariant khi không chọn
    final Border? border =
        isSelected
            ? null // Không cần border khi được chọn (nền đã đủ nổi bật)
            : Border.all(
              color: colorScheme.outline,
            ); // Dùng màu outline khi không được chọn

    // Sử dụng style từ textTheme
    final buttonTextStyle =
        textTheme.labelLarge; // Hoặc labelMedium nếu muốn nhỏ hơn

    return Material(
      // Thêm Material để InkWell có hiệu ứng ripple đúng trên màu Container
      color:
          Colors
              .transparent, // Đặt màu trong suốt để thấy màu Container bên dưới
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDimens.radiusS,
        ), // Bo góc cho hiệu ứng ripple
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS, // Padding ngang
            vertical: AppDimens.paddingXS, // Padding dọc
          ),
          decoration: BoxDecoration(
            color: bgColor, // Màu nền dựa trên trạng thái
            borderRadius: BorderRadius.circular(AppDimens.radiusS), // Bo góc
            border: border, // Border dựa trên trạng thái
          ),
          child: Text(
            '$score%',
            textAlign: TextAlign.center, // Căn giữa text
            style: buttonTextStyle?.copyWith(
              color: fgColor, // Màu chữ dựa trên trạng thái
              fontWeight:
                  isSelected
                      ? FontWeight.bold
                      : FontWeight.normal, // Font weight thay đổi
            ),
          ),
        ),
      ),
    );
  }
}
