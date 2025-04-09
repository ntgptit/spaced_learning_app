import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authViewModel = context.watch<AuthViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.onPrimaryContainer.withOpacity(0.1),
              child: Text(
                _getInitials(
                  authViewModel.currentUser?.displayName ??
                      authViewModel.currentUser?.email ??
                      'User',
                ),
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(
              authViewModel.currentUser?.displayName ?? 'User',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            accountEmail: Text(
              authViewModel.currentUser?.email ?? '',
              style: TextStyle(
                color: colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Home', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Books', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/books');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.today,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Due Progress', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/due-progress');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.analytics_outlined,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Learning Stats', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/learning');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Profile', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/profile');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Reminder Settings', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/settings/reminders');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text(
              'Spaced Repetition Info',
              style: theme.textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/help/spaced-repetition');
            },
          ),
          Divider(
            height: AppDimens.dividerThickness,
            color: colorScheme.outlineVariant,
          ),
          ListTile(
            leading: Icon(
              themeViewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text(
              themeViewModel.isDarkMode ? 'Light Mode' : 'Dark Mode',
              style: theme.textTheme.bodyLarge,
            ),
            onTap: () {
              themeViewModel.toggleTheme();
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingL,
              vertical: AppDimens.paddingS,
            ),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                size: AppDimens.iconL,
                color: colorScheme.error,
              ),
              title: Text('Logout', style: theme.textTheme.bodyLarge),
              onTap: () async {
                Navigator.pop(context);
                await authViewModel.logout();
                if (context.mounted) {
                  GoRouter.of(context).go('/login');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String text) {
    if (text.isEmpty) return '';

    if (text.contains('@')) {
      return text[0].toUpperCase();
    }

    final words = text.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return (words[0][0] + words[1][0]).toUpperCase();
  }
}
