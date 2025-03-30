import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/presentation/screens/help/spaced_repetition_info_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';

/// App drawer that provides navigation to different screens
/// Contains additional options not available in the bottom navigation bar
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();
    final user = authViewModel.currentUser;

    return Drawer(
      child: Column(
        children: [
          // Header with user info or login prompt
          _buildHeader(context, user, theme),

          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Learning section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'LEARNING',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // My Learning Path - Shows all books enrolled
                _buildNavItem(
                  context,
                  icon: Icons.menu_book,
                  title: 'My Learning Path',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/my-learning-path');
                  },
                ),

                // Learning Statistics
                _buildNavItem(
                  context,
                  icon: Icons.bar_chart,
                  title: 'My Statistics',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/statistics');
                  },
                ),

                // Learning Calendar - Shows schedule
                _buildNavItem(
                  context,
                  icon: Icons.calendar_month,
                  title: 'Learning Calendar',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/calendar');
                  },
                ),

                const Divider(),

                // Discover section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'DISCOVER',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Book Categories
                _buildNavItem(
                  context,
                  icon: Icons.category,
                  title: 'Book Categories',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToCategories(context);
                  },
                ),

                // New Arrivals
                _buildNavItem(
                  context,
                  icon: Icons.new_releases,
                  title: 'New Arrivals',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToNewBooks(context);
                  },
                ),

                // Popular Books
                _buildNavItem(
                  context,
                  icon: Icons.trending_up,
                  title: 'Popular Books',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToPopularBooks(context);
                  },
                ),

                const Divider(),

                // Help section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'HELP & SETTINGS',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Spaced Learning Guide
                _buildNavItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'Spaced Learning Guide',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const SpacedRepetitionInfoScreen(),
                      ),
                    );
                  },
                ),

                // Notification Settings
                _buildNavItem(
                  context,
                  icon: Icons.notifications_active,
                  title: 'Notification Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notification-settings');
                  },
                ),

                // Support
                _buildNavItem(
                  context,
                  icon: Icons.support_agent,
                  title: 'Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/support');
                  },
                ),

                // Admin section if user has admin role
                if (user?.roles?.contains('ADMIN') == true) ...[
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'ADMIN',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.admin_panel_settings,
                    title: 'Manage Users',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/users');
                    },
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.library_books,
                    title: 'Manage Books',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/books');
                    },
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.analytics,
                    title: 'Analytics Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/analytics');
                    },
                  ),
                ],
              ],
            ),
          ),

          // Bottom section with theme toggle and logout
          _buildBottomSection(context, authViewModel, themeViewModel, theme),
        ],
      ),
    );
  }

  /// Build the drawer header with user info or login prompt
  Widget _buildHeader(BuildContext context, dynamic user, ThemeData theme) {
    return DrawerHeader(
      decoration: BoxDecoration(color: theme.colorScheme.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppConstants.appName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (user != null) ...[
            // User info with row layout for better space usage
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.onPrimary,
                  radius: 24,
                  child: Text(
                    _getInitials(user.displayName ?? user.email),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Learning User',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: (0.8 * 255),
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            // Login prompt
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.onPrimary,
                foregroundColor: theme.colorScheme.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ],
      ),
    );
  }

  /// Build a navigation item
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : null,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      dense: true,
      selected: isSelected,
      onTap: onTap,
    );
  }

  /// Navigate to categories screen
  void _navigateToCategories(BuildContext context) {
    // Get book viewmodel
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);

    // Load categories before navigating
    bookViewModel.loadCategories().then((_) {
      if (context.mounted) {
        Navigator.pushNamed(context, '/books/categories');
      }
    });
  }

  /// Navigate to new books screen
  void _navigateToNewBooks(BuildContext context) {
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);

    // Filter books by newest (using created date)
    bookViewModel.filterBooks().then((_) {
      if (context.mounted) {
        Navigator.pushNamed(context, '/books/new-arrivals');
      }
    });
  }

  /// Navigate to popular books screen
  void _navigateToPopularBooks(BuildContext context) {
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);

    // In a real app, this would filter by popularity metrics
    bookViewModel.filterBooks().then((_) {
      if (context.mounted) {
        Navigator.pushNamed(context, '/books/popular');
      }
    });
  }

  /// Build the bottom section with theme toggle and logout
  Widget _buildBottomSection(
    BuildContext context,
    AuthViewModel authViewModel,
    ThemeViewModel themeViewModel,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theme toggle
          SwitchListTile(
            title: Row(
              children: [
                Icon(
                  themeViewModel.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  themeViewModel.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            value: themeViewModel.isDarkMode,
            onChanged: (value) {
              themeViewModel.setDarkMode(value);
            },
            contentPadding: EdgeInsets.zero,
          ),

          // Logout button (only if logged in)
          if (authViewModel.isAuthenticated)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final confirmed = await _showLogoutConfirmation(context);
                if (confirmed && context.mounted) {
                  await authViewModel.logout();
                  if (context.mounted) {
                    Navigator.pop(context); // Close drawer
                    // Navigate to login if needed
                    if (!authViewModel.isAuthenticated) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }
                }
              },
              contentPadding: EdgeInsets.zero,
            ),

          // Version info at the bottom
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog before logout
  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;
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
