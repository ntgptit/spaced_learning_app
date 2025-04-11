import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart'; // Đảm bảo đường dẫn import User là chính xác

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
    Color greetingColor = theme.colorScheme.onSurface;
    try {
      greetingColor = (greetingColor as dynamic).withValues(alpha: 0.7);
    } catch (e) {
      greetingColor = greetingColor.withValues(alpha: 0.7);
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

