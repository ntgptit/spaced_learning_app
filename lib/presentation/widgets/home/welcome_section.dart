import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart';

class WelcomeSection extends StatelessWidget {
  final User user;

  const WelcomeSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGreeting(theme, colorScheme),
        const SizedBox(height: AppDimens.spaceXS),
        _buildUserName(theme, colorScheme),
        const SizedBox(height: AppDimens.spaceS),
        _buildMotivationalText(theme, colorScheme),
      ],
    );
  }

  Widget _buildGreeting(ThemeData theme, ColorScheme colorScheme) {
    final greetingColor = colorScheme.onSurface.withValues(
      alpha: AppDimens.opacityHigh,
    );

    return Text(
      'Welcome back,',
      style: theme.textTheme.bodyLarge?.copyWith(color: greetingColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserName(ThemeData theme, ColorScheme colorScheme) {
    return Text(
      user.displayName ?? user.email,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMotivationalText(ThemeData theme, ColorScheme colorScheme) {
    return Text(
      'Ready to continue your learning journey?',
      style: theme.textTheme.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
        color: colorScheme.onSurface.withValues(alpha: AppDimens.opacityHigh),
      ),
      textAlign: TextAlign.center,
    );
  }
}
