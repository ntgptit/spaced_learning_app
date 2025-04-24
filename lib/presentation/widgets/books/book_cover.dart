import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

class BookCover extends StatelessWidget {
  final BookSummary book;
  final ThemeData theme;

  const BookCover({super.key, required this.book, required this.theme});

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final bookIdHash = book.id.hashCode;
    final hue = (bookIdHash % 360).abs().toDouble();
    const saturation = 0.6;
    const lightness = 0.75;
    final coverColor = HSLColor.fromAHSL(
      1.0,
      hue,
      saturation,
      lightness,
    ).toColor();

    return Container(
      width: AppDimens.thumbnailSizeS,
      // 80.0
      height: AppDimens.thumbnailSizeM * 0.85,
      // 102.0 (adjusted to maintain aspect ratio)
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            coverColor,
            coverColor.withValues(alpha: AppDimens.opacityVeryHigh),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: AppDimens.opacitySemi),
            blurRadius: AppDimens.shadowRadiusM,
            offset: const Offset(0, AppDimens.shadowOffsetS),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            child: CustomPaint(
              painter: _BookPatternPainter(
                patternColor: colorScheme.onPrimary.withValues(
                  alpha: AppDimens.opacitySemi,
                ),
                lineCount: 3,
              ),
              size: const Size(
                AppDimens.thumbnailSizeS,
                AppDimens.thumbnailSizeM * 0.85,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book,
                  size: AppDimens.iconL,
                  color: colorScheme.onPrimary.withValues(
                    alpha: AppDimens.opacityFull,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingXS,
                  ),
                  child: Text(
                    book.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          if (book.category != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.shadow.withValues(
                    alpha: AppDimens.opacityMediumHigh,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimens.radiusM),
                    bottomRight: Radius.circular(AppDimens.radiusM),
                  ),
                ),
                child: Text(
                  book.category ?? '',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontSize: 8,
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

class _BookPatternPainter extends CustomPainter {
  final Color patternColor;
  final int lineCount;

  _BookPatternPainter({required this.patternColor, required this.lineCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = patternColor
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final spacingY = size.height / (lineCount + 1);
    for (int i = 1; i <= lineCount; i++) {
      final y = spacingY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
