import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

// Định nghĩa lớp User giả định

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
    _runSafe(_loadUserData);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userViewModel = context.read<UserViewModel?>();
    if (userViewModel == null) return;
    await userViewModel.loadCurrentUser();
    if (mounted && userViewModel.currentUser != null) {
      _displayNameController.text =
          userViewModel.currentUser!.displayName ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() != true) return;
    final userViewModel = context.read<UserViewModel?>();
    if (userViewModel == null) return;

    try {
      final success = await userViewModel.updateProfile(
        displayName: _displayNameController.text,
      );
      if (!mounted) return;
      if (success) {
        await _loadUserData();
        setState(() => _isEditing = false);
        _showSnackBar('Profile updated successfully', Colors.green);
      } else {
        _showSnackBar('Failed to update profile', Colors.red);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error updating profile: $e', Colors.red);
      }
    }
  }

  Future<void> _logout() async {
    final authViewModel = context.read<AuthViewModel?>();
    if (authViewModel == null) return;

    try {
      await authViewModel.logout();
      if (mounted && !authViewModel.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error logging out: $e', Colors.red);
      }
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _resetForm();
      }
    });
  }

  void _resetForm() {
    final userViewModel = context.read<UserViewModel?>();
    if (userViewModel?.currentUser != null) {
      _displayNameController.text =
          userViewModel!.currentUser!.displayName ?? '';
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(onRefresh: _loadUserData, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return Selector<AuthViewModel, User?>(
      selector: (_, authViewModel) => authViewModel.currentUser,
      builder: (_, user, __) {
        if (user == null) {
          return const Center(
            child: Text('Please log in to view your profile'),
          );
        }
        return Selector<UserViewModel, (bool, String?, User?)>(
          selector:
              (_, userViewModel) => (
                userViewModel.isLoading,
                userViewModel.errorMessage,
                userViewModel.currentUser,
              ),
          builder: (_, data, __) {
            final isLoading = data.$1;
            final errorMessage = data.$2;
            final currentUser = data.$3 ?? user;

            if (isLoading) {
              return const Center(child: AppLoadingIndicator());
            }

            return ListView(
              padding: const EdgeInsets.only(
                left: AppDimens.paddingL,
                right: AppDimens.paddingL,
                top: AppDimens.paddingL,
              ),
              children: [
                const SizedBox(height: AppDimens.spaceL),
                _buildAvatar(currentUser),
                const SizedBox(height: AppDimens.spaceL),
                if (errorMessage != null) _buildErrorDisplay(errorMessage),
                _isEditing
                    ? _buildEditProfileForm()
                    : _buildProfileInfo(currentUser),
                const SizedBox(height: AppDimens.spaceXXL),
                _buildSettingsSection(),
                const SizedBox(height: AppDimens.spaceXL),
                _buildLogoutButton(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(User user) {
    final theme = Theme.of(context);
    return Center(
      child: CircleAvatar(
        radius: AppDimens.avatarSizeL,
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          _getInitials(user.displayName ?? user.email),
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorDisplay(String errorMessage) {
    return ErrorDisplay(
      message: errorMessage,
      compact: true,
      onRetry: () {
        final userViewModel = context.read<UserViewModel?>();
        userViewModel?.clearError();
        _runSafe(_loadUserData);
      },
    );
  }

  Widget _buildProfileInfo(User currentUser) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(theme),
            const Divider(),
            const SizedBox(height: AppDimens.spaceM),
            _buildInfoRow(
              theme,
              'Display Name',
              currentUser.displayName ?? 'Not set',
              Icons.person,
            ),
            const SizedBox(height: AppDimens.spaceL),
            _buildInfoRow(theme, 'Email', currentUser.email, Icons.email),
            if (currentUser.roles != null && currentUser.roles!.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceL),
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

  Widget _buildProfileHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Profile Information', style: theme.textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _toggleEditing,
          tooltip: 'Edit Profile',
        ),
      ],
    );
  }

  Widget _buildEditProfileForm() {
    Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditHeader(),
              const Divider(),
              const SizedBox(height: AppDimens.spaceL),
              AppTextField(
                label: 'Display Name',
                hint: 'Enter your display name',
                controller: _displayNameController,
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Display name cannot be empty';
                  }
                  if (value.length > 50) {
                    return 'Display name must be less than 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimens.spaceXL),
              _buildEditActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Edit Profile', style: Theme.of(context).textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _toggleEditing,
          tooltip: 'Cancel',
        ),
      ],
    );
  }

  Widget _buildEditActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          text: 'Cancel',
          type: AppButtonType.text,
          onPressed: _toggleEditing,
        ),
        const SizedBox(width: AppDimens.spaceM),
        AppButton(
          text: 'Save Changes',
          type: AppButtonType.primary,
          onPressed: _updateProfile,
          isLoading: context.select<UserViewModel?, bool>(
            (vm) => vm?.isLoading ?? false,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Selector<ThemeViewModel, bool>(
              selector: (_, themeViewModel) => themeViewModel.isDarkMode,
              builder:
                  (_, isDarkMode, __) => Row(
                    children: [
                      Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppDimens.spaceL),
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: context.read<ThemeViewModel>().setDarkMode,
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return AppButton(
      text: 'Logout',
      type: AppButtonType.outline,
      prefixIcon: Icons.logout,
      onPressed: _logout,
      isFullWidth: true,
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimens.iconM, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimens.spaceL),
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

  String _getInitials(String text) {
    if (text.isEmpty) return '';
    final trimmed = text.trim();
    if (trimmed.contains('@')) return trimmed[0].toUpperCase();
    final words = trimmed.split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words.last[0]).toUpperCase();
  }

  void _runSafe(VoidCallback block) {
    if (!mounted) return;
    Future.microtask(block);
  }
}
