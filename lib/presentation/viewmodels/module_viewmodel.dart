// lib/presentation/viewmodels/module_viewmodel.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/module.dart';

import '../../core/di/providers.dart';

part 'module_viewmodel.g.dart';

@riverpod
class ModulesState extends _$ModulesState {
  @override
  Future<List<ModuleSummary>> build() async {
    return [];
  }

  Future<void> loadModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    if (bookId.isEmpty) {
      state = AsyncValue.error('Book ID cannot be empty', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final modules = await ref
          .read(moduleRepositoryProvider)
          .getModulesByBookId(bookId, page: page, size: size);
      state = AsyncValue.data(modules);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

@riverpod
class SelectedModule extends _$SelectedModule {
  @override
  Future<ModuleDetail?> build() async {
    return null;
  }

  Future<void> loadModuleDetails(String id) async {
    if (id.isEmpty) {
      state = AsyncValue.error('Module ID cannot be empty', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final module = await ref.read(moduleRepositoryProvider).getModuleById(id);
      state = AsyncValue.data(module);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
