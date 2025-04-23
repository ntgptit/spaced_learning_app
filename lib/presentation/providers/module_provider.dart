// lib/presentation/providers/module_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/module.dart';

import '../../core/di/providers.dart';

part 'module_provider.g.dart';

@riverpod
class Modules extends _$Modules {
  @override
  Future<List<ModuleSummary>> build({int page = 0, int size = 20}) async {
    return _fetchModules(page, size);
  }

  Future<List<ModuleSummary>> _fetchModules(int page, int size) async {
    final repository = ref.read(moduleRepositoryProvider);
    return repository.getAllModules(page: page, size: size);
  }

  Future<void> refreshModules({int page = 0, int size = 20}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchModules(page, size));
  }

  Future<List<ModuleSummary>> getModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    final repository = ref.read(moduleRepositoryProvider);
    return repository.getModulesByBookId(bookId, page: page, size: size);
  }
}

@riverpod
Future<List<ModuleSummary>> bookModules(
  Ref ref,
  String bookId, {
  int page = 0,
  int size = 20,
}) async {
  final repository = ref.watch(moduleRepositoryProvider);
  return repository.getModulesByBookId(bookId, page: page, size: size);
}

@riverpod
Future<ModuleDetail> moduleDetail(Ref ref, String id) async {
  final repository = ref.watch(moduleRepositoryProvider);
  return repository.getModuleById(id);
}
