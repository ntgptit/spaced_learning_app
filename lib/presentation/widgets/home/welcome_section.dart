import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart';

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
        const SizedBox(height: AppDimens.spaceXS), // Changed from 4
        _buildUserName(theme),
        const SizedBox(height: AppDimens.spaceS), // Changed from 8
        _buildMotivationalText(theme),
      ],
    );
  }

  Widget _buildGreeting(ThemeData theme) {
    return Text(
      'Welcome back,',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserName(ThemeData theme) {
    return Text(
      user.displayName ?? user.email,
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
