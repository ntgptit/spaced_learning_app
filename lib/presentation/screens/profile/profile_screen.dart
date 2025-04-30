import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

import '../../../core/navigation/navigation_helper.dart';
import '../../../core/theme/app_theme_data.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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
    await ref.read(userStateProvider.notifier).loadCurrentUser();
    if (mounted) {
      final currentUser = ref.read(userStateProvider).valueOrNull;
      if (currentUser != null) {
        _displayNameController.text = currentUser.displayName ?? '';
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(userStateProvider.notifier)
        .updateProfile(displayName: _displayNameController.text.trim());

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
    await ref.read(authStateProvider.notifier).logout();

    if (!mounted) return;

    if (!(ref.read(authStateProvider).valueOrNull ?? false)) {
      NavigationHelper.clearStackAndGo(context, '/login');
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _resetForm();
    });
  }

  void _resetForm() {
    final currentUser = ref.read(userStateProvider).valueOrNull;
    if (currentUser != null) {
      _displayNameController.text = currentUser.displayName ?? '';
    }
  }

  void _showSnackBar(String msg, Color color) {
    if (!mounted) return;
    SnackBarUtils.show(context, msg, backgroundColor: color);
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
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull == true
        ? ref.watch(currentUserProvider)
        : null;

    if (user == null) {
      return const Center(child: Text('Please log in to view your profile'));
    }

    final userStateAsync = ref.watch(userStateProvider);

    return userStateAsync.when(
      data: (currentUser) {
        final effectiveUser = currentUser ?? user;

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
                  _getInitials(effectiveUser),
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

            _isEditing
                ? _buildEditForm(theme)
                : _buildInfoCard(theme, effectiveUser),

            const SizedBox(height: AppDimens.spaceXXL),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: Consumer(
                  builder: (context, ref, _) {
                    // Sử dụng themeMode từ themeModeStateProvider
                    final themeMode = ref.watch(themeModeStateProvider);
                    final isDarkMode = themeMode == ThemeMode.dark;

                    return Row(
                      children: [
                        Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                        const SizedBox(width: AppDimens.spaceL),
                        Text('Dark Mode', style: theme.textTheme.bodyLarge),
                        const Spacer(),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) => ref
                              .read(themeModeStateProvider.notifier)
                              .toggleTheme(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceXL),

            SLButton(
              text: 'Logout',
              type: SLButtonType.outline,
              prefixIcon: Icons.logout,
              isFullWidth: true,
              onPressed: _logout,
            ),
          ],
        );
      },
      loading: () => const Center(child: SLLoadingIndicator()),
      error: (error, stack) => SLErrorView(
        message: error.toString(),
        onRetry: () {
          ref.read(userStateProvider.notifier).clearError();
          _runSafe(_loadUserData);
        },
        compact: true,
      ),
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
              SLTextField(
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
                  SLButton(
                    text: 'Cancel',
                    type: SLButtonType.text,
                    onPressed: _toggleEditing,
                  ),
                  const SizedBox(width: AppDimens.spaceM),
                  Consumer(
                    builder: (context, ref, _) {
                      final isLoading = ref.watch(userStateProvider).isLoading;
                      return SLButton(
                        text: 'Save',
                        type: SLButtonType.primary,
                        onPressed: _updateProfile,
                        isLoading: isLoading,
                      );
                    },
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
