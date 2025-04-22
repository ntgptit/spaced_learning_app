import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/repositories/module_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ModuleViewModel extends BaseViewModel {
  final ModuleRepository moduleRepository;

  List<ModuleSummary> _modules = [];
  ModuleDetail? _selectedModule;

  ModuleViewModel({required this.moduleRepository});

  List<ModuleSummary> get modules => _modules;

  ModuleDetail? get selectedModule => _selectedModule;

  /// Load module details by ID
  Future<void> loadModuleDetails(String id) async {
    if (id.isEmpty) {
      setError('Module ID cannot be empty');
      return;
    }

    await safeCall(
      action: () async {
        _selectedModule = await moduleRepository.getModuleById(id);
        return _selectedModule;
      },
      errorPrefix: 'Failed to load module details',
    );
  }

  /// Load modules for a book with pagination
  Future<void> loadModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    if (bookId.isEmpty) {
      setError('Book ID cannot be empty');
      return;
    }

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
}
