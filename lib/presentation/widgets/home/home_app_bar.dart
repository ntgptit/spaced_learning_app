import 'package:flutter/material.dart';

/// Custom AppBar for the Home screen
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
      actions: [
        // Theme toggle button
        IconButton(
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: onThemeToggle,
          tooltip: 'Toggle theme',
        ),

        // Notifications button
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications or navigate to notifications screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
          tooltip: 'Notifications',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
