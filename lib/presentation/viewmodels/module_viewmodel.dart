import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/repositories/module_repository.dart';

/// View model for module operations
class ModuleViewModel extends ChangeNotifier {
  final ModuleRepository moduleRepository;

  bool _isLoading = false;
  List<ModuleSummary> _modules = [];
  ModuleDetail? _selectedModule;
  String? _errorMessage;

  ModuleViewModel({required this.moduleRepository});

  // Getters
  bool get isLoading => _isLoading;
  List<ModuleSummary> get modules => _modules;
  ModuleDetail? get selectedModule => _selectedModule;
  String? get errorMessage => _errorMessage;

  /// Load all modules with pagination
  Future<void> loadModules({int page = 0, int size = 20}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _modules = await moduleRepository.getAllModules(page: page, size: size);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load module details by ID
  Future<void> loadModuleDetails(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedModule = await moduleRepository.getModuleById(id);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load modules by book ID
  Future<void> loadModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _modules = await moduleRepository.getModulesByBookId(
        bookId,
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load all modules by book ID (without pagination)
  Future<List<ModuleSummary>> getAllModulesByBookId(String bookId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final modules = await moduleRepository.getAllModulesByBookId(bookId);
      return modules;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return [];
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return [];
    } finally {
      _setLoading(false);
    }
  }

  /// Get next available module number for a book
  Future<int> getNextModuleNumber(String bookId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      return await moduleRepository.getNextModuleNumber(bookId);
    } on AppException catch (e) {
      _errorMessage = e.message;
      return 1; // Default to 1 if error
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return 1; // Default to 1 if error
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new module (admin only)
  Future<ModuleDetail?> createModule({
    required String bookId,
    required int moduleNo,
    required String title,
    int? wordCount,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final module = await moduleRepository.createModule(
        bookId: bookId,
        moduleNo: moduleNo,
        title: title,
        wordCount: wordCount,
      );
      return module;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update a module (admin only)
  Future<ModuleDetail?> updateModule(
    String id, {
    int? moduleNo,
    String? title,
    int? wordCount,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final module = await moduleRepository.updateModule(
        id,
        moduleNo: moduleNo,
        title: title,
        wordCount: wordCount,
      );

      if (_selectedModule?.id == id) {
        _selectedModule = module;
      }

      return module;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a module (admin only)
  Future<bool> deleteModule(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await moduleRepository.deleteModule(id);

      if (_selectedModule?.id == id) {
        _selectedModule = null;
      }

      _modules = _modules.where((module) => module.id != id).toList();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
