// lib/presentation/viewmodels/auth_viewmodel.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/auth_response.dart';
import 'package:spaced_learning_app/domain/models/user.dart';

import '../../core/di/providers.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<bool> build() async {
    return _checkAuthentication();
  }

  Future<bool> _checkAuthentication() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      final isValid = await ref
          .read(authRepositoryProvider)
          .validateToken(token);

      if (isValid) {
        final userData = await ref.read(storageServiceProvider).getUserData();
        if (userData != null) {
          ref
              .read(currentUserProvider.notifier)
              .updateUser(User.fromJson(userData));
        }
        return true;
      }

      await ref.read(storageServiceProvider).clearTokens();
      return false;
    } catch (e) {
      await ref.read(storageServiceProvider).clearTokens();
      return false;
    }
  }

  Future<bool> login(String usernameOrEmail, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .login(usernameOrEmail, password);
      await _handleAuthResponse(response);
      state = const AsyncValue.data(true);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> register(
    String username,
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .register(username, email, password, firstName, lastName);
      await _handleAuthResponse(response);
      state = const AsyncValue.data(true);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(storageServiceProvider).clearTokens();
      await ref.read(storageServiceProvider).clearUserData();
      ref.read(currentUserProvider.notifier).updateUser(null);
      state = const AsyncValue.data(false);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _handleAuthResponse(AuthResponse response) async {
    await ref.read(storageServiceProvider).saveToken(response.token);
    if (response.refreshToken != null) {
      await ref
          .read(storageServiceProvider)
          .saveRefreshToken(response.refreshToken!);
    }
    await ref.read(storageServiceProvider).saveUserData(response.user.toJson());
    ref.read(currentUserProvider.notifier).updateUser(response.user);
  }
}

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  User? build() {
    return null;
  }

  void updateUser(User? user) {
    state = user;
  }
}

@riverpod
class AuthError extends _$AuthError {
  @override
  String? build() {
    final authState = ref.watch(authStateProvider);
    return authState.hasError ? authState.error.toString() : null;
  }

  void clearError() {
    state = null;
  }
}
