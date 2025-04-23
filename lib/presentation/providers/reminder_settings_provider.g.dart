// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$devicePermissionsHash() => r'5f10e680eb152d3a59451078eaacb5953ec89303';

/// See also [devicePermissions].
@ProviderFor(devicePermissions)
final devicePermissionsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      devicePermissions,
      name: r'devicePermissionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$devicePermissionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DevicePermissionsRef =
    AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$reminderSettingsHash() => r'9a95f346b9e6c7f275e275ec27878d3351917d0b';

/// See also [ReminderSettings].
@ProviderFor(ReminderSettings)
final reminderSettingsProvider = AutoDisposeAsyncNotifierProvider<
  ReminderSettings,
  Map<String, bool>
>.internal(
  ReminderSettings.new,
  name: r'reminderSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reminderSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReminderSettings = AutoDisposeAsyncNotifier<Map<String, bool>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
