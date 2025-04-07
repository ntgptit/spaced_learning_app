import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
// Import AppColors nếu cần thiết cho các màu không có trong ColorScheme chuẩn (ví dụ: Success)
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Giả định AppButton đã theme-aware
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart'; // Giả định AppCard đã theme-aware

/// A card widget displaying book summary information using AppTheme
class BookCard extends StatelessWidget {
  final BookSummary book;
  final VoidCallback? onTap;
  final VoidCallback? onStartPressed;
  final EdgeInsetsGeometry margin;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onStartPressed,
    this.margin = const EdgeInsets.symmetric(
      vertical: AppDimens.paddingS,
      horizontal: AppDimens.paddingL,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme; // Lấy textTheme để tiện dùng

    return AppCard(
      onTap: onTap,
      margin: margin,
      // Title và Subtitle đã dùng theme đúng cách
      title: Text(
        book.name,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface, // Đảm bảo màu chữ trên nền Card
        ),
        maxLines: 2, // Thêm giới hạn dòng nếu cần
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          book.category != null
              ? Text(
                book.category!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant, // Màu phụ, đúng chuẩn M3
                ),
              )
              : null,
      // Trailing và Content sử dụng các hàm build riêng, truyền theme vào
      trailing: _buildModuleCountBadge(theme, colorScheme),
      content: _buildContent(theme, colorScheme),
      actions: _buildActions(theme), // Truyền theme nếu AppButton cần
    );
  }

  // UI Components

  // Module Count Badge đã dùng container/onContainer đúng chuẩn M3
  Widget _buildModuleCountBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: AppDimens.moduleIndicatorSize,
      height: AppDimens.moduleIndicatorSize,
      decoration: BoxDecoration(
        // Dùng secondaryContainer/onSecondaryContainer là lựa chọn tốt cho badge này
        color: colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${book.moduleCount}',
          style: theme.textTheme.labelSmall!.copyWith(
            // Dùng labelSmall có thể phù hợp hơn titleSmall cho badge nhỏ
            color: colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      // Thêm Padding nếu cần khoảng cách giữa content và actions/title
      padding: const EdgeInsets.only(top: AppDimens.spaceS),
      child: Wrap(
        spacing: AppDimens.spaceS,
        runSpacing: AppDimens.spaceXS,
        children: [
          // Status và Difficulty badges giờ sẽ dùng _Badge đã được refactor
          _buildStatusBadge(theme, colorScheme),
          // Difficulty badge chỉ hiển thị nếu có giá trị
          ...?_buildDifficultyBadge(
            theme,
            colorScheme,
          ), // Sử dụng spread operator `...?` để xử lý null
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, ColorScheme colorScheme) {
    // Sử dụng switch expression để trả về tuple chứa màu nền, màu nội dung, icon, và text
    final (
      containerColor,
      onContainerColor,
      iconData,
      statusText,
    ) = switch (book.status) {
      BookStatus.published => (
        colorScheme.primaryContainer, // Nền
        colorScheme.onPrimaryContainer, // Nội dung
        Icons.check_circle,
        'Published',
      ),
      BookStatus.draft => (
        colorScheme.secondaryContainer, // Nền
        colorScheme.onSecondaryContainer, // Nội dung
        Icons.edit,
        'Draft',
      ),
      BookStatus.archived => (
        // Dùng màu trung tính hơn cho Archived
        colorScheme.surfaceContainerHighest, // Nền xám nhạt/đậm tùy theme
        colorScheme.onSurfaceVariant, // Nội dung màu xám vừa
        Icons.archive,
        'Archived',
      ),
    };

    // Gọi _Badge với các màu đã được xác định
    return _Badge(
      backgroundColor: containerColor,
      foregroundColor: onContainerColor, // Màu cho cả text và icon
      icon: iconData,
      text: statusText,
      textStyle: theme.textTheme.labelSmall!, // Dùng style gốc từ theme
    );
  }

  // Trả về List<Widget>? để dùng spread operator
  List<Widget>? _buildDifficultyBadge(
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (book.difficultyLevel == null) return null;

    // Xác định cặp màu container/onContainer dựa trên difficulty
    final (containerColor, onContainerColor, difficultyText) = switch (book
        .difficultyLevel!) {
      DifficultyLevel.beginner => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        'Beginner',
      ),
      DifficultyLevel.intermediate => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        'Intermediate',
      ),
      DifficultyLevel.advanced => (
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
        'Advanced',
      ),
      DifficultyLevel.expert => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        'Expert',
      ),
    };

    // Trả về một List chứa _Badge (để dùng spread operator)
    return [
      _Badge(
        backgroundColor: containerColor,
        foregroundColor: onContainerColor, // Màu cho text
        text: difficultyText,
        textStyle: theme.textTheme.labelSmall!, // Dùng style gốc từ theme
      ),
    ];
  }

  // Giả định AppButton đã được theme-aware và tự lấy style từ theme
  List<Widget> _buildActions(ThemeData theme) {
    // Actions có thể được đặt trong một Row ở cuối AppCard nếu AppCard hỗ trợ
    // Hoặc bạn có thể trả về List<Widget> để AppCard xử lý layout
    return [
      if (onStartPressed != null && book.status == BookStatus.published)
        AppButton(
          text: 'Start Learning',
          onPressed: onStartPressed,
          type:
              AppButtonType
                  .primary, // AppButton nên dùng theme.elevatedButtonTheme
          size: AppButtonSize.small,
          prefixIcon: Icons.play_arrow,
        ),
    ];
  }
}

/// Private widget for reusable badge styling (Refactored for M3)
class _Badge extends StatelessWidget {
  final Color backgroundColor; // Màu nền (Container color)
  final Color
  foregroundColor; // Màu nội dung (onContainer color) - cho cả text và icon
  final IconData? icon;
  final String text;
  final TextStyle textStyle; // Style gốc từ theme (ví dụ: labelSmall)

  const _Badge({
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS, // Padding ngang
        vertical: AppDimens.paddingXXS + 1, // Padding dọc (điều chỉnh nhỏ)
      ),
      decoration: BoxDecoration(
        color: backgroundColor, // Sử dụng màu nền được truyền vào
        borderRadius: BorderRadius.circular(AppDimens.radiusM), // Bo góc
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Co lại theo nội dung
        crossAxisAlignment:
            CrossAxisAlignment.center, // Căn giữa theo chiều dọc
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size:
                  textStyle.fontSize ??
                  AppDimens.iconXS, // Kích thước icon theo font size
              color: foregroundColor, // Sử dụng màu nội dung
            ),
            const SizedBox(width: AppDimens.spaceXXS), // Khoảng cách nhỏ
          ],
          Text(
            text,
            style: textStyle.copyWith(
              color: foregroundColor, // Sử dụng màu nội dung
              fontWeight:
                  FontWeight
                      .w600, // Có thể giữ lại fontWeight nếu muốn nhấn mạnh
            ),
            overflow: TextOverflow.ellipsis, // Tránh tràn chữ
          ),
        ],
      ),
    );
  }
}
