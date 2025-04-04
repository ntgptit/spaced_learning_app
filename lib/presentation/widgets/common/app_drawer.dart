import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Thêm import
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();

    return Drawer(
      child: Column(
        children: [
          // Header with user info
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimary,
              child: Text(
                _getInitials(
                  authViewModel.currentUser?.displayName ??
                      authViewModel.currentUser?.email ??
                      'User',
                ),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(authViewModel.currentUser?.displayName ?? 'User'),
            accountEmail: Text(authViewModel.currentUser?.email ?? ''),
          ),

          // Navigation items
          ListTile(
            leading: const Icon(Icons.home, size: AppDimens.iconL),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          // New item for Learning Progress Overview
          ListTile(
            leading: const Icon(
              Icons.analytics_outlined,
              size: AppDimens.iconL,
            ),
            title: const Text('Learning Overview'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/learning/progress');
            },
          ),

          ListTile(
            leading: const Icon(Icons.book, size: AppDimens.iconL),
            title: const Text('Books'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to books screen
            },
          ),

          ListTile(
            leading: const Icon(Icons.person, size: AppDimens.iconL),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to profile screen
            },
          ),

          const Divider(height: AppDimens.dividerThickness),

          ListTile(
            leading: const Icon(Icons.help_outline, size: AppDimens.iconL),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to help screen
            },
          ),

          const Spacer(),

          // Logout button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingL,
              vertical: AppDimens.paddingS,
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, size: AppDimens.iconL),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context); // Close drawer
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ),

          // App version at the bottom
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Text('Version 1.0.0', style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  /// Get initials from name or email
  String _getInitials(String text) {
    if (text.isEmpty) return '';

    // For email, use first letter
    if (text.contains('@')) {
      return text[0].toUpperCase();
    }

    // For name, use first letter of each word (max 2)
    final words = text.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return (words[0][0] + words[1][0]).toUpperCase();
  }
}
