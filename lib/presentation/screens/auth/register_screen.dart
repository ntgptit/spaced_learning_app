import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_text_field.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

/// Registration screen for new users
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error states
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _firstNameError;
  String? _lastNameError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Validation methods
  void _validateUsername() {
    setState(() {
      _usernameError =
          _usernameController.text.isEmpty
              ? 'Username is required'
              : _usernameController.text.length < 3
              ? 'Username must be at least 3 characters'
              : !RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(_usernameController.text)
              ? 'Username can only contain letters, numbers, dots, underscores and hyphens'
              : null;
    });
  }

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

  void _validateConfirmPassword() {
    setState(() {
      _confirmPasswordError =
          _confirmPasswordController.text.isEmpty
              ? 'Please confirm your password'
              : _confirmPasswordController.text != _passwordController.text
              ? 'Passwords do not match'
              : null;
    });
  }

  void _validateFirstName() {
    setState(() {
      _firstNameError =
          _firstNameController.text.isEmpty ? 'First name is required' : null;
    });
  }

  void _validateLastName() {
    setState(() {
      _lastNameError =
          _lastNameController.text.isEmpty ? 'Last name is required' : null;
    });
  }

  // Register handler
  Future<void> _register() async {
    _validateUsername();
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();
    _validateFirstName();
    _validateLastName();

    if (_usernameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _firstNameError == null &&
        _lastNameError == null) {
      final authViewModel = context.read<AuthViewModel>();
      final success = await authViewModel.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        _firstNameController.text,
        _lastNameController.text,
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
          'Create your account',
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

  Widget _buildNameFields() {
    return Column(
      children: [
        AppTextField(
          label: 'First Name',
          hint: 'Enter your first name',
          controller: _firstNameController,
          keyboardType: TextInputType.name,
          errorText: _firstNameError,
          prefixIcon: Icons.person,
          onChanged: (_) => _firstNameError = null,
          onEditingComplete: _validateFirstName,
          labelColor: AppColors.textPrimaryLight,
          hintColor: AppColors.textSecondaryLight,
          errorColor: AppColors.lightError,
          borderColor: AppColors.lightOutline,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Last Name',
          hint: 'Enter your last name',
          controller: _lastNameController,
          keyboardType: TextInputType.name,
          errorText: _lastNameError,
          prefixIcon: Icons.person,
          onChanged: (_) => _lastNameError = null,
          onEditingComplete: _validateLastName,
          labelColor: AppColors.textPrimaryLight,
          hintColor: AppColors.textSecondaryLight,
          errorColor: AppColors.lightError,
          borderColor: AppColors.lightOutline,
        ),
      ],
    );
  }

  Widget _buildAuthFields() {
    return Column(
      children: [
        AppTextField(
          label: 'Username',
          hint: 'Enter your username',
          controller: _usernameController,
          keyboardType: TextInputType.text,
          errorText: _usernameError,
          prefixIcon: Icons.account_circle,
          onChanged: (_) => _usernameError = null,
          onEditingComplete: _validateUsername,
          labelColor: AppColors.textPrimaryLight,
          hintColor: AppColors.textSecondaryLight,
          errorColor: AppColors.lightError,
          borderColor: AppColors.lightOutline,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          prefixIcon: Icons.email,
          onChanged: (_) => _emailError = null,
          onEditingComplete: _validateEmail,
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
          textInputAction: TextInputAction.next,
          errorText: _passwordError,
          prefixIcon: const Icon(Icons.lock, color: AppColors.iconPrimaryLight),
          onChanged: (_) {
            _passwordError = null;
            if (_confirmPasswordController.text.isNotEmpty) {
              _validateConfirmPassword();
            }
          },
          onEditingComplete: _validatePassword,
          labelColor: AppColors.textPrimaryLight,
          hintColor: AppColors.textSecondaryLight,
          errorColor: AppColors.lightError,
          borderColor: AppColors.lightOutline,
        ),
        const SizedBox(height: 16),
        AppPasswordField(
          label: 'Confirm Password',
          hint: 'Confirm your password',
          controller: _confirmPasswordController,
          errorText: _confirmPasswordError,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppColors.iconPrimaryLight,
          ),
          onChanged: (_) => _confirmPasswordError = null,
          onEditingComplete: _validateConfirmPassword,
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
          text: 'Register',
          onPressed: _register,
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
              'Already have an account? ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Login',
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
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: AppColors.lightBackground,
      ),
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
                    _buildNameFields(),
                    const SizedBox(height: 16),
                    _buildAuthFields(),
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
