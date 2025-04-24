// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$modulesStateHash() => r'8281db5e27c2f009b6da77484cf8954c7d65af2a';

/// See also [ModulesState].
@ProviderFor(ModulesState)
final modulesStateProvider = AutoDisposeAsyncNotifierProvider<
  ModulesState,
  List<ModuleSummary>
>.internal(
  ModulesState.new,
  name: r'modulesStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$modulesStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ModulesState = AutoDisposeAsyncNotifier<List<ModuleSummary>>;
String _$selectedModuleHash() => r'2c35baa4387cb6ed35cf43396069146591891383';

/// See also [SelectedModule].
@ProviderFor(SelectedModule)
final selectedModuleProvider =
    AutoDisposeAsyncNotifierProvider<SelectedModule, ModuleDetail?>.internal(
      SelectedModule.new,
      name: r'selectedModuleProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedModuleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedModule = AutoDisposeAsyncNotifier<ModuleDetail?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
