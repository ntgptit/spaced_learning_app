// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleStats {

 int get totalModules; Map<String, int> get cycleStats;
/// Create a copy of ModuleStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleStatsCopyWith<ModuleStats> get copyWith => _$ModuleStatsCopyWithImpl<ModuleStats>(this as ModuleStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleStats&&(identical(other.totalModules, totalModules) || other.totalModules == totalModules)&&const DeepCollectionEquality().equals(other.cycleStats, cycleStats));
}


@override
int get hashCode => Object.hash(runtimeType,totalModules,const DeepCollectionEquality().hash(cycleStats));

@override
String toString() {
  return 'ModuleStats(totalModules: $totalModules, cycleStats: $cycleStats)';
}


}

/// @nodoc
abstract mixin class $ModuleStatsCopyWith<$Res>  {
  factory $ModuleStatsCopyWith(ModuleStats value, $Res Function(ModuleStats) _then) = _$ModuleStatsCopyWithImpl;
@useResult
$Res call({
 int totalModules, Map<String, int> cycleStats
});




}
/// @nodoc
class _$ModuleStatsCopyWithImpl<$Res>
    implements $ModuleStatsCopyWith<$Res> {
  _$ModuleStatsCopyWithImpl(this._self, this._then);

  final ModuleStats _self;
  final $Res Function(ModuleStats) _then;

/// Create a copy of ModuleStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalModules = null,Object? cycleStats = null,}) {
  return _then(_self.copyWith(
totalModules: null == totalModules ? _self.totalModules : totalModules // ignore: cast_nullable_to_non_nullable
as int,cycleStats: null == cycleStats ? _self.cycleStats : cycleStats // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// @nodoc


class _ModuleStats implements ModuleStats {
  const _ModuleStats({required this.totalModules, required final  Map<String, int> cycleStats}): _cycleStats = cycleStats;
  

@override final  int totalModules;
 final  Map<String, int> _cycleStats;
@override Map<String, int> get cycleStats {
  if (_cycleStats is EqualUnmodifiableMapView) return _cycleStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cycleStats);
}


/// Create a copy of ModuleStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleStatsCopyWith<_ModuleStats> get copyWith => __$ModuleStatsCopyWithImpl<_ModuleStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleStats&&(identical(other.totalModules, totalModules) || other.totalModules == totalModules)&&const DeepCollectionEquality().equals(other._cycleStats, _cycleStats));
}


@override
int get hashCode => Object.hash(runtimeType,totalModules,const DeepCollectionEquality().hash(_cycleStats));

@override
String toString() {
  return 'ModuleStats(totalModules: $totalModules, cycleStats: $cycleStats)';
}


}

/// @nodoc
abstract mixin class _$ModuleStatsCopyWith<$Res> implements $ModuleStatsCopyWith<$Res> {
  factory _$ModuleStatsCopyWith(_ModuleStats value, $Res Function(_ModuleStats) _then) = __$ModuleStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalModules, Map<String, int> cycleStats
});




}
/// @nodoc
class __$ModuleStatsCopyWithImpl<$Res>
    implements _$ModuleStatsCopyWith<$Res> {
  __$ModuleStatsCopyWithImpl(this._self, this._then);

  final _ModuleStats _self;
  final $Res Function(_ModuleStats) _then;

/// Create a copy of ModuleStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalModules = null,Object? cycleStats = null,}) {
  return _then(_ModuleStats(
totalModules: null == totalModules ? _self.totalModules : totalModules // ignore: cast_nullable_to_non_nullable
as int,cycleStats: null == cycleStats ? _self._cycleStats : cycleStats // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
