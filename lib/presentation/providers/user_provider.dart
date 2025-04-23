// lib/presentation/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/user.dart';

import '../../core/di/providers.dart';

part 'user_provider.g.dart';

@riverpod
class UserState extends _$UserState {
  @override
  Future<User> build() async {
    return _fetchCurrentUser();
  }

  Future<User> _fetchCurrentUser() async {
    final repository = ref.read(userRepositoryProvider);
    return repository.getCurrentUser();
  }

  Future<void> refreshUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCurrentUser());
  }

  Future<User> updateUser(
    String id, {
    String? displayName,
    String? password,
  }) async {
    final repository = ref.read(userRepositoryProvider);
    final updatedUser = await repository.updateUser(
      id,
      displayName: displayName,
      password: password,
    );

    // Update state with the updated user
    state = AsyncValue.data(updatedUser);
    return updatedUser;
  }

  Future<bool> checkEmailExists(String email) async {
    final repository = ref.read(userRepositoryProvider);
    return repository.checkEmailExists(email);
  }
}

@riverpod
Future<User> currentUser(Ref ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getCurrentUser();
}
