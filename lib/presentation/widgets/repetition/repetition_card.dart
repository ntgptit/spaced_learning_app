import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import lại AppColors vì cần dùng màu semantic Success, Warning
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart'; // Đảm bảo đường dẫn đúng

// Định nghĩa kiểu trả về cho các hàm lấy màu M3
typedef M3ColorPair = ({Color container, Color onContainer});

/// Card đại diện cho một phiên lặp lại, được style bằng AppTheme.
class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final bool isHistory;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSkip; // Callback onSkip (nếu cần)
  final VoidCallback? onReschedule;
  final ThemeData? theme; // Optional theme override

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onSkip,
    this.onReschedule,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Lấy theme và các thành phần một lần
    final currentTheme = theme ?? Theme.of(context);
    final colorScheme = currentTheme.colorScheme;
    final textTheme = currentTheme.textTheme;
    final isDark = currentTheme.brightness == Brightness.dark;
    final dateFormat = DateFormat('dd MMM yyyy'); // Định dạng ngày

    // Lấy thông tin và màu sắc dựa trên theme
    final orderText = _formatRepetitionOrder(repetition.repetitionOrder);
    // Lấy cặp màu container/onContainer cho Status Badge
    final statusColors = _getStatusColors(
      repetition.status,
      colorScheme,
      isDark,
    );
    final dateText =
        repetition.reviewDate != null
            ? dateFormat.format(repetition.reviewDate!)
            : 'Not scheduled';
    final timeIndicator = _getTimeIndicator(repetition.reviewDate);
    // Lấy cặp màu container/onContainer cho Time Indicator
    final indicatorColors = _getTimeIndicatorColors(
      repetition.reviewDate,
      colorScheme,
      isDark,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      // CardTheme được áp dụng tự động (shape, elevation mặc định)
      // Giảm elevation và dùng màu nền khác cho item lịch sử
      elevation:
          isHistory
              ? (currentTheme.cardTheme.elevation ?? 1.0) * 0.5
              : null, // Giảm một nửa elevation mặc định
      color:
          isHistory
              ? colorScheme
                  .surfaceContainerLow // Dùng màu M3 đục thay vì alpha
              : null, // Để Card dùng màu mặc định từ theme
      child: InkWell(
        // Thêm InkWell nếu muốn cả Card có thể tap được
        onTap:
            (isHistory || repetition.status != RepetitionStatus.notStarted)
                ? null
                : onMarkCompleted, // Ví dụ: tap để complete
        borderRadius:
            ((currentTheme.cardTheme.shape as RoundedRectangleBorder?)
                    ?.borderRadius
                as BorderRadius?) ??
            BorderRadius.circular(
              AppDimens.radiusL,
            ), // Lấy từ theme hoặc fallback
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Truyền màu đã xử lý vào header
              _buildHeader(textTheme, colorScheme, orderText, statusColors),
              const SizedBox(height: AppDimens.spaceM),
              // Truyền màu đã xử lý vào date row
              _buildDateRow(
                context,
                textTheme,
                colorScheme,
                dateText,
                timeIndicator,
                indicatorColors,
              ),
              // Chỉ hiển thị actions nếu không phải history và status là notStarted
              if (!isHistory &&
                  repetition.status == RepetitionStatus.notStarted)
                _buildActions(context, colorScheme, textTheme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String orderText,
    M3ColorPair statusColors,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderText,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface, // Đặt màu rõ ràng
          ),
        ),
        // Status Badge dùng màu container/onContainer
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
          decoration: BoxDecoration(
            color: statusColors.container, // Màu nền container
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatStatus(repetition.status),
                style: textTheme.labelSmall?.copyWith(
                  // Dùng labelSmall cho badge
                  color: statusColors.onContainer, // Màu chữ onContainer
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (repetition.status == RepetitionStatus.completed) ...[
                const SizedBox(width: AppDimens.spaceXS),
                Icon(
                  Icons.check_circle_outline,
                  size: AppDimens.iconXS,
                  color: statusColors.onContainer,
                ), // Dùng check thay quiz?
              ],
              // Có thể thêm icon cho skipped nếu muốn
              if (repetition.status == RepetitionStatus.skipped) ...[
                const SizedBox(width: AppDimens.spaceXS),
                Icon(
                  Icons.redo_outlined,
                  size: AppDimens.iconXS,
                  color: statusColors.onContainer,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String dateText,
    String timeIndicator,
    M3ColorPair? indicatorColors, // Có thể null
  ) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined, // Icon calendar
          color: colorScheme.primary,
          size: AppDimens.iconS,
        ),
        const SizedBox(width: AppDimens.spaceS),
        Text(
          dateText,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant, // Dùng màu phụ
          ),
        ),
        const Spacer(), // Đẩy indicator sang phải
        // Chỉ hiển thị indicator nếu có màu và text
        if (indicatorColors != null && timeIndicator.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingS,
              vertical: AppDimens.paddingXXS,
            ),
            decoration: BoxDecoration(
              color: indicatorColors.container, // Màu nền container
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
            ),
            child: Text(
              timeIndicator,
              style: textTheme.labelSmall?.copyWith(
                // Dùng labelSmall
                color: indicatorColors.onContainer, // Màu chữ onContainer
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDark,
  ) {
    // Lấy màu semantic từ AppColors, tôn trọng dark mode
    final rescheduleColors = _getWarningColors(
      colorScheme,
      isDark,
    ); // Ví dụ dùng Warning cho Reschedule
    final completeColors = _getSuccessColors(
      colorScheme,
      isDark,
    ); // Dùng Success cho Complete
    // final skipColors = _getNeutralColors(colorScheme); // Ví dụ dùng màu trung tính cho Skip

    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.paddingL),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: AppDimens.spaceM, // Tăng spacing
        runSpacing: AppDimens.spaceS,
        children: [
          // Reschedule Button (Ví dụ dùng màu Warning)
          if (onReschedule != null)
            _buildActionButton(
              textTheme,
              rescheduleColors,
              'Reschedule',
              Icons.calendar_month_outlined,
              onReschedule!,
            ),
          // Complete Button (Dùng màu Success)
          if (onMarkCompleted != null)
            _buildActionButton(
              textTheme,
              completeColors,
              'Complete',
              Icons.check_circle_outlined,
              onMarkCompleted!,
              showScoreIndicator: true, // Hiển thị icon %
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    TextTheme textTheme,
    M3ColorPair colors, // Nhận cặp màu container/onContainer
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool showScoreIndicator = false,
  }) {
    // Style cho button, sử dụng màu từ M3ColorPair
    // Ở đây dùng OutlinedButton, style màu theo foregroundColor và side.color
    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor:
          colors.container, // Màu chữ/icon là màu container (thường đậm hơn)
      side: BorderSide(color: colors.container), // Viền cùng màu với chữ/icon
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
      textStyle: textTheme.labelLarge, // Dùng labelLarge
    ).copyWith(
      minimumSize: WidgetStateProperty.all(
        Size.zero,
      ), // Bỏ minimum size mặc định
    );

    // Score Indicator styling
    final scoreIndicatorBg = colors.container.withOpacity(
      0.15,
    ); // Nền hơi mờ của màu container
    final scoreIndicatorFg = colors.onContainer; // Màu icon là onContainer

    return SizedBox(
      height: AppDimens.buttonHeightM,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: AppDimens.iconS),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (showScoreIndicator) ...[
              const SizedBox(width: AppDimens.spaceS), // Tăng khoảng cách
              // Score Indicator dùng màu container/onContainer tương ứng
              Container(
                padding: const EdgeInsets.all(AppDimens.paddingXXS + 1),
                decoration: BoxDecoration(
                  // Dùng màu container với độ mờ nhẹ làm nền
                  color: scoreIndicatorBg,
                  shape: BoxShape.circle, // Làm thành hình tròn
                ),
                child: Icon(
                  Icons.percent,
                  size: AppDimens.iconXXS,
                  // Dùng màu onContainer cho icon %
                  color: scoreIndicatorFg,
                ),
              ),
            ],
          ],
        ),
        style: buttonStyle,
      ),
    );
  }

  // --- Helper Functions ---

  String _formatRepetitionOrder(RepetitionOrder order) {
    // Giữ nguyên logic
    switch (order) {
      case RepetitionOrder.firstRepetition:
        return 'Repetition 1';
      case RepetitionOrder.secondRepetition:
        return 'Repetition 2';
      case RepetitionOrder.thirdRepetition:
        return 'Repetition 3';
      case RepetitionOrder.fourthRepetition:
        return 'Repetition 4';
      case RepetitionOrder.fifthRepetition:
        return 'Repetition 5';
    }
  }

  String _formatStatus(RepetitionStatus status) {
    // Giữ nguyên logic
    switch (status) {
      case RepetitionStatus.notStarted:
        return 'Pending';
      case RepetitionStatus.completed:
        return 'Completed';
      case RepetitionStatus.skipped:
        return 'Skipped';
    }
  }

  // Sửa lại để trả về cặp màu M3, dùng AppColors và theme
  M3ColorPair _getStatusColors(
    RepetitionStatus status,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    switch (status) {
      case RepetitionStatus.notStarted:
        // Dùng màu Primary Container
        return (
          container: colorScheme.primaryContainer,
          onContainer: colorScheme.onPrimaryContainer,
        );
      case RepetitionStatus.completed:
        // Dùng màu Success từ AppColors
        return (
          container:
              isDark
                  ? AppColors.successContainerDark
                  : AppColors.successContainerLight,
          onContainer:
              isDark
                  ? AppColors.onSuccessContainerDark
                  : AppColors.onSuccessContainerLight,
        );
      case RepetitionStatus.skipped:
        // Dùng màu Warning từ AppColors
        return (
          container:
              isDark
                  ? AppColors.warningContainerDark
                  : AppColors.warningContainerLight,
          onContainer:
              isDark
                  ? AppColors.onWarningContainerDark
                  : AppColors.onWarningContainerLight,
        );
    }
  }

  String _getTimeIndicator(DateTime? date) {
    // Giữ nguyên logic, có thể tối ưu DateUtils.dateOnly
    if (date == null) return '';
    final now = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    final difference = target.difference(now).inDays;

    if (difference < 0) return 'Overdue ${-difference}d';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return 'In $difference days'; // Sửa lại text "days left"
  }

  // Sửa lại để trả về cặp màu M3 hoặc null, dùng AppColors và theme
  M3ColorPair? _getTimeIndicatorColors(
    DateTime? date,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    if (date == null) return null; // Trả về null nếu không có ngày

    final now = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    final difference = target.difference(now).inDays;

    if (difference < 0) {
      // Overdue = Error
      return (
        container: colorScheme.errorContainer,
        onContainer: colorScheme.onErrorContainer,
      );
    }
    if (difference == 0) {
      // Today = Success
      return (
        container:
            isDark
                ? AppColors.successContainerDark
                : AppColors.successContainerLight,
        onContainer:
            isDark
                ? AppColors.onSuccessContainerDark
                : AppColors.onSuccessContainerLight,
      );
    }
    if (difference <= 3) {
      // Soon = Warning
      return (
        container:
            isDark
                ? AppColors.warningContainerDark
                : AppColors.warningContainerLight,
        onContainer:
            isDark
                ? AppColors.onWarningContainerDark
                : AppColors.onWarningContainerLight,
      );
    }
    // Further out = Secondary Container
    return (
      container: colorScheme.secondaryContainer,
      onContainer: colorScheme.onSecondaryContainer,
    );
  }

  // --- Các hàm helper lấy màu semantic khác (ví dụ) ---
  M3ColorPair _getSuccessColors(ColorScheme colorScheme, bool isDark) {
    return (
      container:
          isDark
              ? AppColors.successContainerDark
              : AppColors.successContainerLight,
      onContainer:
          isDark
              ? AppColors.onSuccessContainerDark
              : AppColors.onSuccessContainerLight,
    );
  }

  M3ColorPair _getWarningColors(ColorScheme colorScheme, bool isDark) {
    return (
      container:
          isDark
              ? AppColors.warningContainerDark
              : AppColors.warningContainerLight,
      onContainer:
          isDark
              ? AppColors.onWarningContainerDark
              : AppColors.onWarningContainerLight,
    );
  }
}

// --- Giả định ---
/*
enum RepetitionOrder { firstRepetition, secondRepetition, thirdRepetition, fourthRepetition, fifthRepetition }
enum RepetitionStatus { notStarted, completed, skipped }
class Repetition {
  final String id;
  final RepetitionOrder repetitionOrder;
  final RepetitionStatus status;
  final DateTime? reviewDate;
  Repetition({required this.id, required this.repetitionOrder, required this.status, this.reviewDate});
}

// Extension giả định
extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) { return withOpacity(alpha.clamp(0.0, 1.0)); }
    return this;
  }
}
*/
