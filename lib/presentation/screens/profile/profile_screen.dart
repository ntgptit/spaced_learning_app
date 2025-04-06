import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
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

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final userViewModel = context.read<UserViewModel>();
      final success = await userViewModel.updateProfile(
        displayName: _displayNameController.text,
      );

      if (success && mounted) {
        await _loadUserData();
        setState(() => _isEditing = false);
        _showSuccessMessage();
      }
    }
  }

  Future<void> _logout() async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.logout();
    if (mounted && !authViewModel.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/login');
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
    final userViewModel = context.read<UserViewModel>();
    if (userViewModel.currentUser != null) {
      _displayNameController.text =
          userViewModel.currentUser!.displayName ?? '';
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final userViewModel = context.watch<UserViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your profile'));
    }

    if (userViewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: _buildContent(authViewModel, userViewModel),
      ),
    );
  }

  Widget _buildContent(
    AuthViewModel authViewModel,
    UserViewModel userViewModel,
  ) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      children: [
        const SizedBox(height: AppDimens.spaceL),
        _buildAvatar(theme, authViewModel.currentUser),
        const SizedBox(height: AppDimens.spaceL),
        if (userViewModel.errorMessage != null)
          _buildErrorDisplay(userViewModel),
        _isEditing
            ? _buildEditProfileForm()
            : _buildProfileInfo(
              theme,
              userViewModel.currentUser ?? authViewModel.currentUser!,
            ),
        const SizedBox(height: AppDimens.spaceXXL),
        _buildSettingsSection(theme),
        const SizedBox(height: AppDimens.spaceXL),
        _buildLogoutButton(),
        const SizedBox(height: AppDimens.spaceXL),
      ],
    );
  }

  Widget _buildAvatar(ThemeData theme, dynamic user) {
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

  Widget _buildErrorDisplay(UserViewModel userViewModel) {
    return ErrorDisplay(
      message: userViewModel.errorMessage!,
      compact: true,
      onRetry: () {
        userViewModel.clearError();
        _loadUserData();
      },
    );
  }

  Widget _buildProfileInfo(ThemeData theme, dynamic currentUser) {
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
          isLoading: context.watch<UserViewModel>().isLoading,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(ThemeData theme) {
    final themeViewModel = context.watch<ThemeViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Row(
              children: [
                Icon(
                  themeViewModel.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimens.spaceL),
                Expanded(
                  child: Text('Dark Mode', style: theme.textTheme.titleMedium),
                ),
                Switch(
                  value: themeViewModel.isDarkMode,
                  onChanged: themeViewModel.setDarkMode,
                ),
              ],
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
    if (text.contains('@')) return text[0].toUpperCase();
    final words = text.trim().split(' ');
    return words.length == 1
        ? words[0][0].toUpperCase()
        : (words[0][0] + words[1][0]).toUpperCase();
  }
}
