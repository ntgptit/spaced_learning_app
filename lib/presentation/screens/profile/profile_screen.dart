import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

/// Profile screen displaying user information and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userViewModel = context.read<UserViewModel>();
    await userViewModel.loadCurrentUser();

    if (userViewModel.currentUser != null) {
      _displayNameController.text =
          userViewModel.currentUser!.displayName ?? '';
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset form when canceling edit
        final userViewModel = context.read<UserViewModel>();
        if (userViewModel.currentUser != null) {
          _displayNameController.text =
              userViewModel.currentUser!.displayName ?? '';
        }
      }
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final userViewModel = context.read<UserViewModel>();

      final success = await userViewModel.updateProfile(
        displayName: _displayNameController.text,
      );

      if (success && mounted) {
        // Reload user data after update
        await _loadUserData();

        // Exit editing mode
        setState(() {
          _isEditing = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.logout();

    if (mounted && !authViewModel.isAuthenticated) {
      // Navigate to login screen
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final userViewModel = context.watch<UserViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your profile'));
    }

    if (userViewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Profile header
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  _getInitials(
                    authViewModel.currentUser!.displayName ??
                        authViewModel.currentUser!.email,
                  ),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Display error if any
            if (userViewModel.errorMessage != null)
              ErrorDisplay(
                message: userViewModel.errorMessage!,
                compact: true,
                onRetry: () {
                  userViewModel.clearError();
                  _loadUserData();
                },
              ),

            // Profile info
            _isEditing
                ? _buildEditProfileForm()
                : _buildProfileInfo(
                  theme,
                  userViewModel.currentUser ?? authViewModel.currentUser!,
                ),

            const SizedBox(height: 32),

            // Settings section
            Text('Settings', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            // Dark mode toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      themeViewModel.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Dark Mode',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Switch(
                      value: themeViewModel.isDarkMode,
                      onChanged: (value) {
                        themeViewModel.setDarkMode(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Other settings cards can be added here
            const SizedBox(height: 24),

            // Logout button
            AppButton(
              text: 'Logout',
              type: AppButtonType.outline,
              prefixIcon: Icons.logout,
              onPressed: _logout,
              isFullWidth: true,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build the user's profile information display
  Widget _buildProfileInfo(ThemeData theme, dynamic currentUser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile Information', style: theme.textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _toggleEditing,
                  tooltip: 'Edit Profile',
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Display Name
            _buildInfoRow(
              theme,
              'Display Name',
              currentUser.displayName ?? 'Not set',
              Icons.person,
            ),
            const SizedBox(height: 16),

            // Email
            _buildInfoRow(theme, 'Email', currentUser.email, Icons.email),

            // Roles (if available)
            if (currentUser.roles != null && currentUser.roles!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                theme,
                'Roles',
                currentUser.roles!.join(', '),
                Icons.badge,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build a single info row
  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the form for editing profile
  Widget _buildEditProfileForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _toggleEditing,
                    tooltip: 'Cancel',
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Display Name
              AppTextField(
                label: 'Display Name',
                hint: 'Enter your display name',
                controller: _displayNameController,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 24),

              // Update button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Cancel',
                    type: AppButtonType.text,
                    onPressed: _toggleEditing,
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    text: 'Save Changes',
                    type: AppButtonType.primary,
                    onPressed: _updateProfile,
                    isLoading: context.watch<UserViewModel>().isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
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
