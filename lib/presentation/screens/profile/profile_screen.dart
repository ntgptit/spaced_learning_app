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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    final vm = context.read<UserViewModel?>();
    if (vm == null) return;
    await vm.loadCurrentUser();
    if (mounted && vm.currentUser != null) {
      _displayNameController.text = vm.currentUser!.displayName ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final vm = context.read<UserViewModel?>();
    if (vm == null) return;

    final success = await vm.updateProfile(
      displayName: _displayNameController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      await _loadUserData();
      setState(() => _isEditing = false);
      _showSnackBar('Profile updated successfully', Colors.green);
    } else {
      _showSnackBar('Failed to update profile', Colors.red);
    }
  }

  Future<void> _logout() async {
    final vm = context.read<AuthViewModel?>();
    if (vm == null) return;
    await vm.logout();
    if (!mounted) return;
    if (!vm.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _resetForm();
    });
  }

  void _resetForm() {
    final vm = context.read<UserViewModel?>();
    if (vm?.currentUser != null) {
      _displayNameController.text = vm!.currentUser!.displayName ?? '';
    }
  }

  void _showSnackBar(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserData,
          child: _buildContent(theme),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Selector<AuthViewModel, User?>(
      selector: (_, vm) => vm.currentUser,
      builder: (_, user, __) {
        if (user == null) {
          return const Center(
            child: Text('Please log in to view your profile'),
          );
        }

        return Selector<UserViewModel, (bool, String?, User?)>(
          selector: (_, vm) => (vm.isLoading, vm.errorMessage, vm.currentUser),
          builder: (_, data, __) {
            final isLoading = data.$1;
            final errorMsg = data.$2;
            final currentUser = data.$3 ?? user;

            if (isLoading) {
              return const Center(child: AppLoadingIndicator());
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingL,
                vertical: AppDimens.spaceL,
              ),
              children: [
                // Avatar + Title
                Center(
                  child: CircleAvatar(
                    radius: AppDimens.avatarSizeL,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      _getInitials(currentUser),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceL),
                Center(
                  child: Text(
                    _isEditing ? 'Edit Profile' : 'Profile',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceL),

                if (errorMsg != null)
                  ErrorDisplay(
                    message: errorMsg,
                    compact: true,
                    onRetry: () {
                      context.read<UserViewModel>()..clearError();
                      _runSafe(_loadUserData);
                    },
                  ),

                _isEditing
                    ? _buildEditForm(theme)
                    : _buildInfoCard(theme, currentUser),

                const SizedBox(height: AppDimens.spaceXXL),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingL),
                    child: Selector<ThemeViewModel, bool>(
                      selector: (_, vm) => vm.isDarkMode,
                      builder: (_, isDark, __) => Row(
                        children: [
                          Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                          const SizedBox(width: AppDimens.spaceL),
                          Text('Dark Mode', style: theme.textTheme.bodyLarge),
                          const Spacer(),
                          Switch(
                            value: isDark,
                            onChanged: context
                                .read<ThemeViewModel>()
                                .setDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceXL),

                AppButton(
                  text: 'Logout',
                  type: AppButtonType.outline,
                  prefixIcon: Icons.logout,
                  isFullWidth: true,
                  onPressed: _logout,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInfoCard(ThemeData theme, User user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          children: [
            _infoRow(
              theme,
              Icons.person,
              'Display Name',
              user.displayName ?? 'Not set',
            ),
            const Divider(),
            _infoRow(theme, Icons.email, 'Email', user.email),
            if (user.roles?.isNotEmpty ?? false) ...[
              const Divider(),
              _infoRow(theme, Icons.badge, 'Roles', user.roles!.join(', ')),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _toggleEditing,
                tooltip: 'Edit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Display Name',
                hint: 'Enter display name',
                controller: _displayNameController,
                prefixIcon: Icons.person,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Cannot be empty';
                  if (v.length > 50) return 'Maximum 50 characters';
                  return null;
                },
              ),
              const SizedBox(height: AppDimens.spaceL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Cancel',
                    type: AppButtonType.text,
                    onPressed: _toggleEditing,
                  ),
                  const SizedBox(width: AppDimens.spaceM),
                  AppButton(
                    text: 'Save',
                    type: AppButtonType.primary,
                    onPressed: _updateProfile,
                    isLoading: context.select<UserViewModel, bool>(
                      (vm) => vm.isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceS),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppDimens.spaceM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(User u) {
    final name = u.displayName ?? u.email.split('@').first;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  void _runSafe(VoidCallback cb) {
    if (!mounted) return;
    Future.microtask(cb);
  }
}
