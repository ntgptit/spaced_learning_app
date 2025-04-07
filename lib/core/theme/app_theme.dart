import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart'; // Đảm bảo import AppColors đã cập nhật
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/theme/app_typography.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    // Sử dụng các màu sáng từ AppColors hiện đại (Blue/Teal/Coral theme)
    // ColorScheme này đã được định nghĩa chính xác với các màu mới trong AppColors
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      onTertiaryContainer: AppColors.lightOnTertiaryContainer,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.lightErrorContainer,
      onErrorContainer: AppColors.lightOnErrorContainer,
      surface: AppColors.lightSurface, // Mapped to AppColors.lightSurface
      onSurface:
          AppColors
              .lightOnSurface, // M3 uses this for subtle backgrounds/borders
      onSurfaceVariant:
          AppColors
              .lightOnSurfaceVariant, // M3 uses this for medium emphasis text/icons
      outline: AppColors.lightOutline, // M3 uses for borders
      outlineVariant:
          AppColors
              .lightOutlineVariant, // M3 uses for dividers, decorative outlines
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface:
          AppColors.darkSurface, // Typically opposite theme's surface
      onInverseSurface:
          AppColors.darkOnSurface, // Typically opposite theme's onSurface
      inversePrimary: AppColors.darkPrimary, // Primary color in opposite theme
      surfaceTint:
          AppColors
              .lightPrimary, // Often primary color, used for elevation overlay
      // M3 Surface Container Levels (Map từ AppColors mới)
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceDim: AppColors.surfaceDim, // Thêm từ AppColors mới
      surfaceBright: AppColors.surfaceBright, // Thêm từ AppColors mới
    );

    return _createTheme(colorScheme);
  }

  static ThemeData getDarkTheme() {
    // Sử dụng các màu tối từ AppColors hiện đại (Blue/Teal/Coral theme)
    // ColorScheme này đã được định nghĩa chính xác với các màu mới trong AppColors
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      onTertiaryContainer: AppColors.darkOnTertiaryContainer,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkOnErrorContainer,
      surface: AppColors.darkSurface, // Mapped to AppColors.darkSurface
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant, // Thêm từ AppColors mới
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface:
          AppColors.lightSurface, // Typically opposite theme's surface
      onInverseSurface:
          AppColors.lightOnSurface, // Typically opposite theme's onSurface
      inversePrimary: AppColors.lightPrimary, // Primary color in opposite theme
      surfaceTint:
          AppColors
              .darkPrimary, // Often primary color, used for elevation overlay
      // M3 Surface Container Levels (Map từ AppColors mới)
      surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
      surfaceContainerLow: AppColors.darkSurfaceContainerLow,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      surfaceDim: AppColors.darkSurfaceDim, // Thêm từ AppColors mới
      surfaceBright: AppColors.darkSurfaceBright, // Thêm từ AppColors mới
    );

    return _createTheme(colorScheme);
  }

  // Phương thức _createTheme giờ đây nhất quán hơn trong việc sử dụng ColorScheme
  static ThemeData _createTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = AppTypography.getTextTheme(colorScheme.brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor:
          colorScheme
              .surface, // Chuẩn M3: Nên dùng surface hoặc surfaceContainerLowest
      appBarTheme: AppBarTheme(
        elevation:
            AppDimens.elevationS, // M3 thường là 0 nếu không scroll, hoặc 3
        centerTitle: false,
        // Chuẩn M3: AppBar thường dùng surface hoặc surfaceContainer tùy trạng thái scroll.
        // Sử dụng colorScheme thay vì AppColors trực tiếp.
        backgroundColor:
            isDark
                ? colorScheme
                    .surfaceContainerHighest // surfaceContainerHighest là một lựa chọn tốt cho AppBar tối
                : colorScheme
                    .surfaceContainerLow, // surfaceContainerLow hoặc surface cho AppBar sáng
        foregroundColor: colorScheme.onSurface, // Màu cho title và icons
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ), // Đảm bảo màu chữ rõ ràng
        shadowColor:
            isDark
                ? Colors.transparent
                : Colors.black12, // M3 ít dùng shadow rõ rệt
        surfaceTintColor:
            isDark ? null : colorScheme.surfaceTint, // Tint khi scroll
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ), // Icon trên AppBar
      ),
      cardTheme: CardThemeData(
        elevation:
            AppDimens
                .elevationS, // M3 thường là 1 (filled), 1 (elevated), 0 (outlined)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusL,
          ), // M3 thường là 12.0
          side:
              colorScheme.brightness == Brightness.light
                  ? BorderSide(
                    color: colorScheme.outlineVariant,
                  ) // Thêm viền nhẹ cho card sáng (optional)
                  : BorderSide.none, // Card tối thường không cần viền
        ),
        // Chuẩn M3: Card thường dùng surfaceContainerLowest (sáng) hoặc surfaceContainerLow (tối)
        color:
            isDark
                ? colorScheme.surfaceContainerLow
                : colorScheme.surfaceContainerLowest,
        surfaceTintColor:
            colorScheme.surfaceTint, // Cho hiệu ứng elevation tint
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppDimens.elevationS, // M3 là 1 khi enable, 0 khi disable
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL, // M3 thường là 24.0
            vertical: AppDimens.paddingM, // M3 thường là 10.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimens.radiusM,
            ), // M3 thường là 20.0 (full)
          ),
          foregroundColor: colorScheme.onPrimary, // OK
          backgroundColor: colorScheme.primary, // OK
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ), // Chuẩn M3 disable
          disabledBackgroundColor: colorScheme.onSurface.withValues(
            alpha: 0.12,
          ), // Chuẩn M3 disable
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL, // M3 thường là 24.0
            vertical: AppDimens.paddingM, // M3 thường là 10.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimens.radiusM,
            ), // M3 thường là 20.0 (full)
          ),
          side: BorderSide(
            color: colorScheme.outline, // Chuẩn M3: Dùng outline
            width: AppDimens.outlineButtonBorderWidth, // M3 là 1.0
          ),
          foregroundColor: colorScheme.primary, // OK
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ), // Chuẩn M3 disable
          disabledBackgroundColor:
              Colors.transparent, // Outlined không có background disable
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary, // OK
          padding: const EdgeInsets.symmetric(
            horizontal:
                AppDimens
                    .paddingL, // M3 thường là 12.0 (start/end) và 4.0 (top/bottom nếu có icon)
            vertical: AppDimens.paddingM, // M3 thường là 10.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimens.radiusS,
            ), // M3 thường là 20.0 (full)
          ),
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ), // Chuẩn M3 disable
          disabledBackgroundColor: Colors.transparent,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Chuẩn M3: Fill color thường là surfaceContainerHighest hoặc tương tự.
        // Lựa chọn AppColors gốc với alpha có thể là ý đồ thiết kế riêng, giữ lại nhưng comment lựa chọn M3.
        fillColor:
            isDark
                ? colorScheme
                    .surfaceContainerLow // Sử dụng colorScheme
                : AppColors.lightOnSurface.withValues(
                  alpha: AppDimens.opacityLight,
                ), // Giữ lại từ mã gốc nếu là ý đồ
        // : colorScheme.surfaceContainerHighest, // Lựa chọn M3 thay thế cho light theme
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXL, // M3 là 16.0
          vertical: AppDimens.paddingL, // M3 là 16.0
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusM,
          ), // M3 thường là 4.0 (top), 0.0 (bottom) cho Filled; hoặc 4.0 cho Outlined
          borderSide: BorderSide(color: colorScheme.outline), // Chuẩn M3
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline), // Chuẩn M3
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.primary, // OK
            width: AppDimens.elevationS, // M3 là 2.0
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.error, // OK
            width: AppDimens.dividerThickness, // M3 là 1.0
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.error, // OK
            width: AppDimens.elevationS, // M3 là 2.0
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.12),
          ), // M3 disable border
        ),
        // Chuẩn M3: label/hint dùng onSurfaceVariant
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ), // OK
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ), // OK
        helperStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ), // Thêm helper style
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ), // Chuẩn M3 nên dùng error trực tiếp
        floatingLabelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.primary,
        ), // OK
        prefixIconColor: colorScheme.onSurfaceVariant, // Chuẩn M3
        suffixIconColor: colorScheme.onSurfaceVariant, // Chuẩn M3
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant, // Chuẩn M3: Dùng outlineVariant
        thickness: AppDimens.dividerThickness, // M3 là 1.0
        space:
            AppDimens
                .paddingL, // Điều chỉnh khoảng cách nếu cần (M3 không quy định cứng)
      ),
      dialogTheme: DialogThemeData(
        // Chuẩn M3: Dùng surfaceContainerHigh
        backgroundColor:
            isDark
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surfaceContainerHigh,
        elevation: AppDimens.elevationL, // M3 thường là 6
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusXL,
          ), // M3 thường là 28.0
        ),
        iconColor: colorScheme.secondary, // Chuẩn M3
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ), // Chuẩn M3
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ), // Chuẩn M3
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL, // M3 là 16.0 (start), 24.0 (end)
          vertical: AppDimens.paddingS,
        ),
        minLeadingWidth: AppDimens.iconL, // Điều chỉnh nếu cần
        minVerticalPadding: AppDimens.paddingL,
        iconColor:
            colorScheme
                .onSurfaceVariant, // Chuẩn M3: Dùng onSurfaceVariant hoặc primary nếu cần nhấn mạnh
        textColor: colorScheme.onSurface, // Màu cho leading/trailing text
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ), // Màu cho title
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ), // Màu cho subtitle
      ),
      chipTheme: ChipThemeData(
        // Chuẩn M3: Dùng surfaceContainerLow hoặc outline tùy loại chip (Input, Filter, Assist, Suggestion)
        backgroundColor: colorScheme.surfaceContainerLow, // Lựa chọn trung tính
        selectedColor:
            colorScheme
                .secondaryContainer, // Chuẩn M3 cho Filter chip khi selected
        secondarySelectedColor:
            colorScheme.primaryContainer, // Nếu cần phân biệt
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        padding: const EdgeInsets.symmetric(
          horizontal:
              AppDimens
                  .paddingM, // M3 thường là 12.0 (Assist/Input/Suggestion) hoặc 8.0 (Filter)
          vertical: AppDimens.paddingS, // M3 là 6.0
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ), // Màu chữ khi chưa chọn
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ), // Màu chữ khi chọn (nếu dùng secondaryContainer)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusXL,
          ), // M3 thường là 8.0
          side: BorderSide(
            color: colorScheme.outline,
          ), // Chuẩn M3: Dùng outline cho chip không elevated
        ),
        elevation: AppDimens.elevationNone, // M3 là 0 cho flat chip
        pressElevation:
            AppDimens.elevationXS, // M3 là 1 cho flat chip khi pressed
        iconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 18.0,
        ), // Icon trong chip (M3)
        checkmarkColor:
            colorScheme.onSecondaryContainer, // Màu dấu tick khi chọn (M3)
      ),
      iconTheme: IconThemeData(
        // Chuẩn M3: Icon độc lập thường dùng onSurfaceVariant
        color: colorScheme.onSurfaceVariant,
        size: AppDimens.iconL, // M3 là 24.0
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // Chuẩn M3: Dùng surfaceContainer
        backgroundColor: colorScheme.surfaceContainer,
        selectedItemColor: colorScheme.onSurface, // Màu icon và label được chọn
        unselectedItemColor:
            colorScheme.onSurfaceVariant, // Màu icon và label không được chọn
        selectedLabelStyle: textTheme.labelSmall, // Font style
        unselectedLabelStyle: textTheme.labelSmall, // Font style
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ), // Có thể thêm hiệu ứng riêng cho icon chọn
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimens.elevationL, // M3 thường là 3
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),
      tabBarTheme: TabBarThemeData(
        // TabBar thường nằm trên AppBar hoặc surface khác
        // Không cần set màu nền riêng trừ khi có thiết kế đặc biệt
        labelColor: colorScheme.primary, // Màu text tab được chọn
        unselectedLabelColor:
            colorScheme.onSurfaceVariant, // Màu text tab không được chọn
        labelStyle: textTheme.titleSmall, // Font style
        unselectedLabelStyle: textTheme.titleSmall, // Font style
        indicatorColor: colorScheme.primary, // Màu của indicator
        indicatorSize: TabBarIndicatorSize.tab, // Indicator full tab
        dividerColor:
            colorScheme
                .surfaceContainerHighest, // Màu đường kẻ dưới TabBar (M3)
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          // Hiệu ứng ripple
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.08);
          }
          return null;
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        // Chuẩn M3: FAB thường dùng primaryContainer hoặc tertiaryContainer
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: AppDimens.elevationL, // M3 là 6
        hoverElevation: AppDimens.elevationXL, // M3 là 8
        focusElevation: AppDimens.elevationL, // M3 là 6
        highlightElevation: AppDimens.elevationXL, // M3 là 12
        disabledElevation: 0.0,
        shape: RoundedRectangleBorder(
          // M3 FAB mặc định là 16.0
          borderRadius: BorderRadius.circular(
            AppDimens.radiusL,
          ), // Giữ lại hoặc đổi thành 16.0
        ),
        // Có thể định nghĩa riêng cho small, large, extended FAB nếu cần
        // smallSizeConstraints: const BoxConstraints.tightFor(width: 40.0, height: 40.0),
        // largeSizeConstraints: const BoxConstraints.tightFor(width: 96.0, height: 96.0),
        // extendedPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        // extendedTextStyle: textTheme.labelLarge,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary, // OK
        linearTrackColor: colorScheme.surfaceContainerHighest, // OK
        circularTrackColor: colorScheme.surfaceContainerHighest, // OK
        refreshBackgroundColor: colorScheme.surfaceContainerLow, // OK
      ),
      snackBarTheme: SnackBarThemeData(
        // Chuẩn M3: Dùng inverseSurface
        backgroundColor: colorScheme.inverseSurface,
        actionTextColor:
            colorScheme.inversePrimary, // Màu chữ của Action button
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ), // Màu chữ nội dung
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS), // M3 là 4.0
        ),
        behavior: SnackBarBehavior.floating, // OK
        elevation: 6.0, // M3 là 6
      ),
      tooltipTheme: TooltipThemeData(
        // Chuẩn M3: Dùng màu trung tính đậm/nhạt tùy theme
        decoration: BoxDecoration(
          color:
              isDark
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.inverseSurface, // Sử dụng màu M3 phù hợp
          borderRadius: BorderRadius.circular(AppDimens.radiusS), // M3 là 4.0
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color:
              isDark
                  ? colorScheme.onSurface
                  : colorScheme.onInverseSurface, // Đảm bảo tương phản
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ), // M3 padding
        waitDuration: const Duration(
          milliseconds: 500,
        ), // Thời gian chờ hiển thị
        showDuration: const Duration(milliseconds: 1500), // Thời gian hiển thị
      ),
      // Thêm các tùy chỉnh khác nếu cần (Switch, Radio, Checkbox, Slider...)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return isDark ? Colors.grey.shade800 : Colors.grey.shade400;
          }
          return isDark ? colorScheme.outline : colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          if (states.contains(WidgetState.disabled)) {
            return isDark ? Colors.white10 : Colors.black12;
          }
          return isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return isDark ? Colors.white10 : Colors.black12;
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return isDark ? colorScheme.outline : colorScheme.outline;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          return null; // Use default outline color
        }),
        checkColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled) &&
              states.contains(WidgetState.selected)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onPrimary; // Color of the check mark
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
        side: WidgetStateBorderSide.resolveWith((states) {
          return BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: states.contains(WidgetState.disabled) ? 0.38 : 1.0,
            ),
          );
        }), // Border color when unchecked
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onSurfaceVariant; // Color when unselected
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
      ),
    );
  }
}
