// lib/presentation/widgets/books/common_book.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

/// Widget hiển thị bìa sách với màu và họa tiết tùy chỉnh
class BookCoverWidget extends StatelessWidget {
  final BookDetail book;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const BookCoverWidget({
    super.key,
    required this.book,
    this.width = AppDimens.thumbnailSizeM, // 120.0
    this.height = AppDimens.thumbnailSizeL, // 160.0
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppDimens.radiusM);

    // Tạo màu nhất quán dựa trên tên sách
    final bookNameHash = book.name.hashCode;
    final hue = (bookNameHash % 360).abs().toDouble();
    const saturation = 0.6;
    const lightness = 0.75;
    final backgroundColor =
        HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor, backgroundColor.withValues(alpha: 0.8)],
        ),
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Họa tiết phủ
          Positioned.fill(
            child: ClipRRect(
              borderRadius: effectiveBorderRadius,
              child: CustomPaint(
                painter: BookPatternPainter(
                  patternColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),

          // Tiêu đề sách
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingS),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book,
                    size: AppDimens.iconL,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  Text(
                    book.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Chỉ báo thể loại
          if (book.category != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: effectiveBorderRadius.bottomLeft,
                    bottomRight: effectiveBorderRadius.bottomRight,
                  ),
                ),
                child: Text(
                  book.category!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom Painter tạo họa tiết cho bìa sách
class BookPatternPainter extends CustomPainter {
  final Color patternColor;
  final int lineCount;

  BookPatternPainter({required this.patternColor, this.lineCount = 5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = patternColor
          ..strokeWidth = 0.9
          ..style = PaintingStyle.stroke;

    // Vẽ đường kẻ ngang
    final spacingY = size.height / (lineCount + 1);
    for (int i = 1; i <= lineCount; i++) {
      final y = spacingY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vẽ mẫu chéo
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);

    // Thêm viền
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// Widget hiển thị một chip lọc với hiệu ứng xóa
class FilterChipWidget extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onDeleted;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.color,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color),
      deleteIconColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}

/// Widget hiển thị một mục thông tin chi tiết
class MetadataItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const MetadataItemWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.iconM,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          // Wrap Column with Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis, // Prevent long value overflow
                maxLines: 1, // Adjust if needed (e.g., for long IDs)
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget thống kê cho màn hình chi tiết sách
class StatItemWidget extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatItemWidget({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure column doesn't take extra height
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.paddingM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: AppDimens.iconL),
        ),
        const SizedBox(height: AppDimens.spaceS),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS), // Consistent small space
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center, // Center align label
          maxLines: 2, // Allow label to wrap to two lines
          overflow: TextOverflow.ellipsis, // Add ellipsis if it exceeds 2 lines
        ),
      ],
    );
  }
}

/// Widget hiển thị một chip thông tin
class InfoChipWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const InfoChipWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXXS / 2 + 1,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimens.iconXS, color: textColor),
            const SizedBox(width: AppDimens.spaceXXS),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card Widget hiển thị module
class ModuleCardWidget extends StatelessWidget {
  final dynamic module; // Consider using a specific type like ModuleSummary
  final int index;
  final VoidCallback onTap;

  const ModuleCardWidget({
    super.key,
    required this.module,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Lấy thông tin từ module object (cần điều chỉnh tên thuộc tính nếu khác)
    final String title = module.title ?? 'Unnamed Module';
    final int? wordCount = module.wordCount; // Giả sử có thuộc tính wordCount

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      margin: const EdgeInsets.only(bottom: AppDimens.paddingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Row(
            children: [
              // Chỉ báo số module
              Container(
                width: AppDimens.moduleIndicatorSize,
                height: AppDimens.moduleIndicatorSize,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}', // Hiển thị số thứ tự (bắt đầu từ 1)
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceL),
              // Thông tin module
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (wordCount != null && wordCount > 0) ...[
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        '$wordCount words',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Chỉ báo mũi tên
              Icon(
                Icons.arrow_forward_ios,
                size: AppDimens.iconS,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget hiển thị sách trong grid
class BookGridItemWidget extends StatelessWidget {
  final BookSummary book;
  final VoidCallback onTap;

  const BookGridItemWidget({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = getStatusColor(book.status, colorScheme);

    return Hero(
      tag: 'book-${book.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Color band at top based on difficulty
                Container(
                  height: 4,
                  color: getDifficultyColor(book.difficultyLevel, colorScheme),
                ),

                // Book "cover" area
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.menu_book,
                        size: AppDimens.iconXXL,
                        color: colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),

                // Book info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingS),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            book.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (book.category != null)
                              Expanded(
                                child: Text(
                                  book.category!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            else
                              const Spacer(),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingXS,
                                vertical: AppDimens.paddingXXS,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusXS,
                                ),
                              ),
                              child: Text(
                                formatStatus(book.status),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(BookStatus status, ColorScheme colorScheme) {
    switch (status) {
      case BookStatus.published:
        return Colors.green; // Consider theme.colorScheme.tertiary
      case BookStatus.draft:
        return colorScheme.secondary;
      case BookStatus.archived:
        return colorScheme.onSurfaceVariant;
    }
  }

  Color getDifficultyColor(DifficultyLevel? level, ColorScheme colorScheme) {
    if (level == null) return colorScheme.surfaceContainerHighest;
    switch (level) {
      case DifficultyLevel.beginner:
        return Colors.green; // Consider theme.colorScheme.tertiary
      case DifficultyLevel.intermediate:
        return colorScheme.primary;
      case DifficultyLevel.advanced:
        return colorScheme.secondary;
      case DifficultyLevel.expert:
        return colorScheme.error;
    }
  }

  String formatStatus(BookStatus status) {
    switch (status) {
      case BookStatus.published:
        return 'Published';
      case BookStatus.draft:
        return 'Draft';
      case BookStatus.archived:
        return 'Archived';
    }
  }
}
