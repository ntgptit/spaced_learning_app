import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error states
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validation methods
  void _validateEmail() {
    setState(() {
      _emailError =
          _emailController.text.isEmpty
              ? 'Email is required'
              : !RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(_emailController.text)
              ? 'Enter a valid email address'
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
    _validateEmail();
    _validatePassword();

    if (_emailError == null && _passwordError == null) {
      final authViewModel = context.read<AuthViewModel>();
      final success = await authViewModel.login(
        _emailController.text,
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
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Login to your account',
          style: theme.textTheme.titleMedium,
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
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          prefixIcon: Icons.email,
          onChanged: (_) => _emailError = null,
          onEditingComplete: _validateEmail,
        ),
        const SizedBox(height: 16),
        AppPasswordField(
          label: 'Password',
          hint: 'Enter your password',
          controller: _passwordController,
          errorText: _passwordError,
          prefixIcon: const Icon(Icons.lock),
          onChanged: (_) => _passwordError = null,
          onEditingComplete: _validatePassword,
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
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
