import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/presentation/screens/auth/register_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

/// Login screen for user authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error states
  String? _usernameOrEmailError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validation methods
  void _validateUsernameOrEmail() {
    setState(() {
      _usernameOrEmailError =
          _usernameOrEmailController.text.isEmpty
              ? 'Username or email is required'
              : null;
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError =
          _passwordController.text.isEmpty
              ? 'Password is required'
              : _passwordController.text.length < 8
              ? 'Password must be at least 8 characters'
              : null;
    });
  }

  // Login handler
  Future<void> _login() async {
    _validateUsernameOrEmail();
    _validatePassword();

    if (_usernameOrEmailError == null && _passwordError == null) {
      final authViewModel = context.read<AuthViewModel>();
      final success = await authViewModel.login(
        _usernameOrEmailController.text,
        _passwordController.text,
      );

      if (success && mounted && authViewModel.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  // UI Components
  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.lightPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Login to your account',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildErrorDisplay(AuthViewModel authViewModel) {
    return authViewModel.errorMessage != null
        ? Column(
          children: [
            ErrorDisplay(
              message: authViewModel.errorMessage!,
              compact: true,
              onRetry: authViewModel.clearError,
              backgroundColor: AppColors.lightErrorContainer,
              textColor: AppColors.lightOnErrorContainer,
            ),
            const SizedBox(height: 16),
          ],
        )
        : const SizedBox.shrink();
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AppTextField(
          label: 'Username or Email',
          hint: 'Enter your username or email',
          controller: _usernameOrEmailController,
          keyboardType: TextInputType.text,
          errorText: _usernameOrEmailError,
          prefixIcon: Icons.person,
          onChanged: (_) => _usernameOrEmailError = null,
          onEditingComplete: _validateUsernameOrEmail,
          labelColor: AppColors.textPrimaryLight,
          hintColor: AppColors.textSecondaryLight,
          errorColor: AppColors.lightError,
          borderColor: AppColors.lightOutline,
        ),
        const SizedBox(height: 16),
        AppPasswordField(
          label: 'Password',
          hint: 'Enter your password',
          controller: _passwordController,
          errorText: _passwordError,
          prefixIcon: const Icon(Icons.lock, color: AppColors.iconPrimaryLight),
          onChanged: (_) => _passwordError = null,
          onEditingComplete: _validatePassword,
          labelColor: AppColors.textPrimaryLight,
          hintColor: AppColors.textSecondaryLight,
          errorColor: AppColors.lightError,
          borderColor: AppColors.lightOutline,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, AuthViewModel authViewModel) {
    return Column(
      children: [
        const SizedBox(height: 24),
        AppButton(
          text: 'Login',
          onPressed: _login,
          isLoading: authViewModel.isLoading,
          isFullWidth: true,
          backgroundColor: AppColors.lightPrimary,
          textColor: AppColors.lightOnPrimary,
          loadingColor: AppColors.lightOnPrimary,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            TextButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
              child: const Text(
                'Register',
                style: TextStyle(color: AppColors.accentPink),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: LoadingOverlay(
        isLoading: authViewModel.isLoading,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(theme),
                    _buildErrorDisplay(authViewModel),
                    _buildFormFields(),
                    _buildActions(context, authViewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
