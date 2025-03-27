import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _firstNameError;
  String? _lastNameError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(_emailController.text)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
      } else if (_passwordController.text.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _validateFirstName() {
    setState(() {
      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'First name is required';
      } else {
        _firstNameError = null;
      }
    });
  }

  void _validateLastName() {
    setState(() {
      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Last name is required';
      } else {
        _lastNameError = null;
      }
    });
  }

  Future<void> _register() async {
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();
    _validateFirstName();
    _validateLastName();

    if (_emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _firstNameError == null &&
        _lastNameError == null) {
      final authViewModel = context.read<AuthViewModel>();
      final success = await authViewModel.register(
        _emailController.text,
        _passwordController.text,
        _firstNameController.text,
        _lastNameController.text,
      );

      if (success && mounted && authViewModel.isAuthenticated) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
                      'Create your account',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Error message if any
                    if (authViewModel.errorMessage != null) ...[
                      ErrorDisplay(
                        message: authViewModel.errorMessage!,
                        compact: true,
                        onRetry: authViewModel.clearError,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // First name field
                    AppTextField(
                      label: 'First Name',
                      hint: 'Enter your first name',
                      controller: _firstNameController,
                      keyboardType: TextInputType.name,
                      errorText: _firstNameError,
                      prefixIcon: const Icon(Icons.person),
                      onChanged: (_) => _firstNameError = null,
                      onEditingComplete: _validateFirstName,
                    ),
                    const SizedBox(height: 16),

                    // Last name field
                    AppTextField(
                      label: 'Last Name',
                      hint: 'Enter your last name',
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      errorText: _lastNameError,
                      prefixIcon: const Icon(Icons.person),
                      onChanged: (_) => _lastNameError = null,
                      onEditingComplete: _validateLastName,
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      prefixIcon: const Icon(Icons.email),
                      onChanged: (_) => _emailError = null,
                      onEditingComplete: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    AppPasswordField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      errorText: _passwordError,
                      prefixIcon: const Icon(Icons.lock),
                      onChanged: (_) {
                        _passwordError = null;
                        // If confirm password is not empty, validate it again
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _validateConfirmPassword();
                        }
                      },
                      onEditingComplete: _validatePassword,
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    AppPasswordField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      controller: _confirmPasswordController,
                      errorText: _confirmPasswordError,
                      prefixIcon: const Icon(Icons.lock_outline),
                      onChanged: (_) => _confirmPasswordError = null,
                      onEditingComplete: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    AppButton(
                      text: 'Register',
                      onPressed: _register,
                      isLoading: authViewModel.isLoading,
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 16),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
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
