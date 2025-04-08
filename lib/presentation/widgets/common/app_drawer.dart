import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authViewModel = context.watch<AuthViewModel>();

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
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.analytics_outlined,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Learning Overview', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/learning/progress');
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
            },
          ),
          Divider(
            height: AppDimens.dividerThickness,
            color: colorScheme.outlineVariant,
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              size: AppDimens.iconL,
              color: colorScheme.primary,
            ),
            title: Text('Help', style: theme.textTheme.bodyLarge),
            onTap: () {
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
                  Navigator.pushReplacementNamed(context, '/login');
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
