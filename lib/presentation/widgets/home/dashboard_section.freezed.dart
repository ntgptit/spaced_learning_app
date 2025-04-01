// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleStats {

 int get totalModules; int get completedModules; int get inProgressModules;
/// Create a copy of ModuleStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleStatsCopyWith<ModuleStats> get copyWith => _$ModuleStatsCopyWithImpl<ModuleStats>(this as ModuleStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleStats&&(identical(other.totalModules, totalModules) || other.totalModules == totalModules)&&(identical(other.completedModules, completedModules) || other.completedModules == completedModules)&&(identical(other.inProgressModules, inProgressModules) || other.inProgressModules == inProgressModules));
}


@override
int get hashCode => Object.hash(runtimeType,totalModules,completedModules,inProgressModules);

@override
String toString() {
  return 'ModuleStats(totalModules: $totalModules, completedModules: $completedModules, inProgressModules: $inProgressModules)';
}


}

/// @nodoc
abstract mixin class $ModuleStatsCopyWith<$Res>  {
  factory $ModuleStatsCopyWith(ModuleStats value, $Res Function(ModuleStats) _then) = _$ModuleStatsCopyWithImpl;
@useResult
$Res call({
 int totalModules, int completedModules, int inProgressModules
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
@pragma('vm:prefer-inline') @override $Res call({Object? totalModules = null,Object? completedModules = null,Object? inProgressModules = null,}) {
  return _then(_self.copyWith(
totalModules: null == totalModules ? _self.totalModules : totalModules // ignore: cast_nullable_to_non_nullable
as int,completedModules: null == completedModules ? _self.completedModules : completedModules // ignore: cast_nullable_to_non_nullable
as int,inProgressModules: null == inProgressModules ? _self.inProgressModules : inProgressModules // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _ModuleStats implements ModuleStats {
  const _ModuleStats({required this.totalModules, required this.completedModules, required this.inProgressModules});
  

@override final  int totalModules;
@override final  int completedModules;
@override final  int inProgressModules;

/// Create a copy of ModuleStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleStatsCopyWith<_ModuleStats> get copyWith => __$ModuleStatsCopyWithImpl<_ModuleStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleStats&&(identical(other.totalModules, totalModules) || other.totalModules == totalModules)&&(identical(other.completedModules, completedModules) || other.completedModules == completedModules)&&(identical(other.inProgressModules, inProgressModules) || other.inProgressModules == inProgressModules));
}


@override
int get hashCode => Object.hash(runtimeType,totalModules,completedModules,inProgressModules);

@override
String toString() {
  return 'ModuleStats(totalModules: $totalModules, completedModules: $completedModules, inProgressModules: $inProgressModules)';
}


}

/// @nodoc
abstract mixin class _$ModuleStatsCopyWith<$Res> implements $ModuleStatsCopyWith<$Res> {
  factory _$ModuleStatsCopyWith(_ModuleStats value, $Res Function(_ModuleStats) _then) = __$ModuleStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalModules, int completedModules, int inProgressModules
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
@override @pragma('vm:prefer-inline') $Res call({Object? totalModules = null,Object? completedModules = null,Object? inProgressModules = null,}) {
  return _then(_ModuleStats(
totalModules: null == totalModules ? _self.totalModules : totalModules // ignore: cast_nullable_to_non_nullable
as int,completedModules: null == completedModules ? _self.completedModules : completedModules // ignore: cast_nullable_to_non_nullable
as int,inProgressModules: null == inProgressModules ? _self.inProgressModules : inProgressModules // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

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

/// @nodoc
mixin _$CompletionStats {

 int get completedToday; int get completedThisWeek; int get completedThisMonth; int get wordsCompletedToday; int get wordsCompletedThisWeek; int get wordsCompletedThisMonth;
/// Create a copy of CompletionStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletionStatsCopyWith<CompletionStats> get copyWith => _$CompletionStatsCopyWithImpl<CompletionStats>(this as CompletionStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletionStats&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.completedThisWeek, completedThisWeek) || other.completedThisWeek == completedThisWeek)&&(identical(other.completedThisMonth, completedThisMonth) || other.completedThisMonth == completedThisMonth)&&(identical(other.wordsCompletedToday, wordsCompletedToday) || other.wordsCompletedToday == wordsCompletedToday)&&(identical(other.wordsCompletedThisWeek, wordsCompletedThisWeek) || other.wordsCompletedThisWeek == wordsCompletedThisWeek)&&(identical(other.wordsCompletedThisMonth, wordsCompletedThisMonth) || other.wordsCompletedThisMonth == wordsCompletedThisMonth));
}


@override
int get hashCode => Object.hash(runtimeType,completedToday,completedThisWeek,completedThisMonth,wordsCompletedToday,wordsCompletedThisWeek,wordsCompletedThisMonth);

@override
String toString() {
  return 'CompletionStats(completedToday: $completedToday, completedThisWeek: $completedThisWeek, completedThisMonth: $completedThisMonth, wordsCompletedToday: $wordsCompletedToday, wordsCompletedThisWeek: $wordsCompletedThisWeek, wordsCompletedThisMonth: $wordsCompletedThisMonth)';
}


}

/// @nodoc
abstract mixin class $CompletionStatsCopyWith<$Res>  {
  factory $CompletionStatsCopyWith(CompletionStats value, $Res Function(CompletionStats) _then) = _$CompletionStatsCopyWithImpl;
@useResult
$Res call({
 int completedToday, int completedThisWeek, int completedThisMonth, int wordsCompletedToday, int wordsCompletedThisWeek, int wordsCompletedThisMonth
});




}
/// @nodoc
class _$CompletionStatsCopyWithImpl<$Res>
    implements $CompletionStatsCopyWith<$Res> {
  _$CompletionStatsCopyWithImpl(this._self, this._then);

  final CompletionStats _self;
  final $Res Function(CompletionStats) _then;

/// Create a copy of CompletionStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedToday = null,Object? completedThisWeek = null,Object? completedThisMonth = null,Object? wordsCompletedToday = null,Object? wordsCompletedThisWeek = null,Object? wordsCompletedThisMonth = null,}) {
  return _then(_self.copyWith(
completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as int,completedThisWeek: null == completedThisWeek ? _self.completedThisWeek : completedThisWeek // ignore: cast_nullable_to_non_nullable
as int,completedThisMonth: null == completedThisMonth ? _self.completedThisMonth : completedThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedToday: null == wordsCompletedToday ? _self.wordsCompletedToday : wordsCompletedToday // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisWeek: null == wordsCompletedThisWeek ? _self.wordsCompletedThisWeek : wordsCompletedThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisMonth: null == wordsCompletedThisMonth ? _self.wordsCompletedThisMonth : wordsCompletedThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _CompletionStats implements CompletionStats {
  const _CompletionStats({required this.completedToday, required this.completedThisWeek, required this.completedThisMonth, required this.wordsCompletedToday, required this.wordsCompletedThisWeek, required this.wordsCompletedThisMonth});
  

@override final  int completedToday;
@override final  int completedThisWeek;
@override final  int completedThisMonth;
@override final  int wordsCompletedToday;
@override final  int wordsCompletedThisWeek;
@override final  int wordsCompletedThisMonth;

/// Create a copy of CompletionStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletionStatsCopyWith<_CompletionStats> get copyWith => __$CompletionStatsCopyWithImpl<_CompletionStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletionStats&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.completedThisWeek, completedThisWeek) || other.completedThisWeek == completedThisWeek)&&(identical(other.completedThisMonth, completedThisMonth) || other.completedThisMonth == completedThisMonth)&&(identical(other.wordsCompletedToday, wordsCompletedToday) || other.wordsCompletedToday == wordsCompletedToday)&&(identical(other.wordsCompletedThisWeek, wordsCompletedThisWeek) || other.wordsCompletedThisWeek == wordsCompletedThisWeek)&&(identical(other.wordsCompletedThisMonth, wordsCompletedThisMonth) || other.wordsCompletedThisMonth == wordsCompletedThisMonth));
}


@override
int get hashCode => Object.hash(runtimeType,completedToday,completedThisWeek,completedThisMonth,wordsCompletedToday,wordsCompletedThisWeek,wordsCompletedThisMonth);

@override
String toString() {
  return 'CompletionStats(completedToday: $completedToday, completedThisWeek: $completedThisWeek, completedThisMonth: $completedThisMonth, wordsCompletedToday: $wordsCompletedToday, wordsCompletedThisWeek: $wordsCompletedThisWeek, wordsCompletedThisMonth: $wordsCompletedThisMonth)';
}


}

/// @nodoc
abstract mixin class _$CompletionStatsCopyWith<$Res> implements $CompletionStatsCopyWith<$Res> {
  factory _$CompletionStatsCopyWith(_CompletionStats value, $Res Function(_CompletionStats) _then) = __$CompletionStatsCopyWithImpl;
@override @useResult
$Res call({
 int completedToday, int completedThisWeek, int completedThisMonth, int wordsCompletedToday, int wordsCompletedThisWeek, int wordsCompletedThisMonth
});




}
/// @nodoc
class __$CompletionStatsCopyWithImpl<$Res>
    implements _$CompletionStatsCopyWith<$Res> {
  __$CompletionStatsCopyWithImpl(this._self, this._then);

  final _CompletionStats _self;
  final $Res Function(_CompletionStats) _then;

/// Create a copy of CompletionStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedToday = null,Object? completedThisWeek = null,Object? completedThisMonth = null,Object? wordsCompletedToday = null,Object? wordsCompletedThisWeek = null,Object? wordsCompletedThisMonth = null,}) {
  return _then(_CompletionStats(
completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as int,completedThisWeek: null == completedThisWeek ? _self.completedThisWeek : completedThisWeek // ignore: cast_nullable_to_non_nullable
as int,completedThisMonth: null == completedThisMonth ? _self.completedThisMonth : completedThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedToday: null == wordsCompletedToday ? _self.wordsCompletedToday : wordsCompletedToday // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisWeek: null == wordsCompletedThisWeek ? _self.wordsCompletedThisWeek : wordsCompletedThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisMonth: null == wordsCompletedThisMonth ? _self.wordsCompletedThisMonth : wordsCompletedThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

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

/// @nodoc
mixin _$VocabularyStats {

 int get totalWords; int get learnedWords; int get pendingWords; double get vocabularyCompletionRate; double get weeklyNewWordsRate;
/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyStatsCopyWith<VocabularyStats> get copyWith => _$VocabularyStatsCopyWithImpl<VocabularyStats>(this as VocabularyStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyStats&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.learnedWords, learnedWords) || other.learnedWords == learnedWords)&&(identical(other.pendingWords, pendingWords) || other.pendingWords == pendingWords)&&(identical(other.vocabularyCompletionRate, vocabularyCompletionRate) || other.vocabularyCompletionRate == vocabularyCompletionRate)&&(identical(other.weeklyNewWordsRate, weeklyNewWordsRate) || other.weeklyNewWordsRate == weeklyNewWordsRate));
}


@override
int get hashCode => Object.hash(runtimeType,totalWords,learnedWords,pendingWords,vocabularyCompletionRate,weeklyNewWordsRate);

@override
String toString() {
  return 'VocabularyStats(totalWords: $totalWords, learnedWords: $learnedWords, pendingWords: $pendingWords, vocabularyCompletionRate: $vocabularyCompletionRate, weeklyNewWordsRate: $weeklyNewWordsRate)';
}


}

/// @nodoc
abstract mixin class $VocabularyStatsCopyWith<$Res>  {
  factory $VocabularyStatsCopyWith(VocabularyStats value, $Res Function(VocabularyStats) _then) = _$VocabularyStatsCopyWithImpl;
@useResult
$Res call({
 int totalWords, int learnedWords, int pendingWords, double vocabularyCompletionRate, double weeklyNewWordsRate
});




}
/// @nodoc
class _$VocabularyStatsCopyWithImpl<$Res>
    implements $VocabularyStatsCopyWith<$Res> {
  _$VocabularyStatsCopyWithImpl(this._self, this._then);

  final VocabularyStats _self;
  final $Res Function(VocabularyStats) _then;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalWords = null,Object? learnedWords = null,Object? pendingWords = null,Object? vocabularyCompletionRate = null,Object? weeklyNewWordsRate = null,}) {
  return _then(_self.copyWith(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,learnedWords: null == learnedWords ? _self.learnedWords : learnedWords // ignore: cast_nullable_to_non_nullable
as int,pendingWords: null == pendingWords ? _self.pendingWords : pendingWords // ignore: cast_nullable_to_non_nullable
as int,vocabularyCompletionRate: null == vocabularyCompletionRate ? _self.vocabularyCompletionRate : vocabularyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWordsRate: null == weeklyNewWordsRate ? _self.weeklyNewWordsRate : weeklyNewWordsRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _VocabularyStats implements VocabularyStats {
  const _VocabularyStats({required this.totalWords, required this.learnedWords, required this.pendingWords, required this.vocabularyCompletionRate, required this.weeklyNewWordsRate});
  

@override final  int totalWords;
@override final  int learnedWords;
@override final  int pendingWords;
@override final  double vocabularyCompletionRate;
@override final  double weeklyNewWordsRate;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyStatsCopyWith<_VocabularyStats> get copyWith => __$VocabularyStatsCopyWithImpl<_VocabularyStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyStats&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.learnedWords, learnedWords) || other.learnedWords == learnedWords)&&(identical(other.pendingWords, pendingWords) || other.pendingWords == pendingWords)&&(identical(other.vocabularyCompletionRate, vocabularyCompletionRate) || other.vocabularyCompletionRate == vocabularyCompletionRate)&&(identical(other.weeklyNewWordsRate, weeklyNewWordsRate) || other.weeklyNewWordsRate == weeklyNewWordsRate));
}


@override
int get hashCode => Object.hash(runtimeType,totalWords,learnedWords,pendingWords,vocabularyCompletionRate,weeklyNewWordsRate);

@override
String toString() {
  return 'VocabularyStats(totalWords: $totalWords, learnedWords: $learnedWords, pendingWords: $pendingWords, vocabularyCompletionRate: $vocabularyCompletionRate, weeklyNewWordsRate: $weeklyNewWordsRate)';
}


}

/// @nodoc
abstract mixin class _$VocabularyStatsCopyWith<$Res> implements $VocabularyStatsCopyWith<$Res> {
  factory _$VocabularyStatsCopyWith(_VocabularyStats value, $Res Function(_VocabularyStats) _then) = __$VocabularyStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalWords, int learnedWords, int pendingWords, double vocabularyCompletionRate, double weeklyNewWordsRate
});




}
/// @nodoc
class __$VocabularyStatsCopyWithImpl<$Res>
    implements _$VocabularyStatsCopyWith<$Res> {
  __$VocabularyStatsCopyWithImpl(this._self, this._then);

  final _VocabularyStats _self;
  final $Res Function(_VocabularyStats) _then;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalWords = null,Object? learnedWords = null,Object? pendingWords = null,Object? vocabularyCompletionRate = null,Object? weeklyNewWordsRate = null,}) {
  return _then(_VocabularyStats(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,learnedWords: null == learnedWords ? _self.learnedWords : learnedWords // ignore: cast_nullable_to_non_nullable
as int,pendingWords: null == pendingWords ? _self.pendingWords : pendingWords // ignore: cast_nullable_to_non_nullable
as int,vocabularyCompletionRate: null == vocabularyCompletionRate ? _self.vocabularyCompletionRate : vocabularyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWordsRate: null == weeklyNewWordsRate ? _self.weeklyNewWordsRate : weeklyNewWordsRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
