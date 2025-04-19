// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'due_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DueStats {

 int get dueToday; int get dueThisWeek; int get dueThisMonth; int get wordsDueToday; int get wordsDueThisWeek; int get wordsDueThisMonth;
/// Create a copy of DueStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DueStatsCopyWith<DueStats> get copyWith => _$DueStatsCopyWithImpl<DueStats>(this as DueStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DueStats&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.dueThisWeek, dueThisWeek) || other.dueThisWeek == dueThisWeek)&&(identical(other.dueThisMonth, dueThisMonth) || other.dueThisMonth == dueThisMonth)&&(identical(other.wordsDueToday, wordsDueToday) || other.wordsDueToday == wordsDueToday)&&(identical(other.wordsDueThisWeek, wordsDueThisWeek) || other.wordsDueThisWeek == wordsDueThisWeek)&&(identical(other.wordsDueThisMonth, wordsDueThisMonth) || other.wordsDueThisMonth == wordsDueThisMonth));
}


@override
int get hashCode => Object.hash(runtimeType,dueToday,dueThisWeek,dueThisMonth,wordsDueToday,wordsDueThisWeek,wordsDueThisMonth);

@override
String toString() {
  return 'DueStats(dueToday: $dueToday, dueThisWeek: $dueThisWeek, dueThisMonth: $dueThisMonth, wordsDueToday: $wordsDueToday, wordsDueThisWeek: $wordsDueThisWeek, wordsDueThisMonth: $wordsDueThisMonth)';
}


}

/// @nodoc
abstract mixin class $DueStatsCopyWith<$Res>  {
  factory $DueStatsCopyWith(DueStats value, $Res Function(DueStats) _then) = _$DueStatsCopyWithImpl;
@useResult
$Res call({
 int dueToday, int dueThisWeek, int dueThisMonth, int wordsDueToday, int wordsDueThisWeek, int wordsDueThisMonth
});




}
/// @nodoc
class _$DueStatsCopyWithImpl<$Res>
    implements $DueStatsCopyWith<$Res> {
  _$DueStatsCopyWithImpl(this._self, this._then);

  final DueStats _self;
  final $Res Function(DueStats) _then;

/// Create a copy of DueStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dueToday = null,Object? dueThisWeek = null,Object? dueThisMonth = null,Object? wordsDueToday = null,Object? wordsDueThisWeek = null,Object? wordsDueThisMonth = null,}) {
  return _then(_self.copyWith(
dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,dueThisWeek: null == dueThisWeek ? _self.dueThisWeek : dueThisWeek // ignore: cast_nullable_to_non_nullable
as int,dueThisMonth: null == dueThisMonth ? _self.dueThisMonth : dueThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsDueToday: null == wordsDueToday ? _self.wordsDueToday : wordsDueToday // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisWeek: null == wordsDueThisWeek ? _self.wordsDueThisWeek : wordsDueThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisMonth: null == wordsDueThisMonth ? _self.wordsDueThisMonth : wordsDueThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _DueStats implements DueStats {
  const _DueStats({required this.dueToday, required this.dueThisWeek, required this.dueThisMonth, required this.wordsDueToday, required this.wordsDueThisWeek, required this.wordsDueThisMonth});
  

@override final  int dueToday;
@override final  int dueThisWeek;
@override final  int dueThisMonth;
@override final  int wordsDueToday;
@override final  int wordsDueThisWeek;
@override final  int wordsDueThisMonth;

/// Create a copy of DueStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DueStatsCopyWith<_DueStats> get copyWith => __$DueStatsCopyWithImpl<_DueStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DueStats&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.dueThisWeek, dueThisWeek) || other.dueThisWeek == dueThisWeek)&&(identical(other.dueThisMonth, dueThisMonth) || other.dueThisMonth == dueThisMonth)&&(identical(other.wordsDueToday, wordsDueToday) || other.wordsDueToday == wordsDueToday)&&(identical(other.wordsDueThisWeek, wordsDueThisWeek) || other.wordsDueThisWeek == wordsDueThisWeek)&&(identical(other.wordsDueThisMonth, wordsDueThisMonth) || other.wordsDueThisMonth == wordsDueThisMonth));
}


@override
int get hashCode => Object.hash(runtimeType,dueToday,dueThisWeek,dueThisMonth,wordsDueToday,wordsDueThisWeek,wordsDueThisMonth);

@override
String toString() {
  return 'DueStats(dueToday: $dueToday, dueThisWeek: $dueThisWeek, dueThisMonth: $dueThisMonth, wordsDueToday: $wordsDueToday, wordsDueThisWeek: $wordsDueThisWeek, wordsDueThisMonth: $wordsDueThisMonth)';
}


}

/// @nodoc
abstract mixin class _$DueStatsCopyWith<$Res> implements $DueStatsCopyWith<$Res> {
  factory _$DueStatsCopyWith(_DueStats value, $Res Function(_DueStats) _then) = __$DueStatsCopyWithImpl;
@override @useResult
$Res call({
 int dueToday, int dueThisWeek, int dueThisMonth, int wordsDueToday, int wordsDueThisWeek, int wordsDueThisMonth
});




}
/// @nodoc
class __$DueStatsCopyWithImpl<$Res>
    implements _$DueStatsCopyWith<$Res> {
  __$DueStatsCopyWithImpl(this._self, this._then);

  final _DueStats _self;
  final $Res Function(_DueStats) _then;

/// Create a copy of DueStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dueToday = null,Object? dueThisWeek = null,Object? dueThisMonth = null,Object? wordsDueToday = null,Object? wordsDueThisWeek = null,Object? wordsDueThisMonth = null,}) {
  return _then(_DueStats(
dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,dueThisWeek: null == dueThisWeek ? _self.dueThisWeek : dueThisWeek // ignore: cast_nullable_to_non_nullable
as int,dueThisMonth: null == dueThisMonth ? _self.dueThisMonth : dueThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsDueToday: null == wordsDueToday ? _self.wordsDueToday : wordsDueToday // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisWeek: null == wordsDueThisWeek ? _self.wordsDueThisWeek : wordsDueThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisMonth: null == wordsDueThisMonth ? _self.wordsDueThisMonth : wordsDueThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
