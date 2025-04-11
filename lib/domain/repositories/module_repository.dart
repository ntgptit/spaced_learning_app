import 'package:spaced_learning_app/domain/models/module.dart';

/// Repository interface for module operations
abstract class ModuleRepository {
  /// Get all modules with pagination
  Future<List<ModuleSummary>> getAllModules({int page = 0, int size = 20});

  /// Get module by ID
  Future<ModuleDetail> getModuleById(String id);

  /// Get modules by book ID with pagination
  Future<List<ModuleSummary>> getModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  });

  /// Get all modules by book ID (without pagination)
  // Future<List<ModuleSummary>> getAllModulesByBookId(String bookId);

  /// Get next available module number for a book
  // Future<int> getNextModuleNumber(String bookId);

  /// Create a new module (admin only)
  // Future<ModuleDetail> createModule({
  //   required String bookId,
  //   required int moduleNo,
  //   required String title,
  //   int? wordCount,
  // });

  /// Update a module (admin only)
  // Future<ModuleDetail> updateModule(
  //   String id, {
  //   int? moduleNo,
  //   String? title,
  //   int? wordCount,
  // });

  /// Delete a module by ID (admin only)
  // Future<void> deleteModule(String id);
}
