import 'package:flutter/material.dart';

/// Custom AppBar for the Home screen with theme toggle and notifications
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeAppBar({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Spaced Learning'),
      actions: [_buildThemeToggleButton(), _buildNotificationsButton(context)],
    );
  }

  // UI Components
  Widget _buildThemeToggleButton() {
    return IconButton(
      icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      onPressed: onThemeToggle,
      tooltip: 'Toggle theme',
    );
  }

  Widget _buildNotificationsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_outlined),
      onPressed: () => _showNotificationsSnackBar(context),
      tooltip: 'Notifications',
    );
  }

  // Helper Methods
  void _showNotificationsSnackBar(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notifications coming soon')));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
