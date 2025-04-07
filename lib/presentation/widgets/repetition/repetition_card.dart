import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Removed direct AppColors import
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart'; // Ensure path is correct

/// Card representing a single repetition session, styled using Theme
class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final bool isHistory;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSkip;
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
    // Use passed theme or get from context
    final currentTheme = theme ?? Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy'); // Corrected format likely

    final orderText = _formatRepetitionOrder(repetition.repetitionOrder);
    // Get status color based on theme
    final statusColor = _getStatusColor(repetition.status, currentTheme);
    final dateText =
        repetition.reviewDate != null
            ? dateFormat.format(repetition.reviewDate!)
            : 'Not scheduled';
    final timeIndicator = _getTimeIndicator(repetition.reviewDate);
    // Get time indicator color based on theme
    final indicatorColor = _getTimeIndicatorColor(
      repetition.reviewDate,
      currentTheme,
    );
    // Determine contrast color for text on time indicator
    final onIndicatorColor =
        ThemeData.estimateBrightnessForColor(indicatorColor) == Brightness.dark
            ? Colors
                .white // Text on dark background
            : Colors.black; // Text on light background

    return Card(
      // Card theme applied automatically
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      elevation:
          isHistory
              ? (currentTheme.cardTheme.elevation ?? AppDimens.elevationS) *
                  0.5 // Example: reduce elevation for history
              : currentTheme.cardTheme.elevation ?? AppDimens.elevationS,
      // Use theme surface color, adjust opacity for history
      color:
          isHistory
              ? currentTheme.colorScheme.surface.withOpacity(
                AppDimens.opacityVeryHigh,
              )
              : currentTheme.cardTheme.color ??
                  currentTheme.colorScheme.surface,
      shape: currentTheme.cardTheme.shape, // Use theme shape
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pass theme and theme-based statusColor
            _buildHeader(currentTheme, orderText, statusColor),
            const SizedBox(height: AppDimens.spaceM),
            // Pass theme and theme-based indicator colors
            _buildDateRow(
              context,
              currentTheme,
              dateText,
              timeIndicator,
              indicatorColor,
              onIndicatorColor,
            ),
            if (!isHistory && repetition.status == RepetitionStatus.notStarted)
              // Pass theme to actions builder
              _buildActions(context, currentTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String orderText, Color statusColor) {
    // Determine text color that contrasts well with the semi-transparent status background
    final onStatusColor =
        ThemeData.estimateBrightnessForColor(statusColor) == Brightness.dark
            ? Colors.white.withOpacity(
              0.9,
            ) // Slightly less prominent on dark bg
            : Colors.black.withOpacity(
              0.9,
            ); // Slightly less prominent on light bg

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderText,
          // Use theme text style
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
          decoration: BoxDecoration(
            // Use theme-based status color with opacity
            color: statusColor.withOpacity(AppDimens.opacityMedium),
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatStatus(repetition.status),
                // Use theme text style, ensure contrast with background
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onStatusColor, // Use contrast color
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Keep Quiz icon if status is completed, using contrast color
              if (repetition.status == RepetitionStatus.completed) ...[
                const SizedBox(width: AppDimens.spaceXS),
                Icon(Icons.quiz, size: AppDimens.iconXS, color: onStatusColor),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    ThemeData theme,
    String dateText,
    String timeIndicator,
    Color indicatorColor, // Receive theme-based indicator color
    Color onIndicatorColor, // Receive theme-based text color for indicator
  ) {
    return Row(
      children: [
        Icon(
          Icons.quiz, // Or Icons.calendar_today ?
          // Use theme primary color for the date icon
          color: theme.colorScheme.primary,
          size: AppDimens.iconS,
        ),
        const SizedBox(width: AppDimens.spaceS),
        // Use theme text style for date
        Text(dateText, style: theme.textTheme.bodyMedium),
        const Spacer(),
        if (repetition.reviewDate != null &&
            !isHistory &&
            timeIndicator.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingS,
              vertical: AppDimens.paddingXXS,
            ),
            decoration: BoxDecoration(
              // Use theme-based indicator color
              color: indicatorColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
            ),
            child: Text(
              timeIndicator,
              // Use theme text style and contrasting color
              style: theme.textTheme.bodySmall?.copyWith(
                color: onIndicatorColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    // Define semantic colors based on theme for actions
    final Color rescheduleColor = theme.colorScheme.primary;
    final Color skipColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F); // Warning
    final Color completeColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784); // Success

    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.paddingL),
      child: Wrap(
        // Use Wrap for better responsiveness if buttons overflow
        alignment: WrapAlignment.end,
        spacing: AppDimens.spaceS, // Horizontal space between buttons
        runSpacing: AppDimens.spaceS, // Vertical space if they wrap
        children: [
          if (onReschedule != null)
            _buildActionButton(
              theme, // Pass theme
              'Reschedule',
              Icons.calendar_month,
              rescheduleColor, // Pass theme-based color
              onReschedule!,
            ),
          if (onSkip != null)
            _buildActionButton(
              theme, // Pass theme
              'Skip',
              Icons.skip_next,
              skipColor, // Pass theme-based color
              onSkip!,
            ),
          if (onMarkCompleted != null)
            _buildActionButton(
              theme, // Pass theme
              'Complete',
              Icons.check_circle,
              completeColor, // Pass theme-based color
              onMarkCompleted!,
              showScoreIndicator: true,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme, // Receive theme
    String label,
    IconData icon,
    Color color, // Receive theme-based semantic color
    VoidCallback onPressed, {
    bool showScoreIndicator = false,
  }) {
    // Determine text/icon color for contrast on the score indicator background
    final onScoreIndicatorColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return SizedBox(
      height: AppDimens.buttonHeightM,
      // Use theme's OutlinedButton styling
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: AppDimens.iconS,
        ), // Let theme handle icon color via foregroundColor
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label), // Let theme handle text color via foregroundColor
            if (showScoreIndicator) ...[
              const SizedBox(width: AppDimens.spaceXXS),
              Container(
                padding: const EdgeInsets.all(AppDimens.paddingXXS),
                decoration: BoxDecoration(
                  // Use semantic color with opacity for background
                  color: color.withOpacity(AppDimens.opacityMedium),
                  borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                ),
                child: Icon(
                  Icons.percent,
                  size: AppDimens.iconXXS,
                  // Ensure contrast for icon on background
                  color: onScoreIndicatorColor.withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
        style: OutlinedButton.styleFrom(
          // Apply the semantic color to foreground (text/icon) and border
          foregroundColor: color,
          side: BorderSide(
            // Use semantic color with opacity for border
            color: color.withOpacity(AppDimens.opacityMediumHigh),
          ),
          // Inherit shape from theme or define explicitly
          shape: theme.outlinedButtonTheme.style?.shape?.resolve({}),
          // ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusL)),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
          textStyle:
              theme.textTheme.labelMedium, // Use appropriate theme text style
        ).copyWith(
          // Ensure minimum size if needed, or let theme handle it
          minimumSize: WidgetStateProperty.all(Size.zero),
        ),
      ),
    );
  }

  // --- Helper Functions ---

  String _formatRepetitionOrder(RepetitionOrder order) {
    // (Implementation remains the same)
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
    // (Implementation remains the same)
    switch (status) {
      case RepetitionStatus.notStarted:
        return 'Pending';
      case RepetitionStatus.completed:
        return 'Completed';
      case RepetitionStatus.skipped:
        return 'Skipped';
    }
  }

  // Updated to accept Theme and return theme-based colors
  Color _getStatusColor(RepetitionStatus status, ThemeData theme) {
    switch (status) {
      case RepetitionStatus.notStarted:
        // Use primary or a neutral color from theme
        return theme.colorScheme.primary;
      case RepetitionStatus.completed:
        // Use a success color derived from theme
        return theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784);
      case RepetitionStatus.skipped:
        // Use a warning color derived from theme
        return theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F);
    }
  }

  String _getTimeIndicator(DateTime? date) {
    // (Implementation remains the same)
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(today).inDays;

    if (difference < 0) return 'Overdue ${-difference}d';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return '$difference days left';
  }

  // Updated to accept Theme and return theme-based colors
  Color _getTimeIndicatorColor(DateTime? date, ThemeData theme) {
    if (date == null) {
      return theme.colorScheme.outline; // Use theme outline color
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(today).inDays;

    // Map time differences to semantic theme colors
    if (difference < 0) return theme.colorScheme.error; // Overdue = Error
    if (difference == 0) {
      return theme.brightness == Brightness.light
          ? const Color(0xFF2E7D32)
          : const Color(0xFFC8E6C9); // Today = Success (Darker/Lighter)
    }
    if (difference <= 3) {
      return theme.brightness == Brightness.light
          ? const Color(0xFFFFC107)
          : const Color(0xFFFFD54F); // Soon = Warning
    }
    // Further out, use secondary or tertiary theme color
    return theme.colorScheme.secondary;
  }
}

// Assume Repetition and enums are defined elsewhere
// enum RepetitionOrder { firstRepetition, secondRepetition, thirdRepetition, fourthRepetition, fifthRepetition }
// enum RepetitionStatus { notStarted, completed, skipped }
// class Repetition {
//   final String id;
//   final RepetitionOrder repetitionOrder;
//   final RepetitionStatus status;
//   final DateTime? reviewDate;
//   // ... other fields
//   Repetition({required this.id, required this.repetitionOrder, required this.status, this.reviewDate});
// }

// Helper extension (optional)
// extension ColorAlpha on Color {
//   Color withValues({double? alpha}) {
//     if (alpha != null) {
//       return withOpacity(alpha);
//     }
//     return this;
//   }
// }
