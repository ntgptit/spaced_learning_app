import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/animations/bottom_to_top_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/animations/scale_animation_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/animations/top_show_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/common/custom_animated_icon.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/nav_head.dart';

/// A showcase screen that demonstrates all the themed components.
/// This is an example of how to use the new theme styles adapted from the todo app.
class ThemeShowcaseScreen extends StatefulWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  _ThemeShowcaseScreenState createState() => _ThemeShowcaseScreenState();
}

class _ThemeShowcaseScreenState extends State<ThemeShowcaseScreen> {
  bool _isDemoLoading = false;
  LoadingFlag _loadingFlag = LoadingFlag.loading;
  int _loadingFlagIndex = 0;

  final List<LoadingFlag> _loadingFlags = [
    LoadingFlag.loading,
    LoadingFlag.error,
    LoadingFlag.empty,
    LoadingFlag.idle,
    LoadingFlag.success,
  ];

  final List<String> _loadingLabels = [
    'Loading...',
    'Error State',
    'Empty State',
    'Idle State',
    'Success',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Showcase the Nav Head
          NavHead(
            height: 200,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Theme Showcase',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceS),
                    Text(
                      'Adapted from the Todo App style',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content in a scrollable container
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color Palette
                    _buildSectionTitle('Color Palette'),
                    _buildColorPalette(),

                    const SizedBox(height: AppDimens.spaceXXL),

                    // Cards
                    _buildSectionTitle('Cards'),
                    BottomToTopWidget(index: 0, child: _buildCardExamples()),

                    const SizedBox(height: AppDimens.spaceXXL),

                    // Buttons
                    _buildSectionTitle('Buttons'),
                    BottomToTopWidget(index: 1, child: _buildButtonExamples()),

                    const SizedBox(height: AppDimens.spaceXXL),

                    // Progress Indicators
                    _buildSectionTitle('Progress Indicators'),
                    BottomToTopWidget(
                      index: 2,
                      child: _buildProgressExamples(),
                    ),

                    const SizedBox(height: AppDimens.spaceXXL),

                    // Loading States
                    _buildSectionTitle('Loading States'),
                    BottomToTopWidget(index: 3, child: _buildLoadingExamples()),

                    const SizedBox(height: AppDimens.spaceXXL),

                    // Animations
                    _buildSectionTitle('Animations'),
                    BottomToTopWidget(
                      index: 4,
                      child: _buildAnimationExamples(),
                    ),

                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFloatingButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Floating Action Button Pressed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingM),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildColorPalette() {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Wrap(
      spacing: AppDimens.paddingS,
      runSpacing: AppDimens.paddingS,
      children: [
        _colorItem(
          'Primary',
          isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
        _colorItem(
          'Secondary',
          isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
        ),
        _colorItem(
          'Tertiary',
          isDark ? AppColors.darkTertiary : AppColors.lightTertiary,
        ),
        _colorItem(
          'Error',
          isDark ? AppColors.darkError : AppColors.lightError,
        ),
        _colorItem(
          'Success',
          isDark ? AppColors.successDark : AppColors.successLight,
        ),
        _colorItem(
          'Warning',
          isDark ? AppColors.warningDark : AppColors.warningLight,
        ),
        _colorItem('Info', isDark ? AppColors.infoDark : AppColors.infoLight),
        _colorItem(
          'Background',
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
        ),
        _colorItem(
          'Surface',
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
        ),
      ],
    );
  }

  Widget _colorItem(String label, Color color) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.paddingXS),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppDimens.radiusS),
                bottomRight: Radius.circular(AppDimens.radiusS),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardExamples() {
    return Column(
      children: [
        // Basic card
        const AppCard(
          title: Text('Basic Card'),
          subtitle: Text('A simple card with title and subtitle'),
          content: Text(
            'This is a basic card with title, subtitle and content. '
            'Cards are a fundamental component for organizing information.',
          ),
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Card with leading, trailing and actions
        AppCard(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.book, color: Colors.white),
          ),
          title: const Text('Advanced Card'),
          subtitle: const Text('With leading, trailing and actions'),
          trailing: const Icon(Icons.star, color: Colors.amber),
          content: const Text(
            'This card demonstrates the full capabilities of AppCard '
            'with leading, trailing and action buttons.',
          ),
          actions: [
            AppButton(
              text: 'Cancel',
              type: AppButtonType.text,
              onPressed: () {},
            ),
            AppButton(
              text: 'Confirm',
              type: AppButtonType.primary,
              size: AppButtonSize.small,
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Card with gradient background
        AppCard(
          useGradient: true,
          customGradient: AppColors.gradientPrimary,
          title: const Text(
            'Gradient Card',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Inspired by todo app styles',
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
          content: const Text(
            'This card uses a gradient background similar to those in the todo app.',
            style: TextStyle(color: Colors.white),
          ),
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Card with outer shadow
        AppCard(
          applyOuterShadow: true,
          borderRadius: AppDimens.radiusXL,
          title: const Text('Card with Custom Shadow'),
          subtitle: const Text('Uses advanced shadow effects'),
          content: const Text(
            'This card uses the outer shadow effect from the todo app '
            'to create a more pronounced depth effect.',
          ),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Card tapped')));
          },
        ),
      ],
    );
  }

  Widget _buildButtonExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Button types
        Wrap(
          spacing: AppDimens.spaceM,
          runSpacing: AppDimens.spaceM,
          children: [
            AppButton(
              text: 'Primary',
              onPressed: () {},
              type: AppButtonType.primary,
            ),
            AppButton(
              text: 'Secondary',
              onPressed: () {},
              type: AppButtonType.secondary,
            ),
            AppButton(
              text: 'Outline',
              onPressed: () {},
              type: AppButtonType.outline,
            ),
            AppButton(text: 'Text', onPressed: () {}, type: AppButtonType.text),
            AppButton(
              text: 'Ghost',
              onPressed: () {},
              type: AppButtonType.ghost,
            ),
            AppButton(
              text: 'Error',
              onPressed: () {},
              type: AppButtonType.error,
            ),
            AppButton(
              text: 'Success',
              onPressed: () {},
              type: AppButtonType.success,
            ),
            AppButton(
              text: 'Warning',
              onPressed: () {},
              type: AppButtonType.warning,
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Gradient button (inspired by todo app)
        AppButton(
          text: 'Gradient Button',
          type: AppButtonType.gradient,
          onPressed: () {},
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Button sizes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(text: 'Tiny', onPressed: () {}, size: AppButtonSize.tiny),
            AppButton(
              text: 'Small',
              onPressed: () {},
              size: AppButtonSize.small,
            ),
            AppButton(
              text: 'Medium',
              onPressed: () {},
              size: AppButtonSize.medium,
            ),
            AppButton(
              text: 'Large',
              onPressed: () {},
              size: AppButtonSize.large,
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Buttons with icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(text: 'Prefix', prefixIcon: Icons.add, onPressed: () {}),
            AppButton(
              text: 'Suffix',
              suffixIcon: Icons.arrow_forward,
              onPressed: () {},
            ),
            AppButton(
              text: 'Loading',
              prefixIcon: Icons.refresh,
              isLoading: true,
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Full width button
        AppButton(
          text: 'Full Width Button',
          onPressed: () {},
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildProgressExamples() {
    return Column(
      children: [
        // Linear progress indicators
        Text('Linear Progress', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppDimens.spaceS),

        const AppProgressIndicator(type: ProgressType.linear, value: 0.3),
        const SizedBox(height: AppDimens.spaceM),

        const AppProgressIndicator(
          type: ProgressType.linear,
          value: 0.7,
          color: AppColors.successLight,
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Animated linear progress
        const AppProgressIndicator(
          type: ProgressType.linear,
          value: 0.5,
          color: AppColors.warningLight,
          animate: true,
        ),

        const SizedBox(height: AppDimens.spaceXL),

        // Circular progress indicators
        Text(
          'Circular Progress',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimens.spaceS),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppProgressIndicator(
              type: ProgressType.circular,
              value: 0.25,
              label: '25%',
            ),
            AppProgressIndicator(
              type: ProgressType.circular,
              value: 0.5,
              label: '50%',
              color: AppColors.infoDark,
            ),
            AppProgressIndicator(
              type: ProgressType.circular,
              value: 0.75,
              label: '75%',
              color: AppColors.successLight,
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Circular progress with child
        AppProgressIndicator(
          type: ProgressType.circular,
          value: 0.65,
          size: 80,
          child: Text(
            '65%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Animated circular progress
        const AppProgressIndicator(
          type: ProgressType.circular,
          value: 0.85,
          size: 80,
          color: AppColors.accentPurple,
          animate: true,
          child: Icon(Icons.emoji_events, color: AppColors.accentPurple),
        ),
      ],
    );
  }

  Widget _buildLoadingExamples() {
    return Column(
      children: [
        // Loading states demo
        AppCard(
          title: Text(_loadingLabels[_loadingFlagIndex]),
          subtitle: const Text('Tap to cycle through states'),
          content: SizedBox(
            height: 200,
            child:
                _loadingFlag == LoadingFlag.success
                    ? const Center(child: Text('Success State!'))
                    : LoadingWidget(
                      flag: _loadingFlag,
                      errorCallBack: () {
                        _cycleLoadingFlag();
                      },
                    ),
          ),
          onTap: _cycleLoadingFlag,
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Loading overlay example
        AppCard(
          title: const Text('Loading Overlay'),
          subtitle: const Text('Demonstrates a loading overlay'),
          content: SizedBox(
            height: 150,
            child: LoadingOverlay(
              isLoading: _isDemoLoading,
              message: 'Loading content...',
              child: Center(
                child: Text(
                  _isDemoLoading
                      ? 'Content is loading...'
                      : 'Content is loaded!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          actions: [
            AppButton(
              text: _isDemoLoading ? 'Stop Loading' : 'Start Loading',
              type:
                  _isDemoLoading ? AppButtonType.error : AppButtonType.success,
              onPressed: () {
                setState(() {
                  _isDemoLoading = !_isDemoLoading;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimationExamples() {
    return Column(
      children: [
        // Scale animation
        AppCard(
          title: const Text('Scale Animation'),
          content: SizedBox(
            height: 100,
            child: Center(
              child: ScaleAnimationWidget(
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.error,
                  size: 50,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Bottom to top animation - already used in the page sections
        AppCard(
          title: const Text('Bottom-To-Top Animation'),
          content: SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'This whole page uses bottom-to-top animations!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimens.spaceM),

        // Top animation
        AppCard(
          title: const Text('Top Animation'),
          content: SizedBox(
            height: 100,
            child: Center(
              child: TopAnimationShowWidget(
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.accentPurple,
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  child: const Text(
                    'This animates from the top',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _cycleLoadingFlag() {
    setState(() {
      _loadingFlagIndex = (_loadingFlagIndex + 1) % _loadingFlags.length;
      _loadingFlag = _loadingFlags[_loadingFlagIndex];
    });
  }
}
