// ✅ BOOK WIDGETS - FIXED FOR MOBILE (Responsive + FlexRender)

import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_pattern_painter.dart'
    show BookPatternPainter;

class BookCoverWidget extends StatelessWidget {
  final BookDetail book;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const BookCoverWidget({
    super.key,
    required this.book,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = width ?? screenWidth * 0.38;
    final itemHeight = height ?? itemWidth * 1.4;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppDimens.radiusM);

    final hue = (book.name.hashCode % 360).abs().toDouble();
    final backgroundColor = HSLColor.fromAHSL(1.0, hue, 0.6, 0.75).toColor();

    return Container(
      width: itemWidth,
      height: itemHeight,
      padding: padding ?? const EdgeInsets.all(AppDimens.paddingS),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor, backgroundColor.withValues(alpha: 0.8)],
        ),
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: effectiveBorderRadius,
              child: CustomPaint(
                painter: BookPatternPainter(
                  patternColor: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book,
                  size: AppDimens.iconXL,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(height: AppDimens.spaceS),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingXS,
                  ),
                  child: Text(
                    book.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
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
