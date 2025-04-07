import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import lại AppColors để dùng màu semantic success/warning (vì chúng có light/dark)
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/screens/modules/module_detail_screen.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

class ModuleDetailsBottomSheet extends StatelessWidget {
  final LearningModule module;
  final String? heroTagPrefix;

  const ModuleDetailsBottomSheet({
    super.key,
    required this.module,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme; // Lấy colorScheme cho tiện
    final textTheme = theme.textTheme; // Lấy textTheme cho tiện
    final mediaQuery = MediaQuery.of(context);
    final isDark =
        theme.brightness == Brightness.dark; // Kiểm tra theme tối/sáng

    return Container(
      key: const Key('module_details_bottom_sheet'),
      // Sử dụng BottomSheetTheme nếu có, hoặc style M3 cơ bản
      // Thay vì Container, có thể dùng trực tiếp nội dung bên trong showModalBottomSheet
      decoration: BoxDecoration(
        // Màu nền của Bottom Sheet (có thể dùng surfaceContainerLow/etc tùy elevation)
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusL), // Bo góc trên
        ),
        // M3 thường dùng surfaceTintColor để thể hiện elevation thay vì shadow đậm
        // Hoặc nếu dùng shadow, lấy từ theme
        // boxShadow: [
        //   BoxShadow(
        //     color: theme.shadowColor.withValues(alpha:0.1), // Lấy màu shadow từ theme
        //     blurRadius: AppDimens.shadowRadiusL / 2,
        //     spreadRadius: 0,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
      ),
      // Nên đặt constraints này bên ngoài khi gọi showModalBottomSheet
      // constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.8),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Co lại theo nội dung
        children: [
          _buildDragHandle(theme, colorScheme), // Truyền colorScheme
          Flexible(
            // Cho phép nội dung cuộn nếu dài
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppDimens.paddingL,
                right: AppDimens.paddingL,
                bottom:
                    AppDimens.paddingXL +
                    mediaQuery.padding.bottom, // Thêm padding dưới cùng an toàn
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModuleTitle(
                    theme,
                    colorScheme,
                    textTheme,
                  ), // Truyền theme components
                  _buildBookInfo(
                    theme,
                    colorScheme,
                    textTheme,
                  ), // Truyền theme components
                  const Divider(height: AppDimens.paddingXXL),
                  _buildModuleDetailsSection(
                    context,
                    theme,
                    colorScheme,
                    textTheme,
                    isDark,
                  ), // Truyền theme components và isDark
                  const Divider(height: AppDimens.paddingXXL),
                  _buildDatesSection(
                    theme,
                    colorScheme,
                    textTheme,
                  ), // Truyền theme components
                  if (module.studyHistory?.isNotEmpty ?? false) ...[
                    const SizedBox(height: AppDimens.spaceXL),
                    _buildStudyHistorySection(
                      theme,
                      colorScheme,
                      textTheme,
                    ), // Truyền theme components
                  ],
                  const SizedBox(height: AppDimens.spaceXL),
                  _buildActionButtons(context, theme), // Truyền theme
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingM,
        bottom: AppDimens.paddingS,
      ),
      child: Container(
        key: const Key('drag_handle'),
        width: AppDimens.moduleIndicatorSize,
        height: AppDimens.dividerThickness * 2,
        decoration: BoxDecoration(
          // Dùng màu onSurfaceVariant trực tiếp, không cần alpha
          color: colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
      ),
    );
  }

  Widget _buildModuleTitle(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    Widget titleWidget = Text(
      module.subject.isEmpty ? 'Unnamed Module' : module.subject,
      style: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface, // Đảm bảo màu chữ trên nền surface
      ),
      key: const Key('module_title'),
    );

    // Chỉ bọc Hero nếu có tag prefix
    if (heroTagPrefix != null) {
      titleWidget = Hero(
        tag: '${heroTagPrefix}_${module.id}',
        // Material cần thiết cho Hero transition không bị lỗi text
        child: Material(color: Colors.transparent, child: titleWidget),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.paddingXS,
      ), // Thêm padding dưới title
      child: titleWidget,
    );
  }

  Widget _buildBookInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingS,
        bottom: AppDimens.paddingM,
      ), // Thêm padding dưới
      child: Row(
        children: [
          Icon(
            Icons.book_outlined, // Icon outline có thể đẹp hơn
            color: colorScheme.primary,
            size: AppDimens.iconS,
            key: const Key('book_icon'),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Text(
              'From: ${module.book.isEmpty ? 'No Book' : module.book}',
              style: textTheme.titleMedium?.copyWith(
                // Dùng titleMedium hợp lý
                color: colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              key: const Key('book_info'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    String title, {
    Key? key,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingM,
      ), // Thêm padding cho section title
      child: Row(
        children: [
          Icon(
            Icons.info_outline, // Hoặc icon khác phù hợp
            size: AppDimens.iconM,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppDimens.spaceS),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              // Dùng titleMedium hợp lý
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            key: key,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleDetailsSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          colorScheme,
          textTheme,
          'Module Details',
          key: const Key('details_section_title'),
        ),
        Wrap(
          spacing: AppDimens.spaceL, // Khoảng cách ngang
          runSpacing: AppDimens.spaceL, // Khoảng cách dọc
          children: [
            _buildDetailItem(
              context,
              theme,
              colorScheme,
              textTheme,
              isDark,
              'Word Count',
              module.wordCount.toString(),
              Icons.text_fields,
              key: const Key('word_count_item'),
            ),
            _buildDetailItem(
              context,
              theme,
              colorScheme,
              textTheme,
              isDark,
              'Progress',
              '${module.percentage}%',
              Icons.show_chart_outlined, // Icon khác
              progressValue: module.percentage / 100.0, // Đảm bảo là double
              key: const Key('progress_item'),
            ),
            if (module.cyclesStudied != null) // Chỉ hiển thị nếu có cycle
              _buildDetailItem(
                context,
                theme,
                colorScheme,
                textTheme,
                isDark,
                'Cycle',
                CycleFormatter.format(module.cyclesStudied!),
                Icons.autorenew, // Icon khác
                // Lấy màu từ CycleFormatter nhưng đảm bảo có dark mode
                color: CycleFormatter.getColor(
                  module.cyclesStudied!,
                ), // Giả sử CycleFormatter hỗ trợ isDark
                key: const Key('cycle_item'),
              ),
            if (module.taskCount != null &&
                module.taskCount! > 0) // Chỉ hiển thị nếu có task
              _buildDetailItem(
                context,
                theme,
                colorScheme,
                textTheme,
                isDark,
                'Tasks',
                module.taskCount!.toString(),
                Icons.checklist_outlined, // Icon khác
                key: const Key('tasks_item'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDark,
    String label,
    String value,
    IconData icon, {
    double? progressValue,
    Color? color,
    Key? key,
  }) {
    final effectiveColor = color ?? colorScheme.primary; // Màu nhấn chính
    // Màu nền và viền theo M3
    final bgColor = colorScheme.surfaceContainerLowest;
    final borderColor =
        colorScheme.outlineVariant; // Dùng outlineVariant cho viền nhẹ

    // Tính toán width linh hoạt hơn
    final screenWidth = MediaQuery.of(context).size.width;
    // Trừ padding của SingleChildScrollView và spacing của Wrap
    final availableWidth =
        screenWidth - (AppDimens.paddingL * 2) - AppDimens.spaceL;
    final itemWidth = availableWidth / 2; // Hiển thị 2 item mỗi hàng

    return Container(
      key: key,
      width: itemWidth, // Set width để Wrap hoạt động đúng
      constraints: const BoxConstraints(
        minHeight: AppDimens.thumbnailSizeS,
      ), // Giảm minHeight
      padding: const EdgeInsets.all(
        AppDimens.paddingM,
      ), // Giảm padding một chút
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusM), // Bo góc
        border: Border.all(color: borderColor), // Dùng màu outlineVariant
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Co lại theo nội dung
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: AppDimens.iconS,
                color: effectiveColor,
              ), // Màu nhấn cho icon
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant, // Màu phụ cho label
                  ),
                  overflow: TextOverflow.ellipsis, // Tránh tràn chữ
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              // Dùng titleMedium cho value
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // Màu chính cho value
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: AppDimens.spaceS,
          ), // Khoảng cách trước progress bar
          // Progress Indicator (nếu có)
          if (progressValue != null)
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: colorScheme.surfaceContainerHighest, // Nền track
              valueColor: AlwaysStoppedAnimation<Color>(
                // Sửa lỗi màu cứng, dùng màu semantic từ AppColors (có dark/light)
                progressValue >= 0.9
                    ? (isDark ? AppColors.successDark : AppColors.successLight)
                    : progressValue >= 0.7
                    ? (isDark ? AppColors.warningDark : AppColors.warningLight)
                    : colorScheme.error, // Dùng màu error từ theme
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusXXS),
              minHeight: AppDimens.lineProgressHeight,
            )
          else
            // Placeholder để giữ chiều cao nếu không có progress bar
            const SizedBox(height: AppDimens.lineProgressHeight),
        ],
      ),
    );
  }

  Widget _buildDatesSection(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          colorScheme,
          textTheme,
          'Important Dates',
          key: const Key('dates_section_title'),
        ),
        const SizedBox(height: AppDimens.spaceS),
        if (module.firstLearningDate != null)
          _buildDateItem(
            theme,
            colorScheme,
            textTheme,
            'First Learning',
            module.firstLearningDate!,
            Icons.play_circle_outline, // Icon khác
            key: const Key('first_learning_date'),
          ),
        if (module.nextStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            theme,
            colorScheme,
            textTheme,
            'Next Study',
            module.nextStudyDate!,
            Icons.event_available_outlined, // Icon khác
            // Xác định isDue (có thể truyền từ ngoài vào hoặc tính tại đây)
            isDue: module.nextStudyDate!.isBefore(
              DateTime.now().add(const Duration(days: 1)),
            ), // Ví dụ: Due nếu trong vòng 1 ngày
            key: const Key('next_study_date'),
          ),
        ],
        if (module.lastStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            theme,
            colorScheme,
            textTheme,
            'Last Study',
            module.lastStudyDate!,
            Icons.history_outlined, // Icon khác
            key: const Key('last_study_date'),
          ),
        ],
      ],
    );
  }

  Widget _buildDateItem(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    String label,
    DateTime date,
    IconData icon, {
    bool isDue = false,
    Key? key,
  }) {
    // Sửa lỗi màu cứng: Dùng error từ theme
    final Color effectiveColor =
        isDue ? colorScheme.error : colorScheme.primary;
    final Color labelColor = colorScheme.onSurfaceVariant; // Màu cho label
    final Color dateColor =
        isDue ? colorScheme.error : colorScheme.onSurface; // Màu cho ngày tháng

    return Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start, // Căn trên nếu text dài
      children: [
        Icon(icon, color: effectiveColor, size: AppDimens.iconM),
        const SizedBox(width: AppDimens.spaceM), // Tăng khoảng cách
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(color: labelColor),
              ),
              Text(
                DateFormat(
                  'EEEE, MMMM d, yyyy',
                ).format(date), // Định dạng đầy đủ hơn
                style: textTheme.titleMedium?.copyWith(
                  // Dùng titleMedium
                  color: dateColor,
                  fontWeight: isDue ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
        if (isDue)
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.spaceS),
            // Sửa lỗi Chip hardcode: Dùng Chip chuẩn và màu theme
            child: Chip(
              label: const Text('Due Soon'),
              labelStyle: textTheme.labelSmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              backgroundColor: colorScheme.errorContainer,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              side: BorderSide.none, // Bỏ border mặc định của Chip
            ),
          ),
      ],
    );
  }

  Widget _buildStudyHistorySection(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final studyHistory = List<DateTime>.from(module.studyHistory!)
      ..sort((a, b) => b.compareTo(a)); // Sắp xếp mới nhất lên đầu
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          colorScheme,
          textTheme,
          'Study History',
          key: const Key('history_section_title'),
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildHistoryItems(theme, colorScheme, textTheme, studyHistory),
        if (studyHistory.length > 7) ...[
          const SizedBox(height: AppDimens.spaceS), // Tăng khoảng cách
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.paddingS,
            ), // Thụt lề text
            child: Text(
              '+ ${studyHistory.length - 7} more sessions',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant, // Dùng màu phụ
                fontStyle: FontStyle.italic,
              ),
              key: const Key('more_sessions_text'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryItems(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<DateTime> studyHistory,
  ) {
    final today = DateUtils.dateOnly(
      DateTime.now(),
    ); // So sánh chỉ ngày, bỏ qua giờ

    return Wrap(
      key: const Key('history_items'),
      spacing: AppDimens.spaceS, // Tăng khoảng cách ngang
      runSpacing: AppDimens.spaceS, // Tăng khoảng cách dọc
      children:
          studyHistory.take(7).map((date) {
            // Chỉ hiển thị tối đa 7 ngày
            final itemDate = DateUtils.dateOnly(date);
            final isToday = itemDate.isAtSameMomentAs(today);

            // Sửa lỗi màu cứng và alpha: Dùng màu M3
            final Color bgColor;
            final Color fgColor; // Màu chữ
            final Border? border;

            if (isToday) {
              bgColor = colorScheme.primaryContainer;
              fgColor = colorScheme.onPrimaryContainer;
              border = Border.all(
                color: colorScheme.primary,
              ); // Border primary cho ngày hôm nay
            } else {
              bgColor = colorScheme.surfaceContainerHighest;
              fgColor = colorScheme.onSurfaceVariant; // Màu phụ cho ngày cũ
              border = Border.all(
                color: colorScheme.outline,
              ); // Border outline cho ngày cũ
            }

            // Sửa lỗi TextStyle cứng: Dùng textTheme
            final itemTextStyle = textTheme.labelMedium; // Dùng labelMedium

            return Tooltip(
              message: DateFormat(
                'MMMM d, yyyy',
              ).format(date), // Format đầy đủ cho tooltip
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingM, // Tăng padding
                  vertical: AppDimens.paddingXXS + 1,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(
                    AppDimens.radiusM,
                  ), // Tăng radius
                  border: border,
                ),
                child: Text(
                  DateFormat('MMM d').format(date), // Format ngắn gọn
                  style: itemTextStyle?.copyWith(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: fgColor,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    // Các button sẽ tự lấy style từ OutlinedButtonTheme và ElevatedButtonTheme
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingL,
      ), // Thêm padding trên cùng
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Đẩy button sang phải
        children: [
          OutlinedButton.icon(
            key: const Key('close_button'),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            onPressed: () => Navigator.pop(context),
            // Không cần style override ở đây nếu OutlinedButtonTheme đã đủ
            // style: OutlinedButton.styleFrom(padding: ...), // Chỉ override nếu cần padding khác theme
          ),
          const SizedBox(width: AppDimens.spaceM), // Khoảng cách giữa 2 button
          ElevatedButton.icon(
            key: const Key('study_button'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Studying'),
            onPressed: () {
              Navigator.pop(context); // Đóng bottom sheet trước khi điều hướng
              // TODO: Xác nhận cách điều hướng này có đúng không
              // Có thể cần dùng Navigator.pushReplacement hoặc các phương thức khác
              // tùy thuộc vào luồng ứng dụng của bạn.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleDetailScreen(moduleId: module.id),
                ),
              );
            },
            // Bỏ style override, để button tự lấy style từ ElevatedButtonTheme
            // style: ElevatedButton.styleFrom(
            //   padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
            //   backgroundColor: theme.colorScheme.primary, // Lấy từ theme rồi
            //   foregroundColor: theme.colorScheme.onPrimary, // Lấy từ theme rồi
            // ),
          ),
        ],
      ),
    );
  }
}

// Extension và Formatter giả định
/*
extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) { return withOpacity(alpha.clamp(0.0, 1.0)); }
    return this;
  }
}

class CycleFormatter {
  static String format(int cycle) => 'Cycle $cycle';
  static Color? getColor(int cycle, {bool isDark = false}) {
     // Implement logic to return color based on cycle, considering dark mode
     // Example: return Colors.blue;
     return null; // Placeholder
  }
}

class LearningModule {
 //... Các thuộc tính như id, subject, book, wordCount, percentage, cyclesStudied, taskCount, firstLearningDate, nextStudyDate, lastStudyDate, studyHistory
}

*/
