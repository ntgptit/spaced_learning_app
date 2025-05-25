// lib/presentation/widgets/modules/detail/module_loading_skeleton.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class ModuleLoadingSkeleton extends StatefulWidget {
  final bool showHeaderSkeleton;
  final bool showProgressSkeleton;
  final bool showContentSkeleton;
  final int contentSections;

  const ModuleLoadingSkeleton({
    super.key,
    this.showHeaderSkeleton = true,
    this.showProgressSkeleton = true,
    this.showContentSkeleton = true,
    this.contentSections = 3,
  });

  @override
  State<ModuleLoadingSkeleton> createState() => _ModuleLoadingSkeletonState();
}

class _ModuleLoadingSkeletonState extends State<ModuleLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeShimmerAnimation();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _initializeShimmerAnimation() {
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _shimmerController.repeat();
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppDimens.radiusS),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_shimmerAnimation.value - 1).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 1).clamp(0.0, 1.0),
              ],
              colors: [
                Theme.of(context).colorScheme.surfaceContainerHighest,
                Theme.of(context).colorScheme.surfaceContainerHigh,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSkeleton(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module Icon Skeleton
            _buildShimmerContainer(
              width: AppDimens.avatarSizeXXL,
              height: AppDimens.avatarSizeXXL,
              borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            ),
            const SizedBox(width: AppDimens.spaceL),
            // Title and Info Skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main title skeleton
                  _buildShimmerContainer(
                    width: double.infinity,
                    height: 32,
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  // Book info skeleton
                  _buildShimmerContainer(
                    width: 180,
                    height: 24,
                    borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  // Stats chips skeleton
                  Row(
                    children: [
                      _buildShimmerContainer(
                        width: 80,
                        height: 24,
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                      const SizedBox(width: AppDimens.spaceM),
                      _buildShimmerContainer(
                        width: 100,
                        height: 24,
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action button skeleton
            _buildShimmerContainer(
              width: AppDimens.avatarSizeL,
              height: AppDimens.avatarSizeL,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXL),
        // Info card skeleton
        _buildShimmerContainer(
          width: double.infinity,
          height: 120,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
      ],
    );
  }

  Widget _buildProgressSkeleton(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress header skeleton
        Row(
          children: [
            _buildShimmerContainer(
              width: AppDimens.avatarSizeL,
              height: AppDimens.avatarSizeL,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerContainer(
                    width: 150,
                    height: 24,
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                  const SizedBox(height: AppDimens.spaceXS),
                  _buildShimmerContainer(
                    width: 200,
                    height: 16,
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                ],
              ),
            ),
            _buildShimmerContainer(
              width: 80,
              height: 32,
              borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXL),
        // Progress bar skeleton
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerContainer(
                  width: 80,
                  height: 14,
                  borderRadius: BorderRadius.circular(AppDimens.radiusS),
                ),
                _buildShimmerContainer(
                  width: 40,
                  height: 16,
                  borderRadius: BorderRadius.circular(AppDimens.radiusS),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),
            _buildShimmerContainer(
              width: double.infinity,
              height: AppDimens.lineProgressHeightL,
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        // Info items skeleton
        Row(
          children: [
            Expanded(
              child: _buildShimmerContainer(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildShimmerContainer(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        // Action buttons skeleton
        Row(
          children: [
            Expanded(
              child: _buildShimmerContainer(
                width: double.infinity,
                height: AppDimens.buttonHeightL,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: _buildShimmerContainer(
                width: double.infinity,
                height: AppDimens.buttonHeightL,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentSectionSkeleton(ColorScheme colorScheme, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header skeleton
        Row(
          children: [
            _buildShimmerContainer(
              width: AppDimens.avatarSizeL,
              height: AppDimens.avatarSizeL,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            const SizedBox(width: AppDimens.spaceL),
            _buildShimmerContainer(
              width: 180 + (index * 20.0),
              height: 28,
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        // Content skeleton
        _buildShimmerContainer(
          width: double.infinity,
          height: 200 + (index * 50.0),
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
      ],
    );
  }

  Widget _buildContentSkeleton(ColorScheme colorScheme) {
    return Column(
      children: List.generate(widget.contentSections, (index) {
        return Column(
          children: [
            _buildContentSectionSkeleton(colorScheme, index),
            if (index < widget.contentSections - 1)
              const SizedBox(height: AppDimens.spaceXXL),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeaderSkeleton) ...[
            _buildHeaderSkeleton(colorScheme),
            const SizedBox(height: AppDimens.spaceXXL),
          ],
          if (widget.showProgressSkeleton) ...[
            _buildProgressSkeleton(colorScheme),
            const SizedBox(height: AppDimens.spaceXXL),
          ],
          if (widget.showContentSkeleton) ...[
            _buildContentSkeleton(colorScheme),
          ],
        ],
      ),
    );
  }
}

// Extension for skeleton variations
extension ModuleLoadingSkeletonVariations on ModuleLoadingSkeleton {
  /// Creates a header-only skeleton
  static Widget headerOnly() {
    return const ModuleLoadingSkeleton(
      showHeaderSkeleton: true,
      showProgressSkeleton: false,
      showContentSkeleton: false,
    );
  }

  /// Creates a progress-only skeleton
  static Widget progressOnly() {
    return const ModuleLoadingSkeleton(
      showHeaderSkeleton: false,
      showProgressSkeleton: true,
      showContentSkeleton: false,
    );
  }

  /// Creates a content-only skeleton
  static Widget contentOnly({int sections = 3}) {
    return ModuleLoadingSkeleton(
      showHeaderSkeleton: false,
      showProgressSkeleton: false,
      showContentSkeleton: true,
      contentSections: sections,
    );
  }

  /// Creates a minimal skeleton for faster loading
  static Widget minimal() {
    return const ModuleLoadingSkeleton(
      showHeaderSkeleton: true,
      showProgressSkeleton: false,
      showContentSkeleton: true,
      contentSections: 2,
    );
  }

  /// Creates a complete skeleton with all sections
  static Widget complete() {
    return const ModuleLoadingSkeleton(
      showHeaderSkeleton: true,
      showProgressSkeleton: true,
      showContentSkeleton: true,
      contentSections: 3,
    );
  }
}
