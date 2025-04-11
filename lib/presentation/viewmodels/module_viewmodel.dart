// lib/presentation/viewmodels/module_viewmodel.dart
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/repositories/module_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

/// View model for module operations
class ModuleViewModel extends BaseViewModel {
  final ModuleRepository moduleRepository;

  List<ModuleSummary> _modules = [];
  ModuleDetail? _selectedModule;

  ModuleViewModel({required this.moduleRepository});

  // Getters
  List<ModuleSummary> get modules => _modules;
  ModuleDetail? get selectedModule => _selectedModule;

  /// Load all modules with pagination
  // Future<void> loadModules({int page = 0, int size = 20}) async {
  //   await safeCall(
  //     action: () async {
  //       _modules = await moduleRepository.getAllModules(page: page, size: size);
  //       return _modules;
  //     },
  //     errorPrefix: 'Failed to load modules',
  //   );
  // }

  /// Load module details by ID
  Future<void> loadModuleDetails(String id) async {
    await safeCall(
      action: () async {
        _selectedModule = await moduleRepository.getModuleById(id);
        return _selectedModule;
      },
      errorPrefix: 'Failed to load module details',
    );
  }

  /// Load modules by book ID
  Future<void> loadModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    await safeCall(
      action: () async {
        _modules = await moduleRepository.getModulesByBookId(
          bookId,
          page: page,
          size: size,
        );
        return _modules;
      },
      errorPrefix: 'Failed to load modules by book',
    );
  }

  /// Load all modules by book ID (without pagination)
  // Future<List<ModuleSummary>> getAllModulesByBookId(String bookId) async {
  //   final result = await safeCall<List<ModuleSummary>>(
  //     action: () => moduleRepository.getAllModulesByBookId(bookId),
  //     errorPrefix: 'Failed to get all modules by book',
  //   );
  //   return result ?? [];
  // }

  // /// Get next available module number for a book
  // Future<int> getNextModuleNumber(String bookId) async {
  //   final result = await safeCall<int>(
  //     action: () => moduleRepository.getNextModuleNumber(bookId),
  //     errorPrefix: 'Failed to get next module number',
  //   );
  //   return result ?? 1; // Default to 1 if error
  // }

  /// Create a new module (admin only)
  // Future<ModuleDetail?> createModule({
  //   required String bookId,
  //   required int moduleNo,
  //   required String title,
  //   int? wordCount,
  // }) async {
  //   return safeCall<ModuleDetail>(
  //     action:
  //         () => moduleRepository.createModule(
  //           bookId: bookId,
  //           moduleNo: moduleNo,
  //           title: title,
  //           wordCount: wordCount,
  //         ),
  //     errorPrefix: 'Failed to create module',
  //   );
  // }

  /// Update a module (admin only)
  // Future<ModuleDetail?> updateModule(
  //   String id, {
  //   int? moduleNo,
  //   String? title,
  //   int? wordCount,
  // }) async {
  //   return safeCall<ModuleDetail>(
  //     action: () async {
  //       final module = await moduleRepository.updateModule(
  //         id,
  //         moduleNo: moduleNo,
  //         title: title,
  //         wordCount: wordCount,
  //       );

  //       if (_selectedModule?.id == id) {
  //         _selectedModule = module;
  //       }

  //       return module;
  //     },
  //     errorPrefix: 'Failed to update module',
  //   );
  // }

  /// Delete a module (admin only)
  // Future<bool> deleteModule(String id) async {
  //   final result = await safeCall<bool>(
  //     action: () async {
  //       await moduleRepository.deleteModule(id);

  //       if (_selectedModule?.id == id) {
  //         _selectedModule = null;
  //       }

  //       _modules = _modules.where((module) => module.id != id).toList();
  //       return true;
  //     },
  //     errorPrefix: 'Failed to delete module',
  //   );
  //   return result ?? false;
  // }
}
