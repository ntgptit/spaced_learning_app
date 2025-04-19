// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StreakStats {

 int get streakDays; int get streakWeeks;
/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakStatsCopyWith<StreakStats> get copyWith => _$StreakStatsCopyWithImpl<StreakStats>(this as StreakStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakStats&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.streakWeeks, streakWeeks) || other.streakWeeks == streakWeeks));
}


@override
int get hashCode => Object.hash(runtimeType,streakDays,streakWeeks);

@override
String toString() {
  return 'StreakStats(streakDays: $streakDays, streakWeeks: $streakWeeks)';
}


}

/// @nodoc
abstract mixin class $StreakStatsCopyWith<$Res>  {
  factory $StreakStatsCopyWith(StreakStats value, $Res Function(StreakStats) _then) = _$StreakStatsCopyWithImpl;
@useResult
$Res call({
 int streakDays, int streakWeeks
});




}
/// @nodoc
class _$StreakStatsCopyWithImpl<$Res>
    implements $StreakStatsCopyWith<$Res> {
  _$StreakStatsCopyWithImpl(this._self, this._then);

  final StreakStats _self;
  final $Res Function(StreakStats) _then;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streakDays = null,Object? streakWeeks = null,}) {
  return _then(_self.copyWith(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,streakWeeks: null == streakWeeks ? _self.streakWeeks : streakWeeks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _StreakStats implements StreakStats {
  const _StreakStats({required this.streakDays, required this.streakWeeks});
  

@override final  int streakDays;
@override final  int streakWeeks;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakStatsCopyWith<_StreakStats> get copyWith => __$StreakStatsCopyWithImpl<_StreakStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakStats&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.streakWeeks, streakWeeks) || other.streakWeeks == streakWeeks));
}


@override
int get hashCode => Object.hash(runtimeType,streakDays,streakWeeks);

@override
String toString() {
  return 'StreakStats(streakDays: $streakDays, streakWeeks: $streakWeeks)';
}


}

/// @nodoc
abstract mixin class _$StreakStatsCopyWith<$Res> implements $StreakStatsCopyWith<$Res> {
  factory _$StreakStatsCopyWith(_StreakStats value, $Res Function(_StreakStats) _then) = __$StreakStatsCopyWithImpl;
@override @useResult
$Res call({
 int streakDays, int streakWeeks
});




}
/// @nodoc
class __$StreakStatsCopyWithImpl<$Res>
    implements _$StreakStatsCopyWith<$Res> {
  __$StreakStatsCopyWithImpl(this._self, this._then);

  final _StreakStats _self;
  final $Res Function(_StreakStats) _then;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streakDays = null,Object? streakWeeks = null,}) {
  return _then(_StreakStats(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,streakWeeks: null == streakWeeks ? _self.streakWeeks : streakWeeks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
