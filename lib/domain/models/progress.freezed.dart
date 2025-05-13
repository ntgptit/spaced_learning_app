// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressSummary {

 String get id; String get moduleId; DateTime? get firstLearningDate; CycleStudied get cyclesStudied; DateTime? get nextStudyDate; double get percentComplete; DateTime? get createdAt; DateTime? get updatedAt; int get repetitionCount;
/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressSummaryCopyWith<ProgressSummary> get copyWith => _$ProgressSummaryCopyWithImpl<ProgressSummary>(this as ProgressSummary, _$identity);

  /// Serializes this ProgressSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.firstLearningDate, firstLearningDate) || other.firstLearningDate == firstLearningDate)&&(identical(other.cyclesStudied, cyclesStudied) || other.cyclesStudied == cyclesStudied)&&(identical(other.nextStudyDate, nextStudyDate) || other.nextStudyDate == nextStudyDate)&&(identical(other.percentComplete, percentComplete) || other.percentComplete == percentComplete)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.repetitionCount, repetitionCount) || other.repetitionCount == repetitionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moduleId,firstLearningDate,cyclesStudied,nextStudyDate,percentComplete,createdAt,updatedAt,repetitionCount);

@override
String toString() {
  return 'ProgressSummary(id: $id, moduleId: $moduleId, firstLearningDate: $firstLearningDate, cyclesStudied: $cyclesStudied, nextStudyDate: $nextStudyDate, percentComplete: $percentComplete, createdAt: $createdAt, updatedAt: $updatedAt, repetitionCount: $repetitionCount)';
}


}

/// @nodoc
abstract mixin class $ProgressSummaryCopyWith<$Res>  {
  factory $ProgressSummaryCopyWith(ProgressSummary value, $Res Function(ProgressSummary) _then) = _$ProgressSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String moduleId, DateTime? firstLearningDate, CycleStudied cyclesStudied, DateTime? nextStudyDate, double percentComplete, DateTime? createdAt, DateTime? updatedAt, int repetitionCount
});




}
/// @nodoc
class _$ProgressSummaryCopyWithImpl<$Res>
    implements $ProgressSummaryCopyWith<$Res> {
  _$ProgressSummaryCopyWithImpl(this._self, this._then);

  final ProgressSummary _self;
  final $Res Function(ProgressSummary) _then;

/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moduleId = null,Object? firstLearningDate = freezed,Object? cyclesStudied = null,Object? nextStudyDate = freezed,Object? percentComplete = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? repetitionCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String,firstLearningDate: freezed == firstLearningDate ? _self.firstLearningDate : firstLearningDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cyclesStudied: null == cyclesStudied ? _self.cyclesStudied : cyclesStudied // ignore: cast_nullable_to_non_nullable
as CycleStudied,nextStudyDate: freezed == nextStudyDate ? _self.nextStudyDate : nextStudyDate // ignore: cast_nullable_to_non_nullable
as DateTime?,percentComplete: null == percentComplete ? _self.percentComplete : percentComplete // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,repetitionCount: null == repetitionCount ? _self.repetitionCount : repetitionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ProgressSummary implements ProgressSummary {
  const _ProgressSummary({required this.id, required this.moduleId, this.firstLearningDate, this.cyclesStudied = CycleStudied.firstTime, this.nextStudyDate, this.percentComplete = 0, this.createdAt, this.updatedAt, this.repetitionCount = 0});
  factory _ProgressSummary.fromJson(Map<String, dynamic> json) => _$ProgressSummaryFromJson(json);

@override final  String id;
@override final  String moduleId;
@override final  DateTime? firstLearningDate;
@override@JsonKey() final  CycleStudied cyclesStudied;
@override final  DateTime? nextStudyDate;
@override@JsonKey() final  double percentComplete;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int repetitionCount;

/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressSummaryCopyWith<_ProgressSummary> get copyWith => __$ProgressSummaryCopyWithImpl<_ProgressSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.firstLearningDate, firstLearningDate) || other.firstLearningDate == firstLearningDate)&&(identical(other.cyclesStudied, cyclesStudied) || other.cyclesStudied == cyclesStudied)&&(identical(other.nextStudyDate, nextStudyDate) || other.nextStudyDate == nextStudyDate)&&(identical(other.percentComplete, percentComplete) || other.percentComplete == percentComplete)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.repetitionCount, repetitionCount) || other.repetitionCount == repetitionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moduleId,firstLearningDate,cyclesStudied,nextStudyDate,percentComplete,createdAt,updatedAt,repetitionCount);

@override
String toString() {
  return 'ProgressSummary(id: $id, moduleId: $moduleId, firstLearningDate: $firstLearningDate, cyclesStudied: $cyclesStudied, nextStudyDate: $nextStudyDate, percentComplete: $percentComplete, createdAt: $createdAt, updatedAt: $updatedAt, repetitionCount: $repetitionCount)';
}


}

/// @nodoc
abstract mixin class _$ProgressSummaryCopyWith<$Res> implements $ProgressSummaryCopyWith<$Res> {
  factory _$ProgressSummaryCopyWith(_ProgressSummary value, $Res Function(_ProgressSummary) _then) = __$ProgressSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String moduleId, DateTime? firstLearningDate, CycleStudied cyclesStudied, DateTime? nextStudyDate, double percentComplete, DateTime? createdAt, DateTime? updatedAt, int repetitionCount
});




}
/// @nodoc
class __$ProgressSummaryCopyWithImpl<$Res>
    implements _$ProgressSummaryCopyWith<$Res> {
  __$ProgressSummaryCopyWithImpl(this._self, this._then);

  final _ProgressSummary _self;
  final $Res Function(_ProgressSummary) _then;

/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moduleId = null,Object? firstLearningDate = freezed,Object? cyclesStudied = null,Object? nextStudyDate = freezed,Object? percentComplete = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? repetitionCount = null,}) {
  return _then(_ProgressSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String,firstLearningDate: freezed == firstLearningDate ? _self.firstLearningDate : firstLearningDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cyclesStudied: null == cyclesStudied ? _self.cyclesStudied : cyclesStudied // ignore: cast_nullable_to_non_nullable
as CycleStudied,nextStudyDate: freezed == nextStudyDate ? _self.nextStudyDate : nextStudyDate // ignore: cast_nullable_to_non_nullable
as DateTime?,percentComplete: null == percentComplete ? _self.percentComplete : percentComplete // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,repetitionCount: null == repetitionCount ? _self.repetitionCount : repetitionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProgressDetail {

 String get id; String get moduleId; String? get moduleTitle; String? get moduleUrl; String? get userName; DateTime? get firstLearningDate; CycleStudied get cyclesStudied; DateTime? get nextStudyDate; double get percentComplete; DateTime? get createdAt; DateTime? get updatedAt; List<Repetition> get repetitions;
/// Create a copy of ProgressDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressDetailCopyWith<ProgressDetail> get copyWith => _$ProgressDetailCopyWithImpl<ProgressDetail>(this as ProgressDetail, _$identity);

  /// Serializes this ProgressDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.moduleTitle, moduleTitle) || other.moduleTitle == moduleTitle)&&(identical(other.moduleUrl, moduleUrl) || other.moduleUrl == moduleUrl)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.firstLearningDate, firstLearningDate) || other.firstLearningDate == firstLearningDate)&&(identical(other.cyclesStudied, cyclesStudied) || other.cyclesStudied == cyclesStudied)&&(identical(other.nextStudyDate, nextStudyDate) || other.nextStudyDate == nextStudyDate)&&(identical(other.percentComplete, percentComplete) || other.percentComplete == percentComplete)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.repetitions, repetitions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moduleId,moduleTitle,moduleUrl,userName,firstLearningDate,cyclesStudied,nextStudyDate,percentComplete,createdAt,updatedAt,const DeepCollectionEquality().hash(repetitions));

@override
String toString() {
  return 'ProgressDetail(id: $id, moduleId: $moduleId, moduleTitle: $moduleTitle, moduleUrl: $moduleUrl, userName: $userName, firstLearningDate: $firstLearningDate, cyclesStudied: $cyclesStudied, nextStudyDate: $nextStudyDate, percentComplete: $percentComplete, createdAt: $createdAt, updatedAt: $updatedAt, repetitions: $repetitions)';
}


}

/// @nodoc
abstract mixin class $ProgressDetailCopyWith<$Res>  {
  factory $ProgressDetailCopyWith(ProgressDetail value, $Res Function(ProgressDetail) _then) = _$ProgressDetailCopyWithImpl;
@useResult
$Res call({
 String id, String moduleId, String? moduleTitle, String? moduleUrl, String? userName, DateTime? firstLearningDate, CycleStudied cyclesStudied, DateTime? nextStudyDate, double percentComplete, DateTime? createdAt, DateTime? updatedAt, List<Repetition> repetitions
});




}
/// @nodoc
class _$ProgressDetailCopyWithImpl<$Res>
    implements $ProgressDetailCopyWith<$Res> {
  _$ProgressDetailCopyWithImpl(this._self, this._then);

  final ProgressDetail _self;
  final $Res Function(ProgressDetail) _then;

/// Create a copy of ProgressDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moduleId = null,Object? moduleTitle = freezed,Object? moduleUrl = freezed,Object? userName = freezed,Object? firstLearningDate = freezed,Object? cyclesStudied = null,Object? nextStudyDate = freezed,Object? percentComplete = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? repetitions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String,moduleTitle: freezed == moduleTitle ? _self.moduleTitle : moduleTitle // ignore: cast_nullable_to_non_nullable
as String?,moduleUrl: freezed == moduleUrl ? _self.moduleUrl : moduleUrl // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,firstLearningDate: freezed == firstLearningDate ? _self.firstLearningDate : firstLearningDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cyclesStudied: null == cyclesStudied ? _self.cyclesStudied : cyclesStudied // ignore: cast_nullable_to_non_nullable
as CycleStudied,nextStudyDate: freezed == nextStudyDate ? _self.nextStudyDate : nextStudyDate // ignore: cast_nullable_to_non_nullable
as DateTime?,percentComplete: null == percentComplete ? _self.percentComplete : percentComplete // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as List<Repetition>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ProgressDetail implements ProgressDetail {
  const _ProgressDetail({required this.id, required this.moduleId, this.moduleTitle, this.moduleUrl, this.userName, this.firstLearningDate, this.cyclesStudied = CycleStudied.firstTime, this.nextStudyDate, this.percentComplete = 0, this.createdAt, this.updatedAt, final  List<Repetition> repetitions = const []}): _repetitions = repetitions;
  factory _ProgressDetail.fromJson(Map<String, dynamic> json) => _$ProgressDetailFromJson(json);

@override final  String id;
@override final  String moduleId;
@override final  String? moduleTitle;
@override final  String? moduleUrl;
@override final  String? userName;
@override final  DateTime? firstLearningDate;
@override@JsonKey() final  CycleStudied cyclesStudied;
@override final  DateTime? nextStudyDate;
@override@JsonKey() final  double percentComplete;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  List<Repetition> _repetitions;
@override@JsonKey() List<Repetition> get repetitions {
  if (_repetitions is EqualUnmodifiableListView) return _repetitions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repetitions);
}


/// Create a copy of ProgressDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressDetailCopyWith<_ProgressDetail> get copyWith => __$ProgressDetailCopyWithImpl<_ProgressDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.moduleTitle, moduleTitle) || other.moduleTitle == moduleTitle)&&(identical(other.moduleUrl, moduleUrl) || other.moduleUrl == moduleUrl)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.firstLearningDate, firstLearningDate) || other.firstLearningDate == firstLearningDate)&&(identical(other.cyclesStudied, cyclesStudied) || other.cyclesStudied == cyclesStudied)&&(identical(other.nextStudyDate, nextStudyDate) || other.nextStudyDate == nextStudyDate)&&(identical(other.percentComplete, percentComplete) || other.percentComplete == percentComplete)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._repetitions, _repetitions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moduleId,moduleTitle,moduleUrl,userName,firstLearningDate,cyclesStudied,nextStudyDate,percentComplete,createdAt,updatedAt,const DeepCollectionEquality().hash(_repetitions));

@override
String toString() {
  return 'ProgressDetail(id: $id, moduleId: $moduleId, moduleTitle: $moduleTitle, moduleUrl: $moduleUrl, userName: $userName, firstLearningDate: $firstLearningDate, cyclesStudied: $cyclesStudied, nextStudyDate: $nextStudyDate, percentComplete: $percentComplete, createdAt: $createdAt, updatedAt: $updatedAt, repetitions: $repetitions)';
}


}

/// @nodoc
abstract mixin class _$ProgressDetailCopyWith<$Res> implements $ProgressDetailCopyWith<$Res> {
  factory _$ProgressDetailCopyWith(_ProgressDetail value, $Res Function(_ProgressDetail) _then) = __$ProgressDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String moduleId, String? moduleTitle, String? moduleUrl, String? userName, DateTime? firstLearningDate, CycleStudied cyclesStudied, DateTime? nextStudyDate, double percentComplete, DateTime? createdAt, DateTime? updatedAt, List<Repetition> repetitions
});




}
/// @nodoc
class __$ProgressDetailCopyWithImpl<$Res>
    implements _$ProgressDetailCopyWith<$Res> {
  __$ProgressDetailCopyWithImpl(this._self, this._then);

  final _ProgressDetail _self;
  final $Res Function(_ProgressDetail) _then;

/// Create a copy of ProgressDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moduleId = null,Object? moduleTitle = freezed,Object? moduleUrl = freezed,Object? userName = freezed,Object? firstLearningDate = freezed,Object? cyclesStudied = null,Object? nextStudyDate = freezed,Object? percentComplete = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? repetitions = null,}) {
  return _then(_ProgressDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String,moduleTitle: freezed == moduleTitle ? _self.moduleTitle : moduleTitle // ignore: cast_nullable_to_non_nullable
as String?,moduleUrl: freezed == moduleUrl ? _self.moduleUrl : moduleUrl // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,firstLearningDate: freezed == firstLearningDate ? _self.firstLearningDate : firstLearningDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cyclesStudied: null == cyclesStudied ? _self.cyclesStudied : cyclesStudied // ignore: cast_nullable_to_non_nullable
as CycleStudied,nextStudyDate: freezed == nextStudyDate ? _self.nextStudyDate : nextStudyDate // ignore: cast_nullable_to_non_nullable
as DateTime?,percentComplete: null == percentComplete ? _self.percentComplete : percentComplete // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,repetitions: null == repetitions ? _self._repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as List<Repetition>,
  ));
}


}

// dart format on
