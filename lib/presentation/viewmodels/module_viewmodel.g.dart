// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$modulesStateHash() => r'4debe1e6105fc3b090eaad57c259eb87e33b038b';

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
String _$selectedModuleHash() => r'30f992ec1d0ca873596acb7431fb0478cb43b526';

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
