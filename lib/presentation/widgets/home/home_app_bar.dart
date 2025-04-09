import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Custom AppBar for the Home screen with theme toggle and notifications
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback? onMenuPressed;

  const HomeAppBar({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: AppDimens.iconL,
          color: theme.iconTheme.color,
        ),
        onPressed: onMenuPressed,
        tooltip: 'Menu',
      ),
      title: Text('Spaced Learning', style: theme.textTheme.titleLarge),
      actions: [
        _buildThemeToggleButton(theme),
        _buildNotificationsButton(context, theme),
      ],
    );
  }

  Widget _buildThemeToggleButton(ThemeData theme) {
    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.light_mode : Icons.dark_mode,
        size: AppDimens.iconL,
        color: theme.iconTheme.color,
      ),
      onPressed: onThemeToggle,
      tooltip: 'Toggle theme',
    );
  }

  Widget _buildNotificationsButton(BuildContext context, ThemeData theme) {
    return IconButton(
      icon: Icon(
        Icons.notifications_outlined,
        size: AppDimens.iconL,
        color: theme.iconTheme.color,
      ),
      onPressed: () => _showNotificationsSnackBar(context),
      tooltip: 'Notifications',
    );
  }

  void _showNotificationsSnackBar(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notifications coming soon')));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
