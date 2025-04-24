import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              currentAccountPicture: CircleAvatar(
                backgroundColor: colorScheme.onPrimaryContainer.withValues(
                  alpha: AppDimens.opacityLight,
                ),
                child: Text(
                  _getInitials(
                    currentUser?.displayName ?? currentUser?.email ?? 'User',
                  ),
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              accountName: Text(
                currentUser?.displayName ?? 'User',
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
              accountEmail: Text(
                currentUser?.email ?? '',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer.withValues(
                    alpha: AppDimens.opacityHigh,
                  ),
                ),
              ),
            ),
            _buildMenuItem(
              context,
              'Home',
              Icons.home,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/'),
            ),
            _buildMenuItem(
              context,
              'Books',
              Icons.book,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/books'),
            ),
            _buildMenuItem(
              context,
              'Due Progress',
              Icons.today,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/due-progress'),
            ),
            _buildMenuItem(
              context,
              'Learning Stats',
              Icons.analytics_outlined,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/learning'),
            ),
            _buildMenuItem(
              context,
              'Profile',
              Icons.person,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/profile'),
            ),
            _buildMenuItem(
              context,
              'Reminder Settings',
              Icons.settings,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/settings/reminders'),
            ),
            _buildMenuItem(
              context,
              'Task Report',
              Icons.assignment_late,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/task-report'),
            ),
            _buildMenuItem(
              context,
              'Spaced Repetition Info',
              Icons.info_outline,
              theme,
              colorScheme,
              () => _navigateAndPop(context, '/help/spaced-repetition'),
            ),
            Divider(
              height: AppDimens.dividerThickness,
              color: colorScheme.outlineVariant,
            ),
            _buildMenuItem(
              context,
              isDarkMode ? 'Light Mode' : 'Dark Mode',
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              theme,
              colorScheme,
              () {
                ref.read(themeStateProvider.notifier).toggleTheme();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppDimens.spaceL),
            _buildMenuItem(
              context,
              'Logout',
              Icons.logout,
              theme,
              colorScheme,
              () async {
                Navigator.pop(context);
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  GoRouter.of(context).go('/login');
                }
              },
              isLogout: true,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Text(
                'Version 1.0.0',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    ThemeData theme,
    ColorScheme colorScheme,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: AppDimens.iconL,
        color: isLogout ? colorScheme.error : colorScheme.primary,
      ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      onTap: onTap,
      dense: true,
    );
  }

  void _navigateAndPop(BuildContext context, String route) {
    Navigator.pop(context);
    GoRouter.of(context).go(route);
  }

  String _getInitials(String text) {
    if (text.isEmpty) return '';

    if (text.contains('@')) return text[0].toUpperCase();

    final words = text.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();

    return (words[0][0] + words[1][0]).toUpperCase();
  }
}
