// lib/presentation/widgets/common/card/sl_image_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlImageCard extends StatelessWidget {
  final String? imageUrl;
  final Widget? imageWidget;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final double height;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final bool overlayContent;
  final Color? overlayColor;
  final double? overlayOpacity;
  final CrossAxisAlignment contentAlignment;
  final BoxFit imageFit;
  final bool applyImageFilter;

  const SlImageCard({
    super.key,
    this.imageUrl,
    this.imageWidget,
    required this.title,
    this.subtitle,
    this.actions,
    this.onTap,
    this.height = 200,
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.borderRadius = AppDimens.radiusL,
    this.overlayContent = true,
    this.overlayColor,
    this.overlayOpacity = 0.5,
    this.contentAlignment = CrossAxisAlignment.start,
    this.imageFit = BoxFit.cover,
    this.applyImageFilter = true,
  }) : assert(
         imageUrl != null || imageWidget != null,
         'Either imageUrl or imageWidget must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: height,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              _buildImage(),

              // Overlay
              if (overlayContent)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        (overlayColor ?? Colors.black).withValues(
                          alpha: overlayOpacity ?? 0.5,
                        ),
                      ],
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: Column(
                  crossAxisAlignment: contentAlignment,
                  mainAxisAlignment: overlayContent
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!overlayContent) const Spacer(),
                    Column(
                      crossAxisAlignment: contentAlignment,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: overlayContent
                                ? Colors.white
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppDimens.spaceXS),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: overlayContent
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: AppDimens.spaceM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions!.map((action) {
                          final int index = actions!.indexOf(action);
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index > 0 ? AppDimens.paddingS : 0,
                            ),
                            child: action,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageWidget != null) {
      return imageWidget!;
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      Widget image = Image.network(
        imageUrl!,
        fit: imageFit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.broken_image, size: 40)),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );

      if (applyImageFilter) {
        image = ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.darken),
          child: image,
        );
      }

      return image;
    }

    return Container(color: Colors.grey.shade300);
  }
}
