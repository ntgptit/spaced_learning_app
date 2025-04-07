import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart'; // Đảm bảo đường dẫn import User là chính xác

/// Welcome section for the home screen displaying user information
class WelcomeSection extends StatelessWidget {
  final User user;

  const WelcomeSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGreeting(theme),
        const SizedBox(height: AppDimens.spaceXS),
        _buildUserName(theme),
        const SizedBox(height: AppDimens.spaceS),
        _buildMotivationalText(theme),
      ],
    );
  }

  Widget _buildGreeting(ThemeData theme) {
    // Note: The original code uses .withValues(alpha: 0.7)
    // Assuming .withValues is an extension method you have defined,
    // otherwise use .withOpacity(0.7)
    Color greetingColor = theme.colorScheme.onSurface;
    try {
      // Attempt to use the custom extension method if it exists
      greetingColor = (greetingColor as dynamic).withValues(alpha: 0.7);
    } catch (e) {
      // Fallback to standard opacity method if extension doesn't exist or fails
      greetingColor = greetingColor.withOpacity(0.7);
      debugPrint(
        "WelcomeSection: Using withOpacity fallback for greeting color. Define 'withValues' extension if needed.",
      );
    }

    return Text(
      'Welcome back,',
      style: theme.textTheme.bodyLarge?.copyWith(color: greetingColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserName(ThemeData theme) {
    return Text(
      user.displayName ?? user.email, // Assuming User model has 'email'
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMotivationalText(ThemeData theme) {
    return Text(
      'Ready to continue your learning journey?',
      style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
      textAlign: TextAlign.center,
    );
  }
}

// You might need this extension method defined somewhere accessible
// (e.g., in app_colors.dart or a utility file) if you intend to use .withValues
// extension ColorAlpha on Color {
//   Color withValues({double? alpha}) {
//     if (alpha != null) {
//       return withOpacity(alpha);
//     }
//     return this;
//   }
// }
