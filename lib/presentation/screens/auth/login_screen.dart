import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/presentation/screens/auth/register_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _usernameOrEmailError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateUsernameOrEmail() {
    setState(() {
      _usernameOrEmailError = _usernameOrEmailController.text.isEmpty
          ? 'Username or email is required'
          : null;
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError = _passwordController.text.isEmpty
          ? 'Password is required'
          : _passwordController.text.length < 8
          ? 'Password must be at least 8 characters'
          : null;
    });
  }

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
        // Sử dụng GoRouter thay vì Navigator
        GoRouter.of(context).go('/');
      }
    }
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Login to your account',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildErrorDisplay(AuthViewModel authViewModel, ThemeData theme) {
    return authViewModel.errorMessage != null
        ? Column(
            children: [
              ErrorDisplay(
                message: authViewModel.errorMessage!,
                compact: true,
                onRetry: authViewModel.clearError,
              ),
              const SizedBox(height: 16),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildFormFields(ThemeData theme) {
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
        ),
        const SizedBox(height: 16),
        AppPasswordField(
          label: 'Password',
          hint: 'Enter your password',
          controller: _passwordController,
          errorText: _passwordError,
          prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
          onChanged: (_) => _passwordError = null,
          onEditingComplete: _validatePassword,
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    AuthViewModel authViewModel,
    ThemeData theme,
  ) {
    return Column(
      children: [
        const SizedBox(height: 24),
        AppButton(
          text: 'Login',
          onPressed: _login,
          isLoading: authViewModel.isLoading,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text('Register'),
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
      backgroundColor: theme.colorScheme.surface,
      body: LoadingOverlay(
        isLoading: authViewModel.isLoading,
        color: theme.colorScheme.surfaceContainerHighest,
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
                    _buildErrorDisplay(authViewModel, theme),
                    _buildFormFields(theme),
                    _buildActions(context, authViewModel, theme),
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
